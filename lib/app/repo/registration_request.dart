import 'dart:convert';

class RegistrationRequest {
  String usrEmail;
  String password;
  String phone;
  String firstName;
  String lastName;
  int userType;
  int company;
  String userDetails;
  String usrAddress;
  String interestedProductDetails;

  RegistrationRequest({
    required this.usrEmail,
    required this.password,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.userType,
    required this.company,
    required this.userDetails,
    required this.usrAddress,
    required this.interestedProductDetails,
  });

  factory RegistrationRequest.fromRawJson(String str) => RegistrationRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RegistrationRequest.fromJson(Map<String, dynamic> json) => RegistrationRequest(
    usrEmail: json["usr_email"],
    password: json["password"],
    phone: json["phone"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    userType: json["user_type"],
    company: json["company"],
    userDetails: json["user_details"],
    usrAddress: json["usr_address"],
    interestedProductDetails: json["interested_product_details"],
  );

  Map<String, dynamic> toJson() => {
    "usr_email": usrEmail,
    "password": password,
    "phone": phone,
    "first_name": firstName,
    "last_name": lastName,
    "user_type": userType,
    "company": company,
    "user_details": userDetails,
    "usr_address": usrAddress,
    "interested_product_details": interestedProductDetails,
  };
}
