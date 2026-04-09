import 'package:get/get.dart';

import '../controllers/farm_management_details_controller.dart';

class FarmManagementDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FarmManagementDetailsController>(
      () => FarmManagementDetailsController(),
    );
  }
}
