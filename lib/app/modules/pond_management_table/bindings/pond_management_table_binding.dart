import 'package:get/get.dart';

import '../controllers/pond_management_table_controller.dart';

class PondManagementTableBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PondManagementTableController>(
      () => PondManagementTableController(),
    );
  }
}
