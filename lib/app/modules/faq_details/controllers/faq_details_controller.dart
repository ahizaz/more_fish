import 'package:get/get.dart';

class FaqDetailsController extends GetxController {
  //TODO: Implement FaqDetailsController

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
