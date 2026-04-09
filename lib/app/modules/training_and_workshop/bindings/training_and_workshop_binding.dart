import 'package:get/get.dart';

import '../controllers/training_and_workshop_controller.dart';

class TrainingAndWorkshopBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrainingAndWorkshopController>(
      () => TrainingAndWorkshopController(),
    );
  }
}
