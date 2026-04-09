import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:more_fish/app/common_widgets/common_container.dart';
import 'package:more_fish/app/common_widgets/common_text.dart';
import 'package:more_fish/app/res/colors/colors.dart';
import '../../../common_widgets/common_app_bar.dart';
import '../../../routes/app_pages.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/faq_controller.dart';

class FaqView extends GetView<FaqController> {
  const FaqView({super.key});
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
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemCount: controller.titleList.length,
                  itemBuilder: (context, index){
                    return InkWell(
                      onTap: (){
                        Get.toNamed(Routes.FAQ_DETAILS, arguments: {"title": controller.titleList[index],"data":controller.dataList[index]});
                      },
                      child: CommonContainer(
                        margin: EdgeInsets.only(bottom: 14),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Column(
                          children: [
                            CommonText(
                              "${controller.titleList[index]}".tr,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18,
                              maxLines: 3,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
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
