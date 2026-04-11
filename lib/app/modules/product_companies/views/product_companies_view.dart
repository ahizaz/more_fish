import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../common_widgets/common_app_bar.dart';
import '../../../common_widgets/common_container.dart';
import '../../../res/colors/colors.dart';
import '../../../routes/app_pages.dart';
import '../../../service/service.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/product_companies_controller.dart';

class ProductCompaniesView extends GetView<ProductCompaniesController> {
  const ProductCompaniesView({super.key});
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
            child: Obx((){
              var data = controller.productCompaniesResponse.value?.data;
              return data == null ? Center(child: CircularProgressIndicator()):
                GridView.builder(
                padding: const EdgeInsets.all(12.0),
                itemCount: data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,          // Number of columns
                  crossAxisSpacing: 12.0,     // Horizontal space between tiles
                  mainAxisSpacing: 12.0,      // Vertical space between tiles
                  childAspectRatio: 1,        // Width / Height ratio
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){
                      Get.toNamed(Routes.PRODUCT_COMP_WISE_LIST, arguments: {"guid": data[index].guid});
                    },
                    child: CommonContainer(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            "${ApiService.baseUrl}${data[index].companyImage}",
                            height: 80,
                            width: 80,
                          ),
                          SizedBox(height: 3),
                          Text(
                            "${data[index].name}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      ),
      ),
    );
  }
}
