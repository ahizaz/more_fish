import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../repo/auth.dart';
import '../../../response/login_response.dart';
import '../../../routes/app_pages.dart';
import '../../../service/local_storage.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var phoneNumber = "".obs;
  var showPassword = false.obs;
  var phoneError = RxnString();
  AuthRepository authRepository = AuthRepository();
  final loginResponse = Rxn<LoginResponse>();
  final loginTokenStorage = Get.find<LoginTokenStorage>();
  var isActiveLoginButton = true.obs;

  bool get _openedFromGuard {
    final args = Get.arguments;
    if (args is Map) {
      return args['fromGuard'] == true;
    }
    return false;
  }

  bool get openedFromGuard => _openedFromGuard;

  @override
  void onInit() {
    super.onInit();
  }

  login(context, email, password) async {
    debugPrint('Poultry live login email: $email');
    debugPrint('Poultry live login endpoint: /auth/login/');
    EasyLoading.show(status: 'Logging in...');

    try {
      var response = await authRepository.setLogin(
        email: email,
        password: password,
      );

      await response.fold(
        (l) async {
          debugPrint('${l.message}');
          isActiveLoginButton.value = true;
          Get.snackbar(
            'Login Failed',
            'Oops! Invalid login credentials.',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        (r) async {
          loginResponse.value = r;

          var token = await loginResponse.value?.data?.token;
          var userId = await loginResponse.value?.data?.userId;
          await loginTokenStorage.setToken(token!);
          await loginTokenStorage.setUserId(userId!);

          if (_openedFromGuard) {
            Get.back(result: true);
          } else {
            Get.offAllNamed(Routes.INDEX);
          }

          isActiveLoginButton.value = true;
          Get.snackbar(
            'Login Successful',
            'Welcome back.',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      );
    } finally {
      EasyLoading.dismiss();
    }
  }
}
