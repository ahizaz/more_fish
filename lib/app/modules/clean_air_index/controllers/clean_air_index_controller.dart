import 'package:get/get.dart';

import '../../../service/local_storage.dart';

class CleanAirIndexController extends GetxController {
  final selectedIndex = 0.obs;
  var isLoggedIn = '';

  @override
  void onInit() {
    super.onInit();
    checkLogin();
  }

  void checkLogin() {
    final loginTokenStorage = Get.find<LoginTokenStorage>();
    final token = loginTokenStorage.getToken();
    if (token != null) {
      isLoggedIn = token;
    }
  }
}
