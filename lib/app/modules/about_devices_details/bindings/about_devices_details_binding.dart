import 'package:get/get.dart';

import '../controllers/about_devices_details_controller.dart';

class AboutDevicesDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AboutDevicesDetailsController>(
      () => AboutDevicesDetailsController(),
    );
  }
}
