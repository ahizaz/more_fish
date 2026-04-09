import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../repo/auth.dart';
import '../../../response/forget_password_response.dart';
import '../../../routes/app_pages.dart';

class ResetPasswordController extends GetxController {

  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();
  var showNewPassword = false.obs;
  var showConfirmPassword = false.obs;
  AuthRepository authRepository = AuthRepository();
  final forgotPasswordResponse = Rxn<ForgotPasswordResponse>();
  var isActiveButton = true.obs;
  var userId = ''.obs;

  @override
  void onInit() {
    super.onInit();

  }

  resetPassword(context, userId, password) async {
    var response = await authRepository.resetPassword(userId: userId, password: password);
    response.fold(
        (l){
      print('${l.message}');
      isActiveButton.value = true;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Oops! ❌ Invalid Credentials")),
      );
    },
        (r) async {
      forgotPasswordResponse.value = r;
      Get.offAllNamed(Routes.INDEX);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Successful ✅")),
      );


    });

  }

}
