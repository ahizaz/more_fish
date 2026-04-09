import 'package:get/get.dart';

class AboutAppDetailsController extends GetxController {
  //TODO: Implement AboutAppDetailsController

  final count = 0.obs;
  var data = '';
  var title = '';

  @override
  void onInit() {
    super.onInit();
    data = Get.arguments["data"];
    title = Get.arguments["title"];
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
