import 'package:get/get.dart';

import '../controllers/feeder_connection_controller.dart';

class FeederConnectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeederConnectionController>(
      () => FeederConnectionController(),
    );
  }
}
