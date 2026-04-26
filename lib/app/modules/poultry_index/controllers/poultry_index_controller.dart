// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import '../../../repo/auth.dart';
// import '../../../routes/app_pages.dart';
// import '../../../service/local_storage.dart';

// class PoultryIndexController extends GetxController {
//   final selectedIndex = 0.obs;
//   var isLoggedIn = '';
//   final AuthRepository _authRepository = AuthRepository();

//   @override
//   void onInit() {
//     super.onInit();
//     checkLogin();
//   }

//   void checkLogin() {
//     final loginTokenStorage = Get.find<LoginTokenStorage>();
//     final token = loginTokenStorage.getToken();

//     if (_hasValidToken(token)) {
//       isLoggedIn = token!.trim();
//     } else {
//       isLoggedIn = '';
//     }
//   }

//   bool _hasValidToken(String? token) {
//     if (token == null) return false;
//     final normalized = token.trim().toLowerCase();
//     return normalized.isNotEmpty &&
//         normalized != 'null' &&
//         normalized != 'undefined';
//   }

//   Future<bool> ensureLoggedIn() async {
//     checkLogin();
//     if (isLoggedIn.isNotEmpty) {
//       return true;
//     }

//     final result = await Get.toNamed(
//       Routes.POULTRY_LOGIN,
//       arguments: {'fromGuard': true},
//     );

//     checkLogin();
//     return result == true || isLoggedIn.isNotEmpty;
//   }

//   Future<bool> loginWithCredentials({
//     required String username,
//     required String password,
//   }) async {
//     EasyLoading.show(status: 'Signing in...');
//     debugPrint('Poultry login email input: $username');

//     try {
//       final response = await _authRepository.setLogin(
//         email: username,
//         password: password,
//       );

//       return response.fold(
//         (failure) {
//           debugPrint('Poultry login failed: ${failure.message}');
//           Get.snackbar(
//             'Login Failed',
//             'Invalid username or password.',
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: Colors.red.shade50,
//             colorText: Colors.red.shade900,
//             duration: const Duration(seconds: 2),
//           );
//           return false;
//         },
//         (loginResponse) async {
//           debugPrint('Poultry login message: ${loginResponse.message}');

//           final token = loginResponse.data?.token;
//           final userId = loginResponse.data?.userId;

//           if (token == null || userId == null) {
//             debugPrint(
//               'Poultry login failed: token or userId missing from response',
//             );
//             Get.snackbar(
//               'Login Failed',
//               'Unexpected server response.',
//               snackPosition: SnackPosition.BOTTOM,
//               backgroundColor: Colors.red.shade50,
//               colorText: Colors.red.shade900,
//               duration: const Duration(seconds: 2),
//             );
//             return false;
//           }

//           final loginTokenStorage = Get.find<LoginTokenStorage>();
//           await loginTokenStorage.setToken(token);
//           await loginTokenStorage.setUserId(userId);
//           isLoggedIn = token;
//           debugPrint('Poultry login token saved in SharedPreferences');

//           Get.snackbar(
//             'Login Successful',
//             'Welcome back.',
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: const Color(0xffeaf7ee),
//             colorText: const Color(0xff1f6f3c),
//             duration: const Duration(seconds: 2),
//           );
//           return true;
//         },
//       );
//     } finally {
//       EasyLoading.dismiss();
//     }
//   }
// }
// app/modules/poultry_index/controllers/poultry_index_controller.dart

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../repo/auth.dart';
import '../../../routes/app_pages.dart';
import '../../../service/local_storage.dart';

class PoultryIndexController extends GetxController {
  final selectedIndex = 0.obs;

  /// keep reactive so logout updates instantly
  final isLoggedIn = ''.obs;

  final AuthRepository _authRepository = AuthRepository();

  @override
  void onInit() {
    super.onInit();
    checkLogin();
  }

  void checkLogin() {
    final loginTokenStorage = Get.find<LoginTokenStorage>();
    final token = loginTokenStorage.getToken();

    debugPrint('Saved token after app reopen: $token');

    if (_hasValidToken(token)) {
      isLoggedIn.value = token!.trim();
    } else {
      isLoggedIn.value = '';
    }
  }

  bool _hasValidToken(String? token) {
    if (token == null) return false;

    final normalized = token.trim().toLowerCase();

    return normalized.isNotEmpty &&
        normalized != 'null' &&
        normalized != 'undefined';
  }

  Future<bool> ensureLoggedIn() async {
    /// Always re-check latest token from storage
    checkLogin();

    if (isLoggedIn.value.isNotEmpty) {
      return true;
    }

    final result = await Get.toNamed(
      Routes.POULTRY_LOGIN,
      arguments: {'fromGuard': true},
    );

    /// Re-check after login screen returns
    checkLogin();

    return result == true || isLoggedIn.value.isNotEmpty;
  }

  Future<bool> loginWithCredentials({
    required String username,
    required String password,
  }) async {
    EasyLoading.show(status: 'Signing in...');

    debugPrint('Poultry login email input: $username');

    try {
      final response = await _authRepository.setLogin(
        email: username,
        password: password,
      );

      return response.fold(
        (failure) {
          debugPrint(
            'Poultry login failed: ${failure.message}',
          );

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
          debugPrint(
            'Poultry login message: ${loginResponse.message}',
          );

          final token = loginResponse.data?.token;
          final userId = loginResponse.data?.userId;

          if (token == null || userId == null) {
            debugPrint(
              'Poultry login failed: token or userId missing from response',
            );

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

          final loginTokenStorage =
              Get.find<LoginTokenStorage>();

          await loginTokenStorage.setToken(token);
          await loginTokenStorage.setUserId(userId);

          /// update memory state immediately
          isLoggedIn.value = token.trim();

          debugPrint(
            'Poultry login token saved in SharedPreferences',
          );

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
    } finally {
      EasyLoading.dismiss();
    }
  }
}