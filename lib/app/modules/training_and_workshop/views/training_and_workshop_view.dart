import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:more_fish/app/common_widgets/common_text.dart';
import '../../../common_widgets/common_app_bar.dart';
import '../../../res/colors/colors.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/training_and_workshop_controller.dart';

class TrainingAndWorkshopView extends GetView<TrainingAndWorkshopController> {
  const TrainingAndWorkshopView({super.key});
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
      body: Column(
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
            child: const Center(
              child: CommonText(
                'Training is not available.',
                fontSize: 20,
                color: Colors.red,
                fontWeight: FontWeight.bold,

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
