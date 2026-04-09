import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../common_widgets/common_container.dart';
import '../../../common_widgets/common_text.dart';
import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Color(0xffebffff),
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
        child: Scaffold(

      body: CommonContainer(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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

                    CommonText(
                      "Login",
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    SizedBox(height: 20),

                    TextFormField(
                      controller: controller.emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Enter your email";
                        String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                        if (!RegExp(emailPattern).hasMatch(value) && value.length < 6) {
                          return "Enter a valid email or phone";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),

                    Obx(() => TextFormField(
                      controller: controller.passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(controller.showPassword.value
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () => controller.showPassword.value =
                          !controller.showPassword.value,
                        ),
                      ),
                      obscureText: !controller.showPassword.value,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Enter your password";
                        if (value.length < 5) return "Password must be at least 5 characters";
                        return null;
                      },
                    )),
                    SizedBox(height: 5),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.toNamed(Routes.FORGET_PASSWORD);
                          },
                          child: CommonText(
                            "Forgot Password?",
                            color: Colors.blueGrey.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ]
                    ),

                    SizedBox(height: 20),

                    Obx((){
                      return controller.isActiveLoginButton == true?
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            if (controller.formKey.currentState!.validate()) {
                              controller.isActiveLoginButton.value = false;
                              print("Email/Phone: ${controller.emailController.text}");
                              print("Password: ${controller.passwordController.text}");
                              controller.login(context, controller.emailController.text, controller.passwordController.text);
                            }
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ) : CircularProgressIndicator();
                    }),

                    SizedBox(height: 15),

                    TextButton(
                      onPressed: () {
                        Get.toNamed(Routes.REGISTRATION);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(color: Colors.blueGrey),
                          ),
                          Text(
                            " Register",
                            style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
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
