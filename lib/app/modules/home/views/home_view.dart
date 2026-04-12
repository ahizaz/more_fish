import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common_widgets/common_app_bar.dart';
import '../../../common_widgets/common_container.dart';
import '../../../common_widgets/common_text.dart';
import '../../../res/colors/colors.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
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
              Obx(() {
                return CommonAppBar(
                  title: 'title'.tr,
                  cityName: "dhaka".tr,
                  date: '${controller.formattedDate}',
                  time: '${controller.formattedTime}',
                  temp:
                      '${controller.weatherData.isEmpty ? "" : controller.weatherData['main']['temp']}°C',
                  humidity:
                      '${controller.weatherData.isEmpty ? "" : controller.weatherData['main']['humidity']}%',
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.language, color: Colors.black),
                      onPressed: () {
                        Locale currentLocale =
                            Get.locale ?? const Locale('en', 'US');
                        if (currentLocale.languageCode == 'en') {
                          Get.updateLocale(const Locale('bn', 'BD'));
                        } else {
                          Get.updateLocale(const Locale('en', 'US'));
                        }
                      },
                    ),
                  ],
                );
              }),
              Obx(() {
                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        gridViewSection1(controller),
                        const SizedBox(height: 10),
                        banner(controller),
                        const SizedBox(height: 10),
                        gridViewSection2(controller),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(child: premiumMemberButton(controller)),
                            Expanded(child: emergencyButton(controller)),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  banner(homeController) => Obx(() {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: PageView.builder(
        itemCount: homeController.bannerList.length,
        controller: homeController.pageController,
        onPageChanged: (index) {
          homeController.currentPage.value = index;
        },
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              //color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                homeController.bannerList[index],
                fit: BoxFit.fill,
              ),
            ),
          );
        },
      ),
    );
  });

  gridViewSection1(homeController) {
    return Obx(() {
      return GridView.builder(
        padding: const EdgeInsets.all(12.0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: homeController.listItemsEnglish1.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () async {
              if (index == 0) {
                controller.checkLogin();
                if (controller.isLoggedIn.value.isEmpty) {
                  Get.toNamed(Routes.ABOUT_DEVICES);
                } else {
                  print("===== Water Quality device ==========");
                  Get.toNamed(Routes.WATER_QUALITY_DEVICE);
                }
              } else if (index == 1) {
                Get.toNamed(Routes.FISH_DISEASE_DETECTOR);
              } else if (index == 2) {
                Get.toNamed(Routes.POND_MANAGEMENT);
              } else if (index == 3) {
                Get.toNamed(Routes.FEED_MANAGEMENT);
              } else if (index == 4) {
                Get.toNamed(Routes.FISH_DISEASE_TREATMENT);
              } else if (index == 5) {
                final Uri launchUri = Uri(
                  scheme: 'tel',
                  path: "+880 1898-938355",
                );
                if (await canLaunchUrl(launchUri)) {
                  await launchUrl(launchUri);
                } else {}
              } else if (index == 6) {
                var category = homeController.categoryResponse.value?.data;
                for (int i = 0; i < category.length; i++) {
                  if (category[i].categoryName == "Fish Farming Equipment") {
                    Get.toNamed(
                      Routes.PRODUCT_COMPANIES,
                      arguments: {"id": category[i].guid},
                    );
                  }
                }
              } else if (index == 7) {
                Get.toNamed(
                  Routes.PRODUCT_COMPANIES,
                  arguments: {"id": "ce86362d-828c-4c81-a644-72d6c27c7e13"},
                );
              } else if (index == 8) {
                Get.toNamed(
                  Routes.PRODUCT_COMPANIES,
                  arguments: {"id": "08a69b99-9d57-4097-afc0-b38f49f5318d"},
                );
              } else {
                var category = homeController.categoryResponse.value?.data;
                for (int i = 0; i < category.length; i++) {
                  if (category[i].categoryName == "Fish Medicine") {
                    Get.toNamed(
                      Routes.PRODUCT_COMPANIES,
                      arguments: {"id": category[i].guid},
                    );
                  }
                }
              }
            },
            child: CommonContainer(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    homeController.iconList1[index],
                    height: 40,
                    width: 40,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "${homeController.listItemsEnglish1[index]}".tr,
                    style: const TextStyle(
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
        },
      );
    });
  }

  gridViewSection2(homeController) => GridView.builder(
    padding: const EdgeInsets.all(12.0),
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: homeController.listItemsEnglish2.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3, // Number of columns
      crossAxisSpacing: 12.0, // Horizontal space between tiles
      mainAxisSpacing: 12.0, // Vertical space between tiles
      childAspectRatio: .95, // Width / Height ratio
    ),
    itemBuilder: (context, index) {
      return InkWell(
        onTap: () {
          if (index == 0) {
            var category = homeController.categoryResponse.value?.data;
            for (int i = 0; i < category.length; i++) {
              if (category[i].categoryName == "Fish Feed") {
                Get.toNamed(
                  Routes.PRODUCT_COMPANIES,
                  arguments: {"id": category[i].guid},
                );
              }
            }
          } else if (index == 1) {
            Get.toNamed(Routes.TRAINING_AND_WORKSHOP);
          } else if (index == 2) {
            Get.toNamed(Routes.FARM_MANAGEMENT);
          } else if (index == 3) {
            Get.toNamed(Routes.AERATOR_CONNECTION);
          } else if (index == 4) {
            Get.toNamed(Routes.FEEDER_CONNECTION);
          } else {
            Get.toNamed(Routes.WEATHER_FORECAST);
          }
        },
        child: CommonContainer(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                homeController.iconList2[index],
                height: 40,
                width: 40,
              ),
              const SizedBox(height: 3),
              Text(
                "${homeController.listItemsEnglish2[index]}".tr,
                style: const TextStyle(
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
    },
  );

  premiumMemberButton(homeController) => InkWell(
    onTap: () async {
      Get.toNamed(Routes.SMART_KHAMARI);
    },
    child: CommonContainer(
      margin: const EdgeInsets.only(left: 12, right: 6, top: 12, bottom: 12),
      height: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/icons/community.png", height: 45, width: 45),
          const SizedBox(height: 8),
          CommonText(
            "smart_khamari".tr,
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          CommonText(
            "cluster_farming_club".tr,
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    ),
  );

  emergencyButton(homeController) => Obx(() {
    return homeController.activeCallButton == true
        ? InkWell(
            onTap: () {
              homeController.activeCallButton.value = false;
            },
            child: CommonContainer(
              margin: const EdgeInsets.only(
                left: 6,
                right: 12,
                top: 12,
                bottom: 12,
              ),
              height: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () async {
                      final Uri launchUri = Uri(
                        scheme: 'tel',
                        path: "+880 1898-938354",
                      );
                      if (await canLaunchUrl(launchUri)) {
                        await launchUrl(launchUri);
                      } else {}
                    },
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.green, width: 2),
                      ),
                      child: Icon(
                        Icons.phone,
                        color: Colors.green.shade500,
                        size: 24,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final String phoneNumber = "+8801898-938354";

                      final String cleanedNumber = phoneNumber.replaceAll(
                        '+',
                        '',
                      );
                      final Uri url = Uri.parse(
                        Uri.encodeFull("https://wa.me/$cleanedNumber"),
                      );

                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        debugPrint("Could not launch WhatsApp");
                      }
                    },
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Image.asset("assets/icons/whatsapp.png"),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final String pageId = "";
                      final messengerUrl = "https://m.me/$pageId";
                      if (await canLaunchUrl(Uri.parse(messengerUrl))) {
                        await launchUrl(
                          Uri.parse(messengerUrl),
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        throw 'Could not launch Messenger';
                      }
                    },
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Image.asset("assets/icons/messenger.png"),
                    ),
                  ),
                ],
              ),
            ),
          )
        : InkWell(
            onTap: () async {
              homeController.activeCallButton.value = true;
            },
            child: CommonContainer(
              margin: const EdgeInsets.only(
                left: 6,
                right: 12,
                top: 12,
                bottom: 12,
              ),
              height: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icons/24_hours_support.png",
                    height: 45,
                    width: 45,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "emergency_service".tr,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
  });
}
