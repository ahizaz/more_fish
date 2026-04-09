import 'package:get/get.dart';

import '../controllers/feed_management_details_controller.dart';

class FeedManagementDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeedManagementDetailsController>(
      () => FeedManagementDetailsController(),
    );
  }
}
