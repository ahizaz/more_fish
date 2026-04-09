import 'dart:convert';

class ProfileResponse {
  String? success;
  int? statusCode;
  String? message;
  Data? data;

  ProfileResponse({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory ProfileResponse.fromRawJson(String str) => ProfileResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProfileResponse.fromJson(Map<String, dynamic> json) => ProfileResponse(
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status_code": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  int? id;
  String? usrEmail;
  String? firstName;
  String? lastName;
  bool? isActive;
  int? userType;
  dynamic userPhone;
  dynamic userAddress;
  dynamic userCitizenship;
  List<dynamic>? userEducation;
  dynamic userOccupation;
  List<dynamic>? userLocation;
  UserFcm? userFcm;
  UserOtp? userOtp;
  int? companyId;

  Data({
    this.id,
    this.usrEmail,
    this.firstName,
    this.lastName,
    this.isActive,
    this.userType,
    this.userPhone,
    this.userAddress,
    this.userCitizenship,
    this.userEducation,
    this.userOccupation,
    this.userLocation,
    this.userFcm,
    this.userOtp,
    this.companyId,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    usrEmail: json["usr_email"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    isActive: json["is_active"],
    userType: json["user_type"],
    userPhone: json["user_phone"],
    userAddress: json["user_address"],
    userCitizenship: json["user_citizenship"],
    userEducation: json["user_education"] == null ? [] : List<dynamic>.from(json["user_education"]!.map((x) => x)),
    userOccupation: json["user_occupation"],
    userLocation: json["user_location"] == null ? [] : List<dynamic>.from(json["user_location"]!.map((x) => x)),
    userFcm: json["user_fcm"] == null ? null : UserFcm.fromJson(json["user_fcm"]),
    userOtp: json["user_otp"] == null ? null : UserOtp.fromJson(json["user_otp"]),
    companyId: json["company_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "usr_email": usrEmail,
    "first_name": firstName,
    "last_name": lastName,
    "is_active": isActive,
    "user_type": userType,
    "user_phone": userPhone,
    "user_address": userAddress,
    "user_citizenship": userCitizenship,
    "user_education": userEducation == null ? [] : List<dynamic>.from(userEducation!.map((x) => x)),
    "user_occupation": userOccupation,
    "user_location": userLocation == null ? [] : List<dynamic>.from(userLocation!.map((x) => x)),
    "user_fcm": userFcm?.toJson(),
    "user_otp": userOtp?.toJson(),
    "company_id": companyId,
  };
}

class UserFcm {
  String? token;

  UserFcm({
    this.token,
  });

  factory UserFcm.fromRawJson(String str) => UserFcm.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserFcm.fromJson(Map<String, dynamic> json) => UserFcm(
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
  };
}

class UserOtp {
  dynamic otp;

  UserOtp({
    this.otp,
  });

  factory UserOtp.fromRawJson(String str) => UserOtp.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserOtp.fromJson(Map<String, dynamic> json) => UserOtp(
    otp: json["otp"],
  );

  Map<String, dynamic> toJson() => {
    "otp": otp,
  };
}
