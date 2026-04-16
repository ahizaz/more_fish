import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../service/service.dart';
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

  Uri get _switchCommandUri =>
      Uri.parse('${ApiService.baseUrl}/poultry_care/switches/command/');

  @override
  Future<List<PoultryDevice>> getDevices() async {
    final readings = await _fetchLatestReadings();
    return readings.map(_toDevice).toList();
  }

  @override
  Future<PoultryLiveData> getLatestLiveData({required String deviceId}) async {
    final readings = await _fetchLatestReadings();
    if (readings.isEmpty) {
      throw Exception('No device readings found for poultry live monitoring.');
    }

    final selected = _pickDeviceReading(deviceId: deviceId, readings: readings);
    final token = _getToken();
    debugPrint('Poultry latest-readings token exists: ${token.isNotEmpty}');

    return _toLiveData(reading: selected, selectedDeviceId: deviceId);
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

    final response = await http.get(_latestReadingsUri, headers: _headers(token));

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

  PoultryDevice _toDevice(Map<String, dynamic> reading) {
    final id = _firstNonEmpty([
      _string(reading['client_id']),
      _string(reading['id']),
      _string(reading['name']),
    ]);

    final displayName = _firstNonEmpty([
      _string(reading['farm_name']),
      _string(reading['name']),
      _string(reading['client_id']),
      'Device $id',
    ]);

    return PoultryDevice(id: id, name: displayName);
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
      switches: const <PoultrySwitch>[],
    );
  }

  String _getToken() {
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

  double _double(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse('$value') ?? 0.0;
  }
}
