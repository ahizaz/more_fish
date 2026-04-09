import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../common_widgets/common_app_bar.dart';
import '../controllers/clean_air_header_controller.dart';

class CleanAirNotificationsView extends StatelessWidget {
  const CleanAirNotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final header = Get.find<CleanAirHeaderController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xffd4fcfd),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xffebffff),
          body: Column(
            children: [
              Obx(() => CommonAppBar(
                    title: 'Clean Air',
                    cityName: 'Dhaka',
                    date: header.formattedDate.value,
                    time: header.formattedTime.value,
                    temp: header.tempText.value,
                    humidity: header.humidityText.value,
                    logoAssetPath: 'assets/icons/clean_air.png',
                    backgroundColor: const Color(0xffd4fcfd),
                  )),
              const Expanded(
                child: Center(
                  child: Text('No notifications yet'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
