import 'package:get/get.dart';

import '../controllers/pond_management_details_controller.dart';

class PondManagementDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PondManagementDetailsController>(
      () => PondManagementDetailsController(),
    );
  }
}
