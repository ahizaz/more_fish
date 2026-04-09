import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:more_fish/app/common_widgets/common_text.dart';
import '../../../common_widgets/common_app_bar.dart';
import '../../../common_widgets/common_container.dart';
import '../../../res/colors/colors.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/high_density_fish_farming_controller.dart';

class HighDensityFishFarmingView
    extends GetView<HighDensityFishFarmingController> {
  const HighDensityFishFarmingView({super.key});
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
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  itemCount: controller.titleList.length,
                  itemBuilder: (context, index){
                    return CommonContainer(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CommonText(
                                  controller.titleList[index],
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  maxLines: 3,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5,),
                          CommonText(
                            controller.dataList[index],
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.justify,
                            maxLines: 20,
                            color: Colors.blueGrey.shade700,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
