import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../repo/auth.dart';
import '../../../service/local_storage.dart';
import '../widgets/poultry_login_dialog.dart';

class PoultryIndexController extends GetxController {
  final selectedIndex = 0.obs;
  var isLoggedIn = '';
  final AuthRepository _authRepository = AuthRepository();

  @override
  void onInit() {
    super.onInit();
    checkLogin();
  }

  void checkLogin() {
    final loginTokenStorage = Get.find<LoginTokenStorage>();
    if (loginTokenStorage.getToken() != null) {
      isLoggedIn = loginTokenStorage.getToken()!;
    } else {
      isLoggedIn = '';
    }
  }

  Future<bool> ensureLoggedIn() async {
    checkLogin();
    if (isLoggedIn.isNotEmpty) {
      return true;
    }

    final result = await Get.dialog<bool>(
      PoultryLoginDialog(
        onLogin: ({required String username, required String password}) {
          return loginWithCredentials(username: username, password: password);
        },
      ),
      barrierDismissible: true,
    );

    checkLogin();
    return result == true && isLoggedIn.isNotEmpty;
  }

  Future<bool> loginWithCredentials({
    required String username,
    required String password,
  }) async {
    final response = await _authRepository.setLogin(
      email: username,
      password: password,
    );

    return response.fold(
      (failure) {
        Get.snackbar(
          'Login Failed',
          'Invalid username or password.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade50,
          colorText: Colors.red.shade900,
          duration: const Duration(seconds: 2),
        );
        return false;
      },
      (loginResponse) async {
        final token = loginResponse.data?.token;
        final userId = loginResponse.data?.userId;

        if (token == null || userId == null) {
          Get.snackbar(
            'Login Failed',
            'Unexpected server response.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade50,
            colorText: Colors.red.shade900,
            duration: const Duration(seconds: 2),
          );
          return false;
        }

        final loginTokenStorage = Get.find<LoginTokenStorage>();
        await loginTokenStorage.setToken(token);
        await loginTokenStorage.setUserId(userId);
        isLoggedIn = token;

        Get.snackbar(
          'Login Successful',
          'Welcome back.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xffeaf7ee),
          colorText: const Color(0xff1f6f3c),
          duration: const Duration(seconds: 2),
        );
        return true;
      },
    );
  }
}
