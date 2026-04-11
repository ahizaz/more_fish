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
  List<Map<String, dynamic>>? _cachedItems;
  DateTime? _lastFetchedAt;

  static const Duration _cacheTtl = Duration(seconds: 5);

  Uri get _latestReadingsUri =>
      Uri.parse('${ApiService.baseUrl}/poultry_care/api/latest-readings/');

  @override
  Future<List<PoultryDevice>> getDevices() async {
    final rawItems = await _fetchLatestReadings();
    return rawItems.map(_toDevice).toList();
  }

  @override
  Future<PoultryLiveData> getLatestLiveData({required String deviceId}) async {
    final rawItems = await _fetchLatestReadings();

    Map<String, dynamic>? matched;
    for (final item in rawItems) {
      final id = _deviceIdFromItem(item);
      if (id == deviceId) {
        matched = item;
        break;
      }
    }

    matched ??= rawItems.isNotEmpty ? rawItems.first : <String, dynamic>{};
    return _toLiveData(matched, selectedDeviceId: deviceId);
  }

  Future<List<Map<String, dynamic>>> _fetchLatestReadings() async {
    final cachedItems = _cachedItems;
    final lastFetchedAt = _lastFetchedAt;
    if (cachedItems != null && lastFetchedAt != null) {
      final age = DateTime.now().difference(lastFetchedAt);
      if (age <= _cacheTtl) {
        return cachedItems;
      }
    }

    final token = _loginTokenStorage.getToken();

    if (token == null || token.trim().isEmpty) {
      throw Exception('Missing auth token for latest readings API.');
    }

    debugPrint('Poultry latest-readings GET: $_latestReadingsUri');
    debugPrint('Poultry latest-readings token exists: ${token.isNotEmpty}');

    final response = await http.get(
      _latestReadingsUri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
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

    final data = decoded['data'];
    if (data is! List) {
      throw Exception('Latest readings response missing data list.');
    }

    final items = data
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    _cachedItems = List<Map<String, dynamic>>.unmodifiable(items);
    _lastFetchedAt = DateTime.now();

    return _cachedItems!;
  }

  PoultryDevice _toDevice(Map<String, dynamic> item) {
    final id = _deviceIdFromItem(item);
    final displayName = _string(item['name']).isNotEmpty
        ? _string(item['name'])
        : id;

    return PoultryDevice(id: id, name: displayName);
  }

  PoultryLiveData _toLiveData(
    Map<String, dynamic> item, {
    required String selectedDeviceId,
  }) {
    final latestReading = _map(item['latest_reading']);
    final payload = _map(latestReading['data']);

    final resolvedDeviceId = _deviceIdFromItem(item);
    final ts = _string(latestReading['timestamp']);

    return PoultryLiveData(
      deviceId: resolvedDeviceId.isEmpty ? selectedDeviceId : resolvedDeviceId,
      timestamp: ts,
      aqi: _double(payload['aqi']),
      nh3MgL: _double(payload['nh3_gas']),
      temperatureC: _double(payload['temperature']),
      refTemperatureC: _double(payload['ref_temperature']),
      humidityPct: _double(payload['humidity']).round(),
      vocMgM3: _double(payload['tvoc']),
      co2Ppm: _double(payload['co2']).round(),
      ch4Ppm: _double(payload['methane_ppm']).round(),
      pm1UgM3: _double(payload['pm1']).round(),
      pm25UgM3: _double(payload['pm25']).round(),
      pm4UgM3: _double(payload['pm4']).round(),
      pm10UgM3: _double(payload['pm10']).round(),
      noiseDb: _double(payload['sound_db']).round(),
      lightLux: _double(payload['light_lux']).round(),
    );
  }

  String _deviceIdFromItem(Map<String, dynamic> item) {
    final clientId = _string(item['client_id']);
    if (clientId.isNotEmpty) return clientId;

    final fallbackName = _string(item['name']);
    if (fallbackName.isNotEmpty) return fallbackName;

    final fallbackFarm = _string(item['farm_name']);
    if (fallbackFarm.isNotEmpty) return fallbackFarm;

    return _string(item['id']);
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
