import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../repo/auth.dart';
import '../../../response/login_response.dart';
import '../../../routes/app_pages.dart';
import '../../../service/local_storage.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var phoneNumber = "".obs;
  var showPassword = false.obs;
  var phoneError = RxnString();
  AuthRepository authRepository = AuthRepository();
  final loginResponse = Rxn<LoginResponse>();
  final loginTokenStorage = Get.find<LoginTokenStorage>();
  var isActiveLoginButton = true.obs;


  @override
  void onInit() {
    super.onInit();
  }


  login(context, email, password) async {
    var response = await authRepository.setLogin(email: email, password: password);
    response.fold(
            (l){
              print('${l.message}');
              isActiveLoginButton.value = true;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Oops! ❌ Invalid login credentials.")),
              );
            },
            (r) async {
              loginResponse.value = r;

              var token = await loginResponse.value?.data?.token;
              var userId = await loginResponse.value?.data?.userId;
              await loginTokenStorage.setToken(token!);
              await loginTokenStorage.setUserId(userId!);
              Get.offAllNamed(Routes.INDEX);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Login Successful ✅")),
              );


            });

  }

}

