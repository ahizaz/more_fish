import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../repo/auth.dart';
import '../../../response/forget_password_response.dart';
import '../../../response/otp_verify_response.dart';
import '../../../routes/app_pages.dart';

class ForgotPasswordController extends GetxController {
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  AuthRepository authRepository = AuthRepository();
  final forgotPasswordResponse = Rxn<ForgotPasswordResponse>();
  final otpVerifyResponse = Rxn<OtpVerifyResponse>();
  var isActiveButton = true.obs;
  var completePhoneNumber = ''.obs;
  var phoneError = RxnString();

  @override
  void onClose() {
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }


  forgotPass(context, email, phone) async {
    var response = await authRepository.forgotPassword(email: email, phone: phone);
    response.fold(
            (l){
          debugPrint(l.message);
          isActiveButton.value = true;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Oops! ❌ Invalid credentials.")),
          );
        },
            (r) async {
              forgotPasswordResponse.value = r;
              Get.toNamed(Routes.OTP_VERIFY);
              isActiveButton.value = true;
              ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Successful ✅")),
          );


        });

  }



}


