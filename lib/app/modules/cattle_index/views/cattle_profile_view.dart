import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../common_widgets/common_app_bar.dart';
import '../controllers/cattle_header_controller.dart';

class CattleProfileView extends StatelessWidget {
  const CattleProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final header = Get.find<CattleHeaderController>();

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
                    title: 'Cattle Care',
                    cityName: 'Dhaka',
                    date: header.formattedDate.value,
                    time: header.formattedTime.value,
                    temp: header.tempText.value,
                    humidity: header.humidityText.value,
                    logoAssetPath: 'assets/icons/dma_cattle_care.png',
                    backgroundColor: const Color(0xffdbcc68),
                  )),
              const Expanded(
                child: Center(
                  child: Text(
                    'Profile (Coming soon)',
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
