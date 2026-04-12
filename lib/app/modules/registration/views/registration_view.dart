import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import '../../../repo/registration_request.dart';
import '../controllers/registration_controller.dart';

class RegistrationView extends GetView<RegistrationController> {
  const RegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    final RegistrationController controller = Get.put(RegistrationController());

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Color(0xffebffff),
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
        child: Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffebffff), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Registration",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller.firstNameController,
                            decoration: InputDecoration(
                              labelText: "First Name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                              ),
                            ),
                            validator: (value) =>
                            (value == null || value.isEmpty) ? "Enter your first name" : null,
                          ),
                        ),
                        const SizedBox(width: 12,),
                        Expanded(
                          child: TextFormField(
                            controller: controller.lastNameController,
                            decoration: InputDecoration(
                              labelText: "Last Name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                              ),
                            ),
                            validator: (value) =>
                            (value == null || value.isEmpty) ? "Enter your last name" : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    TextFormField(
                      controller: controller.addressController,
                      decoration: InputDecoration(
                        labelText: "Address",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter your Address";
                        }
                        if(value.length > 80){
                          return "Valid range is 80";
                        }
                        return null;
                      }

                    ),
                    const SizedBox(height: 15),

                    TextFormField(
                      controller: controller.emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Enter your email";
                        String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                        if (!RegExp(pattern).hasMatch(value)) return "Enter a valid email";
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),

                    IntlPhoneField(
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      initialCountryCode: 'BD',
                      onChanged: (phone) {
                        controller.phoneNumber.value = phone.completeNumber;
                      },
                    ),
                    const SizedBox(height: 15),

                    Obx((){
                      return TextFormField(
                        controller: controller.passwordController,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)

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
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Enter your password";
                          if (value.length < 5) return "Password must be at least 5 characters";
                          return null;
                        },
                      );
                    }),
                    const SizedBox(height: 15),
                    Obx((){
                      return TextFormField(
                        controller: controller.confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
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
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Confirm your password";
                          if (value != controller.passwordController.text) return "Passwords do not match";
                          return null;
                        },
                      );
                    })
                    ,
                    const SizedBox(height: 15),

                    /*Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Obx(() => Checkbox(
                                value: controller.isCustomer.value,
                                onChanged: (v) {
                                  controller.isCustomer.value = v!;
                                  controller.roleError.value = null;
                                },
                              )),
                              Text("Customer"),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Obx(() => Checkbox(
                                value: controller.isOrganization.value,
                                onChanged: (v) {
                                  controller.isOrganization.value = v!;
                                  controller.roleError.value = null;
                                },
                              )),
                              Text("Organization"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Obx(() => controller.roleError.value != null
                        ? Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        controller.roleError.value!,
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    )
                        : SizedBox()),
                    SizedBox(height: 15),
                    Obx(() => controller.isOrganization.value
                        ? Column(
                      children: [
                        TextFormField(
                          controller: controller.organizationNameController,
                          decoration: InputDecoration(
                            labelText: "Organization Name",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Obx(() => controller.orgError.value != null
                            ? Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            controller.orgError.value!,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        )
                            : SizedBox()),
                        SizedBox(height: 15),
                      ],
                    )
                        : SizedBox()),
                    SizedBox(height: 15,),*/

                    Obx((){
                      return controller.isActiveRegButton == true ?
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
                            bool valid = controller.formKey.currentState!.validate();

                            /*if (!controller.isCustomer.value && !controller.isOrganization.value) {
                              controller.roleError.value = "Select at least one role";
                              valid = false;
                            }

                            if (controller.isOrganization.value &&
                                controller.organizationNameController.text.isEmpty) {
                              controller.orgError.value = "Enter organization name";
                              valid = false;
                            }*/
                            if (!valid) return;

                            if(valid){
                              controller.isActiveRegButton.value = false;

                              final requestModel = RegistrationRequest(
                                firstName: controller.firstNameController.text,
                                lastName: controller.lastNameController.text,
                                usrEmail: controller.emailController.text,
                                phone: controller.phoneNumber.value,
                                password: controller.passwordController.text,
                                company: 1,
                                userType: 2,
                                userDetails: "null",
                                usrAddress: controller.addressController.text,
                                interestedProductDetails: "null",
                              );

                              controller.registration(requestModel, context);
                            }

                          },
                          child: const Text(
                            "Submit",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ): const CircularProgressIndicator();
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

