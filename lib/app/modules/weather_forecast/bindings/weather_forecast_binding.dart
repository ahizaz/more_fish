import 'package:get/get.dart';

import '../controllers/weather_forecast_controller.dart';

class WeatherForecastBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WeatherForecastController>(
      () => WeatherForecastController(),
    );
  }
}
