import 'package:get/get.dart';

import '../controllers/password_change_controller.dart';

class PasswordChangeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PasswordChangeController>(
      () => PasswordChangeController(),
    );
  }
}
