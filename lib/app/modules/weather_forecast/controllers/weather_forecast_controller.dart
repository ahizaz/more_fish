import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../service/service.dart';


class WeatherForecastController extends GetxController {
  final String apiKey = ApiService.apiKey;
  var weatherData = {}.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();

  }


  Future<void> fetchWeatherData(String city) async {
    isLoading.value = true;
    errorMessage.value = '';
    weatherData.clear();

    try {
      final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        weatherData.value = json.decode(response.body);
      } else {
        final error = json.decode(response.body);
        errorMessage.value = error['message'] ?? 'City not found';
      }
    } catch (e) {
      errorMessage.value = 'Something went wrong. Check your internet.';
    } finally {
      isLoading.value = false;
    }
  }





}
