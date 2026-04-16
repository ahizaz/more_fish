import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../service/service.dart';
import '../service/local_storage.dart';
import 'poultry_live_models.dart';
import 'poultry_live_repo.dart';

class PoultryApiLiveRepository implements PoultryLiveRepository {
  Uri get _farmListUri =>
      Uri.parse('${ApiService.baseUrl}/poultry_care/farms/list/');

  Uri _farmDashboardUri(int farmId) => Uri.parse(
    '${ApiService.baseUrl}/poultry_care/farms/dashboard/?farm_id=$farmId',
  );

  Uri get _switchCommandUri =>
      Uri.parse('${ApiService.baseUrl}/poultry_care/switches/command/');

  @override
  Future<List<PoultryDevice>> getDevices() async {
    final farms = await _fetchFarmList();
    return farms.map(_toFarmDevice).toList();
  }

  @override
  Future<PoultryLiveData> getLatestLiveData({required String deviceId}) async {
    final farmId = int.tryParse(deviceId.trim());
    if (farmId == null) {
      throw Exception('Invalid farm id: $deviceId');
    }

    final dashboard = await _fetchFarmDashboard(farmId: farmId);

    return _toLiveDataFromDashboard(
      dashboardData: dashboard,
      selectedDeviceId: deviceId,
    );
  }

