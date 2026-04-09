import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../common_widgets/common_app_bar.dart';
import '../controllers/poultry_header_controller.dart';

class PoultryNotificationsView extends StatelessWidget {
  const PoultryNotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final header = Get.find<PoultryHeaderController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xffdbcc68),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xffebffff),
          body: Column(
            children: [
              Obx(() => CommonAppBar(
                    title: 'Poultry Pulse',
                    cityName: 'Dhaka',
                    date: header.formattedDate.value,
                    time: header.formattedTime.value,
                    temp: header.tempText.value,
                    humidity: header.humidityText.value,
                    logoAssetPath: 'assets/icons/dma_poultry_pulse.png',
                    backgroundColor: const Color(0xffdbcc68),
                  )),
              const Expanded(
                child: Center(
                  child: Text(
                    'Notifications (Coming soon)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
