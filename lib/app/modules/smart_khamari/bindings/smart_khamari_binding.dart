import 'package:get/get.dart';

import '../controllers/smart_khamari_controller.dart';

class SmartKhamariBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SmartKhamariController>(
      () => SmartKhamariController(),
    );
  }
}
