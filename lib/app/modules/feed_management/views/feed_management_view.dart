import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:more_fish/app/res/strings/feed_management.dart';
import '../../../common_widgets/common_app_bar.dart';
import '../../../common_widgets/common_container.dart';
import '../../../common_widgets/common_text.dart';
import '../../../res/colors/colors.dart';
import '../../../routes/app_pages.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/feed_management_controller.dart';

class FeedManagementView extends GetView<FeedManagementController> {
  const FeedManagementView({super.key});
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
              title: 'আরো মাছ - MoreFish',
              cityName: "Dhaka",
              date: '${homeController.formattedDate}',
              time: '${homeController.formattedTime}',
              temp: '${homeController.weatherData['main']['temp']}°C',
              humidity: '${homeController.weatherData['main']['humidity']}%',
            );
          }),
          Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 16),
                itemCount: controller.titleList.length,
                itemBuilder: (context, index){
                  return InkWell(
                    onTap: (){
                      if(index == 0){
                        Get.toNamed(Routes.FEED_MANAGEMENT_DETAILS, arguments: {"title": controller.titleList[index].tr, "data":controller.dataList[index],});
                      }else{
                        Get.toNamed(Routes.FEED_MANAGEMENT_DETAILS, arguments: {"title": controller.titleList[index].tr, "data":controller.dataList[index],});
                      }

                    },
                    child: CommonContainer(
                      margin: EdgeInsets.only(left: 16, right: 16, bottom: 14),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CommonText(
                                  "${controller.titleList[index]}".tr,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  maxLines: 3,
                                  textAlign: TextAlign.center,

                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  );
                },
              )
          ),
        ],
      ),
      ),
      ),
    );
  }


}
