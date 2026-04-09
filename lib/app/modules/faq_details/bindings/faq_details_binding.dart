import 'package:get/get.dart';

import '../controllers/faq_details_controller.dart';

class FaqDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FaqDetailsController>(
      () => FaqDetailsController(),
    );
  }
}
