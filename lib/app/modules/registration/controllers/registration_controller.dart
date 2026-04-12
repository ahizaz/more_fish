import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:more_fish/app/repo/auth.dart';
import 'package:more_fish/app/response/registration_response.dart';
import '../../../routes/app_pages.dart';

class RegistrationController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final organizationNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var showNewPassword = false.obs;
  var showConfirmPassword = false.obs;
  var phoneNumber = "".obs;

  // Checkboxes for Customer and Organization
  var isCustomer = false.obs;
  var isOrganization = false.obs;

  // Error messages
  var phoneError = RxnString();
  var roleError = RxnString();
  var orgError = RxnString();

  AuthRepository authRepository = AuthRepository();
  final registrationResponse = Rxn<RegistrationResponse>();
  var isActiveRegButton  = true.obs;

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    organizationNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }


  registration(requestModel, context) async {

    var response = await authRepository.setRegistration(requestModel: requestModel);

    response.fold(
        (l){
          debugPrint('${l.message}');
          isActiveRegButton.value = true;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Oops! ❌ Invalid registration info.")),
          );
        },
        (r){
          registrationResponse.value = r;
          Get.offAllNamed(Routes.INDEX);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registered Successfully ✅")),
          );



        }
    );


  }
}

