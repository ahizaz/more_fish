import 'package:get/get.dart';

import '../controllers/feed_management_controller.dart';

class FeedManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeedManagementController>(
      () => FeedManagementController(),
    );
  }
}
