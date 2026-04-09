import 'package:get/get.dart';
import '../controllers/cattle_index_controller.dart';
import '../controllers/cattle_header_controller.dart';

class CattleIndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CattleIndexController>(() => CattleIndexController());
    // Shared header data (date/time + weather) for all Cattle Care tabs
    Get.lazyPut<CattleHeaderController>(() => CattleHeaderController());
  }
}
