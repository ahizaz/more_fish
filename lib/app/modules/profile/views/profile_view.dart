import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:more_fish/app/common_widgets/common_text.dart';
import '../../../common_widgets/common_app_bar.dart';
import '../../../common_widgets/common_container.dart';
import '../../../res/colors/colors.dart';
import '../../../routes/app_pages.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
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
      child:  SafeArea(
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
                  var data = controller.profileResponse.value;
                  return controller.isLoggedIn.isEmpty ?
                  SizedBox( ):
                  data == null ?
                  Center(child: CircularProgressIndicator(),):
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        Expanded(
                          child: CommonContainer(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CommonText(
                                      "${data.data?.firstName??''} ${data.data?.lastName??''} ",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4,),
                                    CommonText(
                                        "${data.data?.usrEmail??''}",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18
                                    ),
                                    SizedBox(height: 4,),
                                    data.data?.userPhone == null ?
                                    CommonText(
                                      "${data.data?.userPhone?.phnCell??''}",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18
                                    ) : CommonText(""),
                                    SizedBox(height: 50,),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  Get.toNamed(Routes.PASSWORD_CHANGE);
                                },
                                child: CommonContainer(
                                  height: 50,
                                  margin: EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Change Password",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  await controller.loginTokenStorage.removeToken();
                                  Get.offAllNamed(Routes.INDEX);
                                },
                                child: CommonContainer(
                                  height: 50,
                                  margin: EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Logout",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          )
        ),
      ),
    );
  }
}
