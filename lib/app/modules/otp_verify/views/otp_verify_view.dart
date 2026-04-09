import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:more_fish/app/common_widgets/common_container.dart';
import 'package:more_fish/app/common_widgets/common_text.dart';
import 'package:more_fish/app/res/colors/colors.dart';
import '../../../routes/app_pages.dart';
import '../controllers/otp_verify_controller.dart';

class OtpVerifyView extends GetView<OtpVerifyController> {
  const OtpVerifyView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGround,
      body: CommonContainer(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
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
                      "Enter OTP",
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.green.shade700,
                    ),
                    const SizedBox(height: 10),
                    CommonText(
                      'Please enter the 6-digit OTP sent to your mobile number',
                      fontSize: 16,
                      color: Colors.blueGrey.shade400,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        return SizedBox(
                          width: 45,
                          height: 45,
                          child: Focus(
                            onKey: (node, event) {
                              if (event.logicalKey.keyLabel == 'Backspace' &&
                                  controller
                                      .textControllers[index]
                                      .text
                                      .isEmpty) {
                                controller.backspaceOTP(index);
                                return KeyEventResult.handled;
                              }
                              return KeyEventResult.ignored;
                            },
                            child: TextField(
                              controller: controller.textControllers[index],
                              focusNode: controller.focusNodes[index],
                              maxLength: 1,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                counterText: '',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onChanged: (value) {
                                if (value.length == 1) {
                                  controller.updateOTP(index, value);
                                }
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 30),
                    Obx(() {
                      return controller.isActiveButton.value == true
                          ? SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  final code = controller.otp.join();
                                  if (code.length == 6 &&
                                      !controller.otp.contains('')) {
                                    controller.isActiveButton.value = false;
                                    controller.otpVerification(context, code);
                                  }
                                },
                                child: const CommonText(
                                  'Verify OTP',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          : const CircularProgressIndicator();
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
