import 'package:get/get.dart';

import '../controllers/version_checker_controller.dart';

class VersionCheckerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VersionCheckerController>(
      () => VersionCheckerController(),
    );
  }
}
