import 'package:get/get.dart';

import '../controllers/internet_checker_controller.dart';

class InternetCheckerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InternetCheckerController>(
      () => InternetCheckerController(),
    );
  }
}
