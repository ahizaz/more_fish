import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../../service/service.dart';

/// Handles Cattle Care header values (date/time + simple weather for Dhaka)
///
/// Backend is NOT required for these:
/// - Date/time is device local time (DateTime.now)
/// - Weather uses OpenWeatherMap (same as More Fish)
class CattleHeaderController extends GetxController {
  final formattedDate = ''.obs;
  final formattedTime = ''.obs;

  final tempText = ''.obs;
  final humidityText = ''.obs;

  final isLoadingWeather = false.obs;
  final weatherError = ''.obs;

  Timer? _timer;

  final String _apiKey = ApiService.apiKey;
  final String city = 'dhaka';

  @override
  void onInit() {
    super.onInit();

    // Start local clock
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());

    // Fetch weather once (can be refreshed later if needed)
    fetchWeatherData(city);
  }

  void _tick() {
    final now = DateTime.now();
    formattedDate.value = DateFormat('d-MMM-yyyy').format(now);
    formattedTime.value = DateFormat('h:mm:ss a').format(now);
  }

  Future<void> fetchWeatherData(String city) async {
    isLoadingWeather.value = true;
    weatherError.value = '';
    try {
      final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonMap = json.decode(response.body) as Map<String, dynamic>;
        final main = (jsonMap['main'] as Map?) ?? {};
        final t = main['temp'];
        final h = main['humidity'];
        tempText.value = t == null ? '' : '${(t as num).toStringAsFixed(2)}°C';
        humidityText.value = h == null ? '' : '${h.toString()}%';
      } else {
        weatherError.value = 'Weather unavailable';
      }
    } catch (_) {
      weatherError.value = 'Weather unavailable';
    } finally {
      isLoadingWeather.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
