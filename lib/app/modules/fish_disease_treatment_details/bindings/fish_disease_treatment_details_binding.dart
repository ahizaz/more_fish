import 'package:get/get.dart';

import '../controllers/fish_disease_treatment_details_controller.dart';

class FishDiseaseTreatmentDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FishDiseaseTreatmentDetailsController>(
      () => FishDiseaseTreatmentDetailsController(),
    );
  }
}
