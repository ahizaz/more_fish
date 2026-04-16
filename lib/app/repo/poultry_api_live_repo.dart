import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../service/service.dart';
import '../service/local_storage.dart';
import 'poultry_live_models.dart';
import 'poultry_live_repo.dart';

class PoultryApiLiveRepository implements PoultryLiveRepository {
  List<Map<String, dynamic>>? _cachedReadings;
  DateTime? _lastFetchedAt;

  static const Duration _cacheTtl = Duration(seconds: 8);
  static const String _fallbackBearerToken =
      '21067c389d5d27d6ecfd22dc13e0ccb792714ad6';

  Uri get _latestReadingsUri =>
      Uri.parse('${ApiService.baseUrl}/poultry_care/api/latest-readings/');

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

    final readings = await _fetchLatestReadings();
    if (readings.isEmpty) {
      throw Exception('No device readings found for poultry live monitoring.');
    }

    final dashboard = await _fetchFarmDashboard(farmId: farmId);

    final selected = _pickDeviceReading(deviceId: deviceId, readings: readings);
    final token = _getToken();
    debugPrint('Poultry latest-readings token exists: ${token.isNotEmpty}');

    return _toLiveData(
      reading: selected,
      selectedDeviceId: deviceId,
      switches: _extractSwitches(dashboard),
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

  Future<List<Map<String, dynamic>>> _fetchLatestReadings() async {
    final cachedReadings = _cachedReadings;
    final lastFetchedAt = _lastFetchedAt;
    if (cachedReadings != null && lastFetchedAt != null) {
      final age = DateTime.now().difference(lastFetchedAt);
      if (age <= _cacheTtl) {
        return cachedReadings;
      }
    }

    final token = _getToken();

    debugPrint('Poultry latest-readings GET: $_latestReadingsUri');
    debugPrint('Poultry latest-readings token exists: ${token.isNotEmpty}');

    final response = await http.get(
      _latestReadingsUri,
      headers: _headers(token),
    );

    debugPrint('Poultry latest-readings status: ${response.statusCode}');
    debugPrint('Poultry latest-readings body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(
        'Latest readings API failed with status ${response.statusCode}',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid latest readings response format.');
    }

    final ok = decoded['success'];
    if (ok is bool && !ok) {
      throw Exception(
        decoded['message']?.toString() ?? 'Latest readings API failed.',
      );
    }

    final data = decoded['data'];
    if (data is! List) {
      throw Exception('Latest readings response missing data list.');
    }

    final readings = data
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    _cachedReadings = List<Map<String, dynamic>>.unmodifiable(readings);
    _lastFetchedAt = DateTime.now();

    return _cachedReadings!;
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

  Map<String, dynamic> _pickDeviceReading({
    required String deviceId,
    required List<Map<String, dynamic>> readings,
  }) {
    final normalizedDeviceId = deviceId.trim().toLowerCase();

    for (final reading in readings) {
      final possibleIds = [
        _string(reading['client_id']).trim().toLowerCase(),
        _string(reading['id']).trim().toLowerCase(),
        _string(reading['name']).trim().toLowerCase(),
        _string(reading['farm_id']).trim().toLowerCase(),
      ];
      if (possibleIds.contains(normalizedDeviceId)) {
        return reading;
      }
    }

    return readings.first;
  }

  PoultryLiveData _toLiveData({
    required Map<String, dynamic> reading,
    required String selectedDeviceId,
    required List<PoultrySwitch> switches,
  }) {
    final latestReading = _map(reading['latest_reading']);
    final values = _map(latestReading['data']);

    final resolvedDeviceId = _firstNonEmpty([
      _string(reading['client_id']),
      _string(reading['name']),
      _string(reading['farm_name']),
      selectedDeviceId,
    ]);

    final ts = _firstNonEmpty([
      _string(latestReading['timestamp']),
      _string(reading['updated_at']),
      _string(reading['timestamp']),
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
      lightLux: 0,
      switches: switches,
    );
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

    return _fallbackBearerToken;
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
