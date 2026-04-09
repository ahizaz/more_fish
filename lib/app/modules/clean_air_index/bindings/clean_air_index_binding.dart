import 'package:get/get.dart';

import '../controllers/clean_air_header_controller.dart';
import '../controllers/clean_air_index_controller.dart';

class CleanAirIndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CleanAirIndexController>(() => CleanAirIndexController());
    // Shared header data (date/time + weather) for all Clean Air tabs
    Get.lazyPut<CleanAirHeaderController>(() => CleanAirHeaderController());
  }
}
