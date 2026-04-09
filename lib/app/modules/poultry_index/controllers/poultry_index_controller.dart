import 'package:get/get.dart';
import '../../../service/local_storage.dart';

class PoultryIndexController extends GetxController {
  final selectedIndex = 0.obs;
  var isLoggedIn = '';

  @override
  void onInit() {
    super.onInit();
    checkLogin();
  }

  void checkLogin() {
    final loginTokenStorage = Get.find<LoginTokenStorage>();
    if (loginTokenStorage.getToken() != null) {
      isLoggedIn = loginTokenStorage.getToken()!;
    }
  }
}
