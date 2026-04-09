import 'package:get/get.dart';

class AboutDevicesDetailsController extends GetxController {
  //TODO: Implement AboutDevicesDetailsController

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
