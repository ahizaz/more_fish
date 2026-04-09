import 'package:get/get.dart';

import '../controllers/dma_technologies_controller.dart';

class DmaTechnologiesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DmaTechnologiesController>(() => DmaTechnologiesController());
  }
}
