import 'package:get/get.dart';

import '../controllers/fcr_calculator_controller.dart';

class FcrCalculatorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FcrCalculatorController>(() => FcrCalculatorController());
  }
}
