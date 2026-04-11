import 'package:get/get.dart';

class FeedManagementDetailsController extends GetxController {
  
  final count = 0.obs;
  var title = ''.obs;
  var data = [].obs;

  @override
  void onInit() {
    super.onInit();
    title.value = Get.arguments["title"];
    data.value = Get.arguments["data"];
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
