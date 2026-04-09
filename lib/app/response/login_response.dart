import 'dart:convert';

class LoginResponse {
  bool? success;
  int? statusCode;
  String? message;
  Data? data;

  LoginResponse({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory LoginResponse.fromRawJson(String str) => LoginResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
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
  int? userId;
  String? token;
  UserData? userData;

  Data({
    this.userId,
    this.token,
    this.userData,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["user_id"],
    token: json["token"],
    userData: json["user_data"] == null ? null : UserData.fromJson(json["user_data"]),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "token": token,
    "user_data": userData?.toJson(),
  };
}

class UserData {
  int? id;
  String? usrEmail;
  String? firstName;
  String? lastName;
  bool? isActive;
  int? userType;
  UserPhone? userPhone;
  dynamic userAddress;
  dynamic userCitizenship;
  List<dynamic>? userEducation;
  dynamic userOccupation;
  List<dynamic>? userLocation;
  UserFcm? userFcm;
  UserOtp? userOtp;
  int? companyId;

  UserData({
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

  factory UserData.fromRawJson(String str) => UserData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json["id"],
    usrEmail: json["usr_email"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    isActive: json["is_active"],
    userType: json["user_type"],
    userPhone: json["user_phone"] == null ? null : UserPhone.fromJson(json["user_phone"]),
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
    "user_phone": userPhone?.toJson(),
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

class UserPhone {
  dynamic phnBusiness;
  String? phnCell;
  dynamic phnHome;

  UserPhone({
    this.phnBusiness,
    this.phnCell,
    this.phnHome,
  });

  factory UserPhone.fromRawJson(String str) => UserPhone.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserPhone.fromJson(Map<String, dynamic> json) => UserPhone(
    phnBusiness: json["phn_business"],
    phnCell: json["phn_cell"],
    phnHome: json["phn_home"],
  );

  Map<String, dynamic> toJson() => {
    "phn_business": phnBusiness,
    "phn_cell": phnCell,
    "phn_home": phnHome,
  };
}



