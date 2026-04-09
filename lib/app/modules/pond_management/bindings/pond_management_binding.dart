import 'package:get/get.dart';

import '../controllers/pond_management_controller.dart';

class PondManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PondManagementController>(
      () => PondManagementController(),
    );
  }
}
