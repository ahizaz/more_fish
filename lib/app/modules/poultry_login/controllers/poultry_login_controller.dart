import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../repo/auth.dart';
import '../../../response/login_response.dart';
import '../../../routes/app_pages.dart';
import '../../../service/local_storage.dart';

class PoultryLoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var showPassword = false.obs;
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
    _bypassGuardLoginIfAlreadyAuthenticated();
  }

  void _bypassGuardLoginIfAlreadyAuthenticated() {
    if (!_openedFromGuard) {
      return;
    }

    if (loginTokenStorage.hasValidToken()) {
      debugPrint(
        'Guard poultry login skipped: token already found in SharedPreferences.',
      );
      Future.microtask(() => Get.back(result: true));
    }
  }

  Future<void> login({required String email, required String password}) async {
    debugPrint('Poultry login email: $email');
    EasyLoading.show(status: 'Logging in...');

    try {
      var response = await authRepository.setLogin(
        email: email,
        password: password,
        isPoultryFlow: true,
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

          final token = loginResponse.value?.data?.token;
          final userId = loginResponse.value?.data?.userId;

          if (token == null || token.trim().isEmpty || userId == null) {
            debugPrint(
              'Poultry login response missing token/userId, cannot persist session.',
            );
            isActiveLoginButton.value = true;
            Get.snackbar(
              'Login Failed',
              'Session data not found from server response.',
              snackPosition: SnackPosition.BOTTOM,
            );
            return;
          }

          await loginTokenStorage.setToken(token);
          await loginTokenStorage.setUserId(userId);

          if (_openedFromGuard) {
            Get.back(result: true);
          } else {
            Get.offAllNamed(Routes.POULTRY_INDEX);
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
      isActiveLoginButton.value = true;
      EasyLoading.dismiss();
    }
  }
}
