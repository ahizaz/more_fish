import 'package:get/get.dart';

import '../controllers/farm_management_controller.dart';

class FarmManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FarmManagementController>(
      () => FarmManagementController(),
    );
  }
}
