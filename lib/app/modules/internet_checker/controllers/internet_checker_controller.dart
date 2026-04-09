import 'dart:async';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../../routes/app_pages.dart';

class InternetCheckerController extends GetxController {
  //TODO: Implement InternetCheckerController
  Timer ? timer;
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

  checkInternet() async{
    timer?.cancel();
    timer = Timer(Duration(seconds: 1), ()async {
      if(await InternetConnectionChecker.instance.hasConnection){
        Get.back();
      }
      else{
        checkInternet();
      }
    });
  }


  void increment() => count.value++;
}
