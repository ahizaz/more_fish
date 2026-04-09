import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../common_widgets/common_app_bar.dart';
import '../../../common_widgets/common_container.dart';
import '../../../common_widgets/common_text.dart';
import '../../../res/colors/colors.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/aerator_connection_controller.dart';

class AeratorConnectionView extends GetView<AeratorConnectionController> {
  const AeratorConnectionView({super.key});
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
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CommonText(
                  "No data found",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      )
      )
        )
    );
  }
}
/*CommonContainer(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CommonText(
                            'Aerator-1',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(width: 20,),
                          Switch(
                            value: controller.isSwitched1.value,
                            onChanged: (bool value) {

                              controller.isSwitched1.value = value;

                            },
                            activeColor: Colors.green,
                            inactiveThumbColor: Colors.red,
                            inactiveTrackColor: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    CommonContainer(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CommonText(
                            'Aerator-2',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(width: 20,),
                          Switch(
                            value: controller.isSwitched2.value,
                            onChanged: (bool value) {

                              controller.isSwitched2.value = value;

                            },
                            activeColor: Colors.green,
                            inactiveThumbColor: Colors.red,
                            inactiveTrackColor: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    CommonContainer(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CommonText(
                            'Aerator-3',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(width: 20,),
                          Switch(
                            value: controller.isSwitched3.value,
                            onChanged: (bool value) {

                              controller.isSwitched3.value = value;

                            },
                            activeColor: Colors.green,
                            inactiveThumbColor: Colors.red,
                            inactiveTrackColor: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    CommonContainer(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CommonText(
                            'Aerator-4',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(width: 20,),
                          Switch(
                            value: controller.isSwitched4.value,
                            onChanged: (bool value) {

                              controller.isSwitched4.value = value;

                            },
                            activeColor: Colors.green,
                            inactiveThumbColor: Colors.red,
                            inactiveTrackColor: Colors.grey,
                          ),
                        ],
                      ),
                    ),*/