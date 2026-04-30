// app/modules/poultry_index/views/poultry_home_view.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../common_widgets/common_app_bar.dart';
import '../controllers/poultry_index_controller.dart';
import '../controllers/poultry_header_controller.dart';
import 'poultry_live_monitoring_view.dart';
// NOTE: app_routes.dart is a `part of` file (part of app_pages.dart),
// so it should not be imported directly. Import app_pages.dart instead.
import '../../../routes/app_pages.dart';

class PoultryHomeView extends GetView<PoultryIndexController> {
  const PoultryHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final header = Get.find<PoultryHeaderController>();

    void openIfLoggedIn(VoidCallback navigate) async {
      final canOpen = await controller.ensureLoggedIn();
      if (canOpen) {
        navigate();
      }
    }

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
              Obx(
                () => CommonAppBar(
                  title: 'Poultry Care',
                  cityName: 'Dhaka',
                  date: header.formattedDate.value,
                  time: header.formattedTime.value,
                  temp: header.tempText.value,
                  humidity: header.humidityText.value,
                  logoAssetPath: 'assets/icons/dma_poultry_pulse.png',
                  backgroundColor: const Color(0xffdbcc68),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.1,
                    children: [
                      _HomeFeatureTile(
                        title: 'Live Data\nmonitoring',
                        iconAssetPath: 'assets/icons/water_quality_check.png',
                        onTap: () => openIfLoggedIn(
                          () => Get.to(() => const PoultryLiveMonitoringView()),
                        ),
                      ),
                      _HomeFeatureTile(
                        title: 'Farm\nManagement',
                        iconAssetPath:
                            'assets/icons/farm_management/farm_management.png',
                        onTap: () => openIfLoggedIn(
                          () => Get.toNamed(
                            Routes.COMING_SOON,
                            arguments: {'title': 'Farm Management'},
                          ),
                        ),
                      ),
                      _HomeFeatureTile(
                        title: 'Feed\nManagement',
                        iconAssetPath:
                            'assets/icons/farm_management/feed_management.png',
                        onTap: () => openIfLoggedIn(
                          () => Get.toNamed(
                            Routes.COMING_SOON,
                            arguments: {'title': 'Feed Management'},
                          ),
                        ),
                      ),
                      _HomeFeatureTile(
                        title: 'Poultry Disease\nTreatment',
                        iconAssetPath:
                            'assets/icons/farm_management/poultry_disease_treatment.png',
                        onTap: () => openIfLoggedIn(
                          () => Get.toNamed(
                            Routes.COMING_SOON,
                            arguments: {'title': 'Poultry Disease Treatment'},
                          ),
                        ),
                      ),
                      _HomeFeatureTile(
                        title: 'Chicks\nMarketplace',
                        iconAssetPath:
                            'assets/icons/farm_management/chicks_marketplace.png',
                        onTap: () => openIfLoggedIn(
                          () => Get.toNamed(
                            Routes.COMING_SOON,
                            arguments: {'title': 'Chicks Marketplace'},
                          ),
                        ),
                      ),
                      _HomeFeatureTile(
                        title: 'Poultry Feed\nMarketplace',
                        iconAssetPath:
                            'assets/icons/farm_management/poultry_feed_marketplace.png',
                        onTap: () => openIfLoggedIn(
                          () => Get.toNamed(
                            Routes.COMING_SOON,
                            arguments: {'title': 'Poultry Feed Marketplace'},
                          ),
                        ),
                      ),
                      _HomeFeatureTile(
                        title: 'Auto Feeder', //
                        iconAssetPath:
                            'assets/icons/farm_management/auto_feeder.png',
                        onTap: () => openIfLoggedIn(
                          () => Get.toNamed(
                            Routes.COMING_SOON,
                            arguments: {'title': 'Auto Feeder'},
                          ),
                        ),
                      ),
                      _HomeFeatureTile(
                        title: 'Weather\nForecast',
                        iconAssetPath:
                            'assets/icons/farm_management/weather_forecast.png',
                        onTap: () => openIfLoggedIn(
                          () => Get.toNamed(
                            Routes.COMING_SOON,
                            arguments: {'title': 'Weather Forecast'},
                          ),
                        ),
                      ),
                      _HomeFeatureTile(
                        title: 'Live\nConsultancy',
                        iconAssetPath:
                            'assets/icons/farm_management/live_consultancy.png',
                        onTap: () => openIfLoggedIn(
                          () => Get.toNamed(
                            Routes.COMING_SOON,
                            arguments: {'title': 'Live Consultancy'},
                          ),
                        ),
                      ),
                      _HomeFeatureTile(
                        title: 'Auto Water\nSystem',
                        iconAssetPath:
                            'assets/icons/farm_management/auto_water_system.png',
                        onTap: () => openIfLoggedIn(
                          () => Get.toNamed(
                            Routes.COMING_SOON,
                            arguments: {'title': 'Auto Water System'},
                          ),
                        ),
                      ),
                      _HomeFeatureTile(
                        title: 'Financial\nManagement',
                        iconAssetPath:
                            'assets/icons/farm_management/financial_management.png',
                        onTap: () => openIfLoggedIn(
                          () => Get.toNamed(
                            Routes.COMING_SOON,
                            arguments: {'title': 'Financial Management'},
                          ),
                        ),
                      ),
                    ],
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

class _HomeFeatureTile extends StatelessWidget {
  const _HomeFeatureTile({
    required this.title,
    required this.iconAssetPath,
    required this.onTap,
  });

  final String title;
  final String iconAssetPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 233, 234, 205),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(iconAssetPath, height: 52, fit: BoxFit.contain),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
