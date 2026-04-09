import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common_widgets/common_alert_dialog.dart';
import '../../../routes/app_pages.dart';
import '../controllers/poultry_index_controller.dart';
import 'poultry_home_view.dart';
import 'poultry_more_view.dart';
import 'poultry_notifications_view.dart';
import 'poultry_profile_view.dart';

class PoultryIndexView extends GetView<PoultryIndexController> {
  const PoultryIndexView({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = const [
      PoultryHomeView(),
      PoultryNotificationsView(),
      PoultryProfileView(),
      PoultryMoreView(),
    ];

    return Obx(() {
      return Scaffold(
        body: pages[controller.selectedIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xffebffff),
          currentIndex: controller.selectedIndex.value,
          onTap: (index) {
            // Match MoreFish behavior: block Notifications/Profile tab for logged-out users.
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
