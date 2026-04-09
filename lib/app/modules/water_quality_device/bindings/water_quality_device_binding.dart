import 'package:get/get.dart';

import '../controllers/water_quality_device_controller.dart';

class WaterQualityDeviceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WaterQualityDeviceController>(
      () => WaterQualityDeviceController(),
    );
  }
}
