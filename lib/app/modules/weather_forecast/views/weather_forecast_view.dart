import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common_widgets/common_text.dart';
import '../controllers/weather_forecast_controller.dart';

class WeatherForecastView extends GetView<WeatherForecastController> {
  const WeatherForecastView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchWeatherData("dhaka");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xffcbffff),
        title: const Text(
          'Weather Forecast',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffddf1fb),
              Colors.white
            ],
          ),
        ),
        child: Obx(() {
          if (controller.weatherData.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final weather = controller.weatherData;
          final temp = weather['main']['temp'].toDouble();
          final humidity = weather['main']['humidity'];
          final windSpeed = weather['wind']['speed'];
          final pressure = weather['main']['pressure'];
          final description = weather['weather'][0]['description'];
          final icon = weather['weather'][0]['icon'];
          final city = weather['name'];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                glassCard(
                  child: Column(
                    children: [
                      CommonText(
                        city,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: const Color(0xff87CEEB),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Image.network(
                          "https://openweathermap.org/img/wn/$icon@4x.png",
                          width: 100,
                          height: 100,
                        ),
                      ),
                      const SizedBox(height: 10),
                      CommonText(
                        "$temp°C",
                        fontSize: 44,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 6),
                      CommonText(
                        description.toString().capitalizeFirst ?? '',
                        fontSize: 18,
                        color: Colors.grey[700],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    infoCard("Humidity", "$humidity%", Icons.water_drop),
                    infoCard("Wind", "$windSpeed m/s", Icons.air),
                    infoCard("Pressure", "$pressure hPa", Icons.speed),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget glassCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }


  Widget infoCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: Colors.blueAccent),
            const SizedBox(height: 10),
            CommonText(
              value,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            const SizedBox(height: 4),
            CommonText(
              label,
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }
}
