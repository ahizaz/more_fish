import 'dart:convert';

class ForgotPasswordResponse {
  String? success;
  int? statusCode;
  String? message;

  ForgotPasswordResponse({
    this.success,
    this.statusCode,
    this.message,
  });

  factory ForgotPasswordResponse.fromRawJson(String str) => ForgotPasswordResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) => ForgotPasswordResponse(
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status_code": statusCode,
    "message": message,
  };
}
