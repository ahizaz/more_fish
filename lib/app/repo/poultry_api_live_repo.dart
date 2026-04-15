import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../service/local_storage.dart';
import '../service/service.dart';
import 'poultry_live_models.dart';
import 'poultry_live_repo.dart';

class PoultryApiLiveRepository implements PoultryLiveRepository {
  final LoginTokenStorage _loginTokenStorage = Get.find<LoginTokenStorage>();
  List<Map<String, dynamic>>? _cachedFarms;
  DateTime? _lastFetchedAt;

  static const Duration _cacheTtl = Duration(seconds: 8);

  Uri get _farmListUri =>
      Uri.parse('${ApiService.baseUrl}/poultry_care/farms/list/');

  Uri _dashboardUri(int farmId) => Uri.parse(
    '${ApiService.baseUrl}/poultry_care/farms/dashboard/?farm_id=$farmId',
  );

  Uri get _switchCommandUri =>
      Uri.parse('${ApiService.baseUrl}/poultry_care/switches/command/');

  @override
  Future<List<PoultryDevice>> getDevices() async {
    final farms = await _fetchFarms();
    return farms.map(_toFarmDevice).toList();
  }

  @override
  Future<PoultryLiveData> getLatestLiveData({required String deviceId}) async {
    final farms = await _fetchFarms();
    if (farms.isEmpty) {
      throw Exception('No farm found for poultry live monitoring.');
    }

    final farmId = _resolveFarmId(deviceId: deviceId, farms: farms);
    final token = _getToken();

    final uri = _dashboardUri(farmId);
    debugPrint('Poultry dashboard GET: $uri');
    debugPrint('Poultry dashboard token exists: ${token.isNotEmpty}');

    final response = await http.get(uri, headers: _headers(token));

    debugPrint('Poultry dashboard status: ${response.statusCode}');
    debugPrint('Poultry dashboard body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(
        'Dashboard API failed with status ${response.statusCode}',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid dashboard response format.');
    }

    final ok = decoded['success'];
    if (ok is bool && !ok) {
      throw Exception(
        decoded['message']?.toString() ?? 'Dashboard API failed.',
      );
    }

    final data = _map(decoded['data']);
    final device = _map(data['device']);

    return _toLiveData(data: data, device: device, selectedDeviceId: deviceId);
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

  Future<List<Map<String, dynamic>>> _fetchFarms() async {
    final cachedFarms = _cachedFarms;
    final lastFetchedAt = _lastFetchedAt;
    if (cachedFarms != null && lastFetchedAt != null) {
      final age = DateTime.now().difference(lastFetchedAt);
      if (age <= _cacheTtl) {
        return cachedFarms;
      }
    }

    final token = _getToken();

    debugPrint('Poultry farm list GET: $_farmListUri');
    debugPrint('Poultry farm list token exists: ${token.isNotEmpty}');

    final response = await http.get(_farmListUri, headers: _headers(token));

    debugPrint('Poultry farm list status: ${response.statusCode}');
    debugPrint('Poultry farm list body: ${response.body}');

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

    final farms = data
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    _cachedFarms = List<Map<String, dynamic>>.unmodifiable(farms);
    _lastFetchedAt = DateTime.now();

    return _cachedFarms!;
  }

  PoultryDevice _toFarmDevice(Map<String, dynamic> farm) {
    final id = _string(farm['id']);
    final displayName = _string(farm['name']).isNotEmpty
        ? _string(farm['name'])
        : 'Farm $id';

    return PoultryDevice(id: id, name: displayName);
  }

  PoultryLiveData _toLiveData({
    required Map<String, dynamic> data,
    required Map<String, dynamic> device,
    required String selectedDeviceId,
  }) {
    final sensors = _listOfMap(device['sensors']);
    final switches = _listOfMap(
      device['switches'],
    ).map(PoultrySwitch.fromJson).toList();

    final resolvedDeviceId = _firstNonEmpty([
      _string(device['client_id']),
      _string(device['device_name']),
      _string(data['farm_name']),
      selectedDeviceId,
    ]);

    final ts = _firstNonEmpty([
      _string(data['updated_at']),
      _string(device['updated_at']),
      _string(data['timestamp']),
      DateTime.now().toUtc().toIso8601String(),
    ]);

    return PoultryLiveData(
      deviceId: resolvedDeviceId.isEmpty ? selectedDeviceId : resolvedDeviceId,
      timestamp: ts,
      aqi: _sensorValue(sensors, aliases: const ['aqi', 'air quality index']),
      nh3MgL: _sensorValue(sensors, aliases: const ['nh3', 'ammonia']),
      temperatureC: _sensorValue(
        sensors,
        aliases: const ['temperature', 'temp'],
      ),
      refTemperatureC: _sensorValue(
        sensors,
        aliases: const ['ref temperature', 'reference temperature'],
      ),
      humidityPct: _sensorValue(sensors, aliases: const ['humidity']).round(),
      vocMgM3: _sensorValue(sensors, aliases: const ['tvoc', 'voc']),
      co2Ppm: _sensorValue(
        sensors,
        aliases: const ['co2', 'carbon dioxide'],
      ).round(),
      ch4Ppm: _sensorValue(sensors, aliases: const ['ch4', 'methane']).round(),
      pm1UgM3: _sensorValue(sensors, aliases: const ['pm1']).round(),
      pm25UgM3: _sensorValue(sensors, aliases: const ['pm2.5', 'pm25']).round(),
      pm4UgM3: _sensorValue(sensors, aliases: const ['pm4']).round(),
      pm10UgM3: _sensorValue(sensors, aliases: const ['pm10']).round(),
      noiseDb: _sensorValue(
        sensors,
        aliases: const ['noise', 'sound', 'db'],
      ).round(),
      lightLux: _sensorValue(sensors, aliases: const ['light', 'lux']).round(),
      switches: switches,
    );
  }

  int _resolveFarmId({
    required String deviceId,
    required List<Map<String, dynamic>> farms,
  }) {
    final parsed = int.tryParse(deviceId);
    if (parsed != null) return parsed;

    final byName = farms.where((farm) {
      final name = _string(farm['name']).trim().toLowerCase();
      return name == deviceId.trim().toLowerCase();
    }).toList();

    if (byName.isNotEmpty) {
      final id = int.tryParse(_string(byName.first['id']));
      if (id != null) return id;
    }

    final fallback = int.tryParse(_string(farms.first['id']));
    if (fallback == null) {
      throw Exception('Invalid farm id from farm list response.');
    }
    return fallback;
  }

  String _getToken() {
    final token = _loginTokenStorage.getToken();
    if (token == null || token.trim().isEmpty) {
      throw Exception('Missing auth token for poultry care API.');
    }
    return token;
  }

  Map<String, String> _headers(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  double _sensorValue(
    List<Map<String, dynamic>> sensors, {
    required List<String> aliases,
  }) {
    for (final sensor in sensors) {
      final descriptor = _normalized(
        _firstNonEmpty([
          _string(sensor['sensor_name']),
          _string(sensor['switch_name']),
          _string(sensor['sensor_type']),
          _string(sensor['name']),
          _string(sensor['type']),
          _string(sensor['key']),
          _string(sensor['label']),
          _string(sensor['title']),
        ]),
      );

      for (final alias in aliases) {
        if (descriptor.contains(_normalized(alias))) {
          return _double(_extractSensorValue(sensor));
        }
      }
    }

    return 0;
  }

  dynamic _extractSensorValue(Map<String, dynamic> sensor) {
    for (final key in const [
      'value',
      'reading',
      'current_value',
      'sensor_value',
      'measured_value',
    ]) {
      final value = sensor[key];
      if (value != null) {
        return value;
      }
    }

    final data = sensor['data'];
    if (data is Map<String, dynamic>) {
      return data['value'];
    }
    if (data is Map) {
      final mapped = Map<String, dynamic>.from(data);
      return mapped['value'];
    }

    return 0;
  }

  List<Map<String, dynamic>> _listOfMap(dynamic value) {
    if (value is! List) return const <Map<String, dynamic>>[];
    return value
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  String _normalized(String value) {
    return value.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), ' ');
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

  double _double(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse('$value') ?? 0.0;
  }
}
