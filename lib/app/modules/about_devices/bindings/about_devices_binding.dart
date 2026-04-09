import 'package:get/get.dart';

import '../controllers/about_devices_controller.dart';

class AboutDevicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AboutDevicesController>(
      () => AboutDevicesController(),
    );
  }
}
