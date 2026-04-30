import 'package:get/get.dart';
import '../controllers/poultry_index_controller.dart';
import '../controllers/poultry_header_controller.dart';
import '../controllers/poultry_notifications_controller.dart';

class PoultryIndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PoultryIndexController>(() => PoultryIndexController());
    // Shared header data (date/time + weather) for all Poultry Pulse tabs
    Get.lazyPut<PoultryHeaderController>(() => PoultryHeaderController());
    Get.lazyPut<PoultryNotificationsController>(
      () => PoultryNotificationsController(),
    );
  }
}
