import 'package:get/get.dart';

import '../../../res/strings/smart_khamari.dart';

class SmartKhamariController extends GetxController {
  //TODO: Implement SmartKhamariController

  var titleList = [
    SmartKhamari.title1,
    SmartKhamari.title2,
    SmartKhamari.title3,
    SmartKhamari.title4,
    SmartKhamari.title5,
    SmartKhamari.title6,
    SmartKhamari.title7,
    SmartKhamari.title8,
    SmartKhamari.title9,
  ].obs;

  var dataList = [
    SmartKhamari.text1,
    SmartKhamari.text2,
    SmartKhamari.text3,
    SmartKhamari.text4,
    SmartKhamari.text5,
    SmartKhamari.text6,
    SmartKhamari.text7,
    SmartKhamari.text8,
    SmartKhamari.text9,
  ].obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
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
