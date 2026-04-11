import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:more_fish/app/common_widgets/common_container.dart';
import 'package:more_fish/app/common_widgets/common_text.dart';


import '../../../res/colors/colors.dart';

import '../controllers/password_change_controller.dart';

class PasswordChangeView extends GetView<PasswordChangeController> {
  const PasswordChangeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xffebffff),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.backGround,
        body: CommonContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
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
                   SizedBox(height: 30),
                        const CommonText(
                          "Change Password",
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: controller.oldPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Old Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter old password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: controller.newPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'New Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter new password';
                            } else if (value.length < 5) {
                              return 'Password must be at least 5 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: controller.confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Confirm your password';
                            } else if (value != controller.newPasswordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        Obx((){
                          return controller.isLoading.value == false ?
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
                                controller.isLoading.value = true;
                                if (controller.formKey.currentState!.validate()) {
                                  controller.changePass(
                                    oldPass: controller.oldPasswordController.text,
                                    newPass: controller.newPasswordController.text,
                                    context: context,
                                  );
                                }
                              },
                              child: controller.isLoading.value
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text(
                                "Submit",
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ) : const CircularProgressIndicator();
                        })
                        ,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

