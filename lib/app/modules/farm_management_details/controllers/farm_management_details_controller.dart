import 'package:get/get.dart';

class FarmManagementDetailsController extends GetxController {

  var title = "";
  var data = "";
  var index = 0;

  @override
  void onInit() {
    super.onInit();

    title = Get.arguments["title"];
    data = Get.arguments["data"];
    index = Get.arguments["index"];
  }


}
