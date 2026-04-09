import 'dart:convert';

class RegistrationResponse {
  String success;
  int statusCode;
  String message;
  Data data;

  RegistrationResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory RegistrationResponse.fromRawJson(String str) => RegistrationResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) => RegistrationResponse(
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status_code": statusCode,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  String firstName;
  String lastName;
  String usrEmail;
  int company;
  int userType;
  String userDetails;
  String usrAddress;
  String interestedProductDetails;

  Data({
    required this.firstName,
    required this.lastName,
    required this.usrEmail,
    required this.company,
    required this.userType,
    required this.userDetails,
    required this.usrAddress,
    required this.interestedProductDetails,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    firstName: json["first_name"],
    lastName: json["last_name"],
    usrEmail: json["usr_email"],
    company: json["company"],
    userType: json["user_type"],
    userDetails: json["user_details"],
    usrAddress: json["usr_address"],
    interestedProductDetails: json["interested_product_details"],
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "last_name": lastName,
    "usr_email": usrEmail,
    "company": company,
    "user_type": userType,
    "user_details": userDetails,
    "usr_address": usrAddress,
    "interested_product_details": interestedProductDetails,
  };
}
