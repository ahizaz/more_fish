import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:more_fish/app/common_widgets/common_container.dart';
import 'package:more_fish/app/res/colors/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import '../../../common_widgets/common_app_bar.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/farm_management_details_controller.dart';
import 'fish_growth_data_view.dart';

class FarmManagementDetailsView extends GetView<FarmManagementDetailsController> {
  const FarmManagementDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.put(HomeController());
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Color(0xffd4fcfd),
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
        child:SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.backGround,
              body:  Column(
                children: [
                  Obx((){
                    return CommonAppBar(
                      title: 'title'.tr,
                      cityName: "dhaka".tr,
                      date: '${homeController.formattedDate}',
                      time: '${homeController.formattedTime}',
                      temp: '${homeController.weatherData['main']['temp']}°C',
                      humidity: '${homeController.weatherData['main']['humidity']}%',
                    );
                  }),
                  Expanded(
                    child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: controller.index == 3
                        ? FishGrowthDataView(controller)
                        : Column(
                      children: [
                        Expanded(
                          child: CommonContainer(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              controller.data,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () async {
                            final Uri launchUri = Uri(
                              scheme: 'tel',
                              path: "+8801783038202",
                            );
                            if (await canLaunchUrl(launchUri)) {
                              await launchUrl(launchUri);
                            } else {
                              // Handle error here
                            }
                          },
                          child: CommonContainer(
                            height: 50,
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.phone, color: Colors.green.shade700),
                                const SizedBox(width: 12),
                                Text(
                                  "Call Now",
                                  style: TextStyle(
                                    color: Colors.green.shade700,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ), // Placeholder if index is not 3
                                ),
                  ),
                ],
              ),
            ),
      ),
    );
  }

}
