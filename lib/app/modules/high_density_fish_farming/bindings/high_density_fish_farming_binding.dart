import 'package:get/get.dart';

import '../controllers/high_density_fish_farming_controller.dart';

class HighDensityFishFarmingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HighDensityFishFarmingController>(
      () => HighDensityFishFarmingController(),
    );
  }
}
