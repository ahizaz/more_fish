import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:more_fish/app/res/colors/colors.dart';
import '../../../common_widgets/common_app_bar.dart';
import '../../../common_widgets/common_container.dart';
import '../../../routes/app_pages.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/farm_management_controller.dart';

class FarmManagementView extends GetView<FarmManagementController> {
  const FarmManagementView({super.key});
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
            child: GridView.builder(
                itemCount: controller.listItemsEnglish.length,
                padding: EdgeInsets.all(12.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  childAspectRatio: .80,
                ),
                itemBuilder: (context, index){
                  return InkWell(
                    onTap: (){
                      if(index == 17){
                        Get.toNamed(Routes.HIGH_DENSITY_FISH_FARMING);
                      }else {
                        Get.toNamed(Routes.FARM_MANAGEMENT_DETAILS, arguments: {"title": controller.listItemsEnglish[index], "data": controller.dataList[index], "index": index},);
                      }
            
                    },
                    child: CommonContainer(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            controller.iconList[index],
                            height: 45,
                            width: 45,
                          ),
                          SizedBox(height: 5),
                          Text(
                            '${controller.listItemsEnglish[index]}'.tr,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }
            ),
          ),
        ],
      ),
      ),
      ),
    );
  }
}
