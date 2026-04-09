import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../service/local_storage.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.putAsync<LoginTokenStorage>(() async {
      final prefs = await SharedPreferences.getInstance();
      return LoginTokenStorage(prefs);
    });

    Get.lazyPut<LoginController>(() => LoginController());
  }
}

