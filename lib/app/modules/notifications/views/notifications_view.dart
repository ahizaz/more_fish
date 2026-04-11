import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../common_widgets/common_app_bar.dart';
import '../../../common_widgets/common_text.dart';
import '../../../res/colors/colors.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.put(HomeController());
    controller.checkLogin();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xffd4fcfd),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      child: SafeArea(
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
                  var data = controller.notificationResponse.value;
                  return controller.isLoggedIn.value.isEmpty ?
                      SizedBox():
                      data != null ?
                      ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        itemCount: data.data?.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 16),
                            decoration:  decoration(),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white,
                                        Color(0xffebffff),
    
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CommonText(
                                        DateFormat('dd:MM:yyyy').format(data.data![index].notTime!.toLocal()),
                                        color: const Color(0xff0d66a8),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      CommonText(
                                      data.data?[index].notTime != null ?
                                        DateFormat('hh:mm a').format(data.data![index].notTime!.toLocal()) : '',
                                        color: const Color(0xff0d66a8),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
    
    
    
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16,),
                                  child: CommonText(
                                    "${data.data?[index].notFinal}",
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    textAlign: TextAlign.justify,
                                    maxLines: 20,
                                  ),
                                ),
                                const SizedBox(height: 12,),
                              ],
                            ),
                          );
                    },
                  ) : const Center(child: CircularProgressIndicator());
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }


  appBar()=>
    Container(
      padding: const EdgeInsets.only(top: 0, left: 12, right: 12),
      height: 75,
      decoration: const BoxDecoration(
        color: Color(0xffd4fcfd),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          "assets/icons/logo_trade_mark.jpg",
                          height: 60,
                          width: 60,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8,),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      /*Text(
                        '${controller.formattedDate}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${controller.formattedTime}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),*/

                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: ClipRRect(
                      child: Image.asset(
                        "assets/icons/lang_translate.png",
                        height: 30,
                        width: 30,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );

  decoration()=>BoxDecoration(
    gradient: const LinearGradient(
      colors: [
        Color(0xfffbffff),
        Colors.white,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
        color: Colors.blueGrey.withOpacity(0.5),
        spreadRadius: 1,
        blurRadius: 1,
        offset: Offset(.2, .2),
      ),
    ],
  );

}
