import 'dart:async';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../routes/app_pages.dart';
import '../../../service/local_storage.dart';

class IndexController extends GetxController {

  var selectedIndex = 0.obs;
  var isLoggedIn = '';
  Timer ? timer;

  @override
  void onInit() {
    super.onInit();
    checkLogin();
    internetChecker();
}

  checkLogin(){
    final loginTokenStorage = Get.find<LoginTokenStorage>();
    if(loginTokenStorage.getToken() != null ){
      isLoggedIn = loginTokenStorage.getToken()!;

    }

    print(isLoggedIn);
  }

  internetChecker() async{
    timer?.cancel();
    timer = Timer(const Duration(seconds: 1), ()async {
      if(await InternetConnectionChecker.instance.hasConnection){
        internetChecker();
      }
      else{
        Get.toNamed(Routes.INTERNET_CHECKER);
      }
    });

  }

  }


