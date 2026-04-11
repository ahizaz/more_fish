

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../repo/auth.dart';
import '../../../response/password_change_response.dart';
import '../../../routes/app_pages.dart';

class PasswordChangeController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isLoading = false.obs;
  AuthRepository authRepository = AuthRepository();
  final changePassResponse = Rxn<PasswordChangeResponse>();
  @override
  void onInit() {
    super.onInit();

  }




  changePass({oldPass, newPass, context} ) async{

    var response = await authRepository.changePassword(oldPassword: oldPass, newPassword: newPass);
    response.fold(
            (l){
              isLoading.value = false;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Oops! ❌ Invalid credentials.")),
          );
        }, (r) async {
      changePassResponse.value = r;
      Get.offAllNamed(Routes.INDEX);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password Changed Successfully ✅")),
      );

    });

  }

}
