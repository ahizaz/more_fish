import 'package:get/get.dart';

import '../controllers/aerator_connection_controller.dart';

class AeratorConnectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AeratorConnectionController>(
      () => AeratorConnectionController(),
    );
  }
}
