import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/common_alert_dialog.dart';
import '../../../routes/app_pages.dart';
import '../controllers/clean_air_index_controller.dart';
import 'clean_air_home_view.dart';
import 'clean_air_more_view.dart';
import 'clean_air_notifications_view.dart';
import 'clean_air_profile_view.dart';

class CleanAirIndexView extends GetView<CleanAirIndexController> {
  const CleanAirIndexView({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = const [
      CleanAirHomeView(),
      CleanAirNotificationsView(),
      CleanAirProfileView(),
      CleanAirMoreView(),
    ];

    return Obx(() {
      return Scaffold(
        body: pages[controller.selectedIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xffebffff),
          currentIndex: controller.selectedIndex.value,
          onTap: (index) {
            // Same login gating behavior as Cattle Care / More Fish
            if ((index == 1 || index == 2) && controller.isLoggedIn.isEmpty) {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) => WillPopScope(
                  onWillPop: () async => false,
                  child: CommonAlertDialog(
                    notNow: () {
                      Get.back();
                      controller.selectedIndex.value = 0;
                    },
                    login: () => Get.toNamed(Routes.LOGIN),
                  ),
                ),
              );
              return;
            }
            controller.selectedIndex.value = index;
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xff0370c3),
          unselectedItemColor: Colors.blueGrey,
          elevation: 4,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'More',
            ),
          ],
        ),
      );
    });
  }
}
