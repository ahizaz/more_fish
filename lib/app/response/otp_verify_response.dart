import 'dart:convert';

class OtpVerifyResponse {
  String? success;
  int? statusCode;
  int? userId;
  String? message;

  OtpVerifyResponse({
    this.success,
    this.statusCode,
    this.userId,
    this.message,
  });

  factory OtpVerifyResponse.fromRawJson(String str) => OtpVerifyResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OtpVerifyResponse.fromJson(Map<String, dynamic> json) => OtpVerifyResponse(
    success: json["success"],
    statusCode: json["status_code"],
    userId: json["user id"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status_code": statusCode,
    "user id": userId,
    "message": message,
  };
}
