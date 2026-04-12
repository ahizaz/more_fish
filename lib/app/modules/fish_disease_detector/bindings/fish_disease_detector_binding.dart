import 'package:get/get.dart';

import '../controllers/fish_disease_detector_controller.dart';

class FishDiseaseDetectorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FishDiseaseDetectorController>(
      () => FishDiseaseDetectorController(),
    );
  }
}