  @override
  Future<void> setSwitchState({
    required String switchId,
    required bool turnOn,
  }) async {
    final token = _getToken();

    final body = jsonEncode({'switch_id': switchId, 'command': turnOn ? 1 : 0});

    debugPrint('Poultry switch command POST: $_switchCommandUri');
    debugPrint('Poultry switch command payload: $body');

    final response = await http.post(
      _switchCommandUri,
      headers: _headers(token),
      body: body,
    );

    debugPrint('Poultry switch command status: ${response.statusCode}');
    debugPrint('Poultry switch command body: ${response.body}');

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Switch command failed with status ${response.statusCode}',
      );
    }

    final responseBody = response.body.trim();
    if (responseBody.isNotEmpty) {
      final decoded = jsonDecode(responseBody);
      if (decoded is Map<String, dynamic>) {
        final ok = decoded['success'];
        if (ok is bool && !ok) {
          throw Exception(
            decoded['message']?.toString() ??
                'Switch command was not successful.',
          );
        }
      }
    }
  }

  Future<List<Map<String, dynamic>>> _fetchFarmList() async {
    final token = _getToken();

    debugPrint('Poultry farms-list GET: $_farmListUri');
    debugPrint('Poultry farms-list token exists: ${token.isNotEmpty}');

    final response = await http.get(_farmListUri, headers: _headers(token));

    debugPrint('Poultry farms-list status: ${response.statusCode}');
    debugPrint('Poultry farms-list body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(
        'Farm list API failed with status ${response.statusCode}',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid farm list response format.');
    }

    final ok = decoded['success'];
    if (ok is bool && !ok) {
      throw Exception(
        decoded['message']?.toString() ?? 'Farm list API failed.',
      );
    }

    final data = decoded['data'];
    if (data is! List) {
      throw Exception('Farm list response missing data list.');
    }

    return data
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<Map<String, dynamic>> _fetchFarmDashboard({
    required int farmId,
  }) async {
    final token = _getToken();
    final uri = _farmDashboardUri(farmId);

    debugPrint('Poultry farm-dashboard GET: $uri');
    debugPrint('Poultry farm-dashboard token exists: ${token.isNotEmpty}');

    final response = await http.get(uri, headers: _headers(token));

    debugPrint('Poultry farm-dashboard status: ${response.statusCode}');
    debugPrint('Poultry farm-dashboard body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(
        'Farm dashboard API failed with status ${response.statusCode}',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid farm dashboard response format.');
    }

    final ok = decoded['success'];
    if (ok is bool && !ok) {
      throw Exception(
        decoded['message']?.toString() ?? 'Farm dashboard API failed.',
      );
    }

    final data = decoded['data'];
    if (data is! Map) {
      throw Exception('Farm dashboard response missing data object.');
    }

    return Map<String, dynamic>.from(data);
  }

  PoultryDevice _toFarmDevice(Map<String, dynamic> farm) {
    final farmId = _string(farm['id']);
    final displayName = _firstNonEmpty([
      _string(farm['name']),
      _string(farm['location']),
      'Farm $farmId',
    ]);

    return PoultryDevice(id: farmId, name: displayName);
  }

  PoultryLiveData _toLiveDataFromDashboard({
    required Map<String, dynamic> dashboardData,
    required String selectedDeviceId,
  }) {
    final device = _map(dashboardData['device']);
    final sensorsRaw = device['sensors'];
    final sensors = sensorsRaw is List
        ? sensorsRaw.whereType<Map>().map((e) => _map(e)).toList()
        : const <Map<String, dynamic>>[];

    final values = _extractSensorValues(sensors);

    final resolvedDeviceId = _firstNonEmpty([
      _string(device['client_id']),
      _string(device['device_name']),
      _string(dashboardData['farm_name']),
      selectedDeviceId,
    ]);

    final ts = _firstNonEmpty([
      _string(_sensorValueByName(sensors, 'temperature', field: 'data_time')),
      _string(_sensorValueByName(sensors, 'humidity', field: 'data_time')),
      DateTime.now().toUtc().toIso8601String(),
    ]);

    return PoultryLiveData(
      deviceId: resolvedDeviceId.isEmpty ? selectedDeviceId : resolvedDeviceId,
      timestamp: ts,
      aqi: _double(values['aqi']),
      nh3MgL: _double(values['nh3_gas']),
      temperatureC: _double(values['temperature']),
      refTemperatureC: null,
      humidityPct: _double(values['humidity']).round(),
      vocMgM3: _double(values['tvoc']),
      co2Ppm: _double(values['co2']).round(),
      ch4Ppm: _double(values['methane_ppm']).round(),
      pm1UgM3: 0,
      pm25UgM3: 0,
      pm4UgM3: 0,
      pm10UgM3: 0,
      noiseDb: _double(values['sound_db']).round(),
      lightLux: _double(values['light_intensity']).round(),
      metrics: _extractAllMetrics(sensors),
      switches: _extractSwitches(dashboardData),
    );
  }

  Map<String, double> _extractSensorValues(List<Map<String, dynamic>> sensors) {
    final result = <String, double>{};

    double valueOf(String name) {
      return _double(_sensorValueByName(sensors, name, field: 'last_value'));
    }

    result['temperature'] = valueOf('temperature');
    result['humidity'] = valueOf('humidity');
    result['co2'] = valueOf('co2');
    result['nh3_gas'] = valueOf('nh3_gas');
    result['aqi'] = valueOf('aqi');
    result['sound_db'] = valueOf('sound_db');
    result['tvoc'] = valueOf('tvoc');
    result['methane_ppm'] = valueOf('methane_ppm');
    result['light_intensity'] = valueOf('light_intensity');

    return result;
  }

  List<PoultrySensorMetric> _extractAllMetrics(
    List<Map<String, dynamic>> sensors,
  ) {
    return sensors.map((sensor) {
      final rawName = _string(sensor['name']);
      final normalizedName = rawName.trim().toLowerCase();
      return PoultrySensorMetric(
        name: normalizedName,
        title: _metricTitle(normalizedName),
        unit: _string(sensor['unit']),
        value: _double(sensor['last_value']),
        dangerStatus: _string(sensor['danger_status']),
        dataTime: _string(sensor['data_time']),
      );
    }).toList();
  }

  String _metricTitle(String normalizedName) {
    switch (normalizedName) {
      case 'aqi':
        return 'Air Quality Index (AQI)';
      case 'nh3_gas':
        return 'Ammonia (NH3)';
      case 'co2':
        return 'Carbon dioxide';
      case 'tvoc':
        return 'TVOC';
      case 'sound_db':
        return 'Sound';
      case 'methane_ppm':
        return 'Methane (CH4)';
      case 'light_intensity':
        return 'Light intensity';
      default:
        return normalizedName
            .split('_')
            .where((e) => e.isNotEmpty)
            .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
            .join(' ');
    }
  }

  dynamic _sensorValueByName(
    List<Map<String, dynamic>> sensors,
    String name, {
    required String field,
  }) {
    final normalized = name.trim().toLowerCase();
    for (final sensor in sensors) {
      final sensorName = _string(sensor['name']).trim().toLowerCase();
      if (sensorName == normalized) {
        return sensor[field];
      }
    }
    return null;
  }

  List<PoultrySwitch> _extractSwitches(Map<String, dynamic> dashboardData) {
    final device = _map(dashboardData['device']);
    final switchesRaw = device['switches'];
    if (switchesRaw is! List) {
      return const <PoultrySwitch>[];
    }

    return switchesRaw
        .whereType<Map>()
        .map((e) => PoultrySwitch.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  String _getToken() {
    if (Get.isRegistered<LoginTokenStorage>()) {
      final token = Get.find<LoginTokenStorage>().getToken();
      if (_isValidToken(token)) {
        return token!.trim();
      }
    }

    throw Exception('Missing bearer token. Please login again.');
  }

  Map<String, String> _headers(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  String _firstNonEmpty(List<String> values) {
    for (final item in values) {
      if (item.trim().isNotEmpty) {
        return item;
      }
    }
    return '';
  }

  Map<String, dynamic> _map(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return <String, dynamic>{};
  }

  String _string(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  bool _isValidToken(String? token) {
    if (token == null) return false;
    final normalized = token.trim().toLowerCase();
    return normalized.isNotEmpty &&
        normalized != 'null' &&
        normalized != 'undefined';
  }

  double _double(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse('$value') ?? 0.0;
  }
}
