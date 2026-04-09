import 'package:get/get.dart';

import '../controllers/about_app_details_controller.dart';

class AboutAppDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AboutAppDetailsController>(
      () => AboutAppDetailsController(),
    );
  }
}
