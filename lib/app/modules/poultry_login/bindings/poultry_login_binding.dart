import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../service/local_storage.dart';
import '../controllers/poultry_login_controller.dart';

class PoultryLoginBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<LoginTokenStorage>()) {
      Get.putAsync<LoginTokenStorage>(() async {
        final prefs = await SharedPreferences.getInstance();
        return LoginTokenStorage(prefs);
      });
    }

    Get.lazyPut<PoultryLoginController>(() => PoultryLoginController());
  }
}
