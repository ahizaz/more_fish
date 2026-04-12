import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:more_fish/app/res/colors/colors.dart';

import '../../../common_widgets/common_container.dart';
import '../../../common_widgets/common_text.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    if(Get.arguments != null){
     controller.userId.value = Get.arguments["userId"].toString();
    }
    return Scaffold(
      backgroundColor: AppColors.backGround,
      body: CommonContainer(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: SingleChildScrollView(
              child: Center(
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(
                            "assets/icons/logo_trade_mark.jpg",
                            height: 120,
                            width: 120,
                          ),
                        ),
                      const SizedBox(height: 30),
                      CommonText(
                        'Reset Password',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                      const SizedBox(height: 20),
                      Obx((){
                        return Column(
                          children: [
                            TextFormField(
                              controller: controller.passwordController,
                              decoration: InputDecoration(
                                labelText: "New Password",
                                hintText: "Password minimum 8 digits",
                                hintStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(controller.showNewPassword.value
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () => controller.showNewPassword.value =
                                  !controller.showNewPassword.value,
                                ),
                              ),
                              obscureText: !controller.showNewPassword.value,
                              validator: (value){
                                if(value == null|| value.isEmpty){
                                  return "Enter your password";
                                }if (value.length < 8) return "Password must be at least 8 characters";
                                return null;
                              },

                            ),
                            const SizedBox(height: 30,),
                            TextFormField(
                              controller: controller.confirmPassController,
                              decoration: InputDecoration(
                                labelText: "Confirm Password",
                                hintText: "Password minimum 8 digits",
                                hintStyle: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(controller.showConfirmPassword.value
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () => controller.showConfirmPassword.value =
                                  !controller.showConfirmPassword.value,
                                ),
                              ),
                              obscureText: !controller.showConfirmPassword.value,
                              validator: (value){
                                if(value == null|| value.isEmpty) return "Enter your password";
                                if (value.length < 8) return "Password must be at least 8 characters";
                                if (value != controller.passwordController.text) {
                                  return "Password does not match";
                                }
                                return null;
                              },

                            ),
                          ],
                        );
                      }),
                      const SizedBox(height: 40),
                      Obx((){
                        return controller.isActiveButton == true?
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              if (controller.formKey.currentState!.validate()) {
                                controller.isActiveButton.value = false;
                                controller.resetPassword(context, controller.userId.value, controller.passwordController.text );
                              }
                            },
                            child: const Text(
                              "Submit",
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ) : const CircularProgressIndicator();
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
