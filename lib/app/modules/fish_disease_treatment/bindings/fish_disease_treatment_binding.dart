import 'package:get/get.dart';

import '../controllers/fish_disease_treatment_controller.dart';

class FishDiseaseTreatmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FishDiseaseTreatmentController>(
      () => FishDiseaseTreatmentController(),
    );
  }
}
