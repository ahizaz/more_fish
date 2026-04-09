import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../common_widgets/common_app_bar.dart';
import '../../../routes/app_pages.dart';
import '../controllers/poultry_header_controller.dart';
import '../controllers/poultry_index_controller.dart';

class PoultryMoreView extends GetView<PoultryIndexController> {
  const PoultryMoreView({super.key});

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
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  children: [
                    _SimpleMoreTile(
                      title: 'FAQ',
                      onTap: () => Get.toNamed(Routes.FAQ),
                    ),
                    const SizedBox(height: 10),
                    _SimpleMoreTile(
                      title: 'About App',
                      onTap: () => Get.toNamed(Routes.ABOUT_APP),
                    ),
                    const SizedBox(height: 10),
                    _SimpleMoreTile(
                      title: 'About Device',
                      onTap: () => Get.toNamed(Routes.ABOUT_DEVICES),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SimpleMoreTile extends StatelessWidget {
  const _SimpleMoreTile({
    required this.title,
    required this.onTap,
  });

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade700),
            ],
          ),
        ),
      ),
    );
  }
}
