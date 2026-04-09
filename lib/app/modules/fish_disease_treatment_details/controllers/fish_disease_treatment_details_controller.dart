import 'package:get/get.dart';

class FishDiseaseTreatmentDetailsController extends GetxController {
  //TODO: Implement FishDiseaseTreatmentDetailsController

  final count = 0.obs;
  var title = '';
  var data = [];

  @override
  void onInit() {
    super.onInit();
    title = Get.arguments["diseaseName"];
    data = Get.arguments["data"];
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
