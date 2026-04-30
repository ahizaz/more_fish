import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../service/local_storage.dart';
import '../../../service/service.dart';

class PoultryNotificationsController extends GetxController {
  final notifications = <PoultryNotificationItem>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;
  final hasToken = false.obs;

  Timer? _pollingTimer;
  bool _isRequestInFlight = false;

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await fetchNotifications(showLoader: true);
    _startPolling();
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      fetchNotifications(showLoader: false);
    });
  }

  Future<void> fetchNotifications({bool showLoader = false}) async {
    if (_isRequestInFlight) return;
    _isRequestInFlight = true;
    if (showLoader) isLoading.value = true;

    try {
      final storage = Get.find<LoginTokenStorage>();
      final token = storage.getPoultryToken();

      if (!_isValidToken(token)) {
        hasToken.value = false;
        notifications.clear();
        error.value = '';
        return;
      }

      hasToken.value = true;
      error.value = '';

      final response = await http.get(
        Uri.parse('${ApiService.poultryBaseUrl}/poultry_care/notifications/'),
        headers: {
          'Authorization': 'Bearer ${token!.trim()}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final raw = json.decode(response.body) as Map<String, dynamic>;
        final data = (raw['data'] as List<dynamic>? ?? [])
            .whereType<Map<String, dynamic>>()
            .map(PoultryNotificationItem.fromJson)
            .toList();
        notifications.assignAll(data);
        return;
      }

      error.value = 'Failed to load notifications (${response.statusCode})';
    } catch (_) {
      error.value = 'Failed to load notifications';
    } finally {
      if (showLoader) isLoading.value = false;
      _isRequestInFlight = false;
    }
  }

  String toBanglaMessage(String message) {
    var text = message.trim();

    final highPattern = RegExp(
      r'HIGH ALERT:\s*([a-zA-Z_]+)\s+is\s+([0-9.]+)\s*([^,]*),\s*above the safe maximum of\s*([0-9.]+)\.?',
      caseSensitive: false,
    );
    final lowPattern = RegExp(
      r'LOW ALERT:\s*([a-zA-Z_]+)\s+is\s+([0-9.]+)\s*([^,]*),\s*below the safe minimum of\s*([0-9.]+)\.?',
      caseSensitive: false,
    );

    final highMatch = highPattern.firstMatch(text);
    if (highMatch != null) {
      final sensor = _sensorNameBn(highMatch.group(1) ?? '');
      final value = highMatch.group(2) ?? '';
      final unit = _unitBn(highMatch.group(3) ?? '');
      final max = highMatch.group(4) ?? '';
      return 'উচ্চ সতর্কতা: $sensor এর মান $value $unit, নিরাপদ সর্বোচ্চ সীমা $max $unit এর বেশি।';
    }

    final lowMatch = lowPattern.firstMatch(text);
    if (lowMatch != null) {
      final sensor = _sensorNameBn(lowMatch.group(1) ?? '');
      final value = lowMatch.group(2) ?? '';
      final unit = _unitBn(lowMatch.group(3) ?? '');
      final min = lowMatch.group(4) ?? '';
      return 'নিম্ন সতর্কতা: $sensor এর মান $value $unit, নিরাপদ সর্বনিম্ন সীমা $min $unit এর কম।';
    }

    return text
        .replaceAll('HIGH ALERT:', 'উচ্চ সতর্কতা:')
        .replaceAll('LOW ALERT:', 'নিম্ন সতর্কতা:')
        .replaceAll('temperature', 'তাপমাত্রা')
        .replaceAll('humidity', 'আর্দ্রতা')
        .replaceAll('methane_ppm', 'মিথেন');
  }

  String _sensorNameBn(String sensor) {
    final key = sensor.toLowerCase();
    switch (key) {
      case 'temperature':
        return 'তাপমাত্রা';
      case 'humidity':
        return 'আর্দ্রতা';
      case 'methane_ppm':
        return 'মিথেন';
      default:
        return sensor;
    }
  }

  String _unitBn(String unit) {
    final normalized = unit.trim();
    if (normalized.toLowerCase() == 'ppm') return 'পিপিএম';
    return normalized;
  }

  bool _isValidToken(String? token) {
    if (token == null) return false;
    final normalized = token.trim().toLowerCase();
    return normalized.isNotEmpty &&
        normalized != 'null' &&
        normalized != 'undefined';
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    super.onClose();
  }
}

class PoultryNotificationItem {
  PoultryNotificationItem({
    required this.id,
    required this.sensorName,
    required this.value,
    required this.urgency,
    required this.message,
    required this.isRead,
    required this.notifiedAt,
  });

  final int id;
  final String sensorName;
  final double? value;
  final String urgency;
  final String message;
  final bool isRead;
  final DateTime? notifiedAt;

  factory PoultryNotificationItem.fromJson(Map<String, dynamic> json) {
    return PoultryNotificationItem(
      id: (json['id'] as num?)?.toInt() ?? 0,
      sensorName: (json['sensor_name'] ?? '').toString(),
      value: (json['value'] as num?)?.toDouble(),
      urgency: (json['urgency'] ?? '').toString(),
      message: (json['message'] ?? '').toString(),
      isRead: json['is_read'] == true,
      notifiedAt: DateTime.tryParse((json['notified_at'] ?? '').toString()),
    );
  }
}
