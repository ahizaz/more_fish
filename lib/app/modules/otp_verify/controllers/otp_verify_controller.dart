import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../repo/auth.dart';
import '../../../response/otp_verify_response.dart';
import '../../../routes/app_pages.dart';

class OtpVerifyController extends GetxController {

  AuthRepository authRepository = AuthRepository();
  final otpVerifyResponse = Rxn<OtpVerifyResponse>();
  var isActiveButton = true.obs;

  otpVerification(context, code, ) async {
    var response = await authRepository.otpVerify(code: code);
    response.fold(
            (l){
          print('${l.message}');
          isActiveButton.value = true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Oops! ❌ Invalid OTP.")),
          );
        },
            (r) async {
          otpVerifyResponse.value = r;
          Get.toNamed(Routes.RESET_PASSWORD, arguments: {"userId": otpVerifyResponse.value?.userId});
          isActiveButton.value = true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Successful ✅")),
          );


        });

  }


  final textControllers = List.generate(6, (_) => TextEditingController());
  final focusNodes = List.generate(6, (_) => FocusNode());
  final otp = List.filled(6, '').obs;

  void updateOTP(int index, String value) {
    otp[index] = value;

    if (value.isNotEmpty) {
      if (index < 5) {
        focusNodes[index + 1].requestFocus();
      } else {
        focusNodes[index].unfocus(); // last digit
      }
    }
  }

  void backspaceOTP(int index) {
    if (index > 0) {
      focusNodes[index - 1].requestFocus();
      textControllers[index - 1].clear();
      otp[index - 1] = '';
    }
  }



}
