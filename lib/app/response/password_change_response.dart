import 'dart:convert';

class PasswordChangeResponse {
  String status;
  int code;
  String message;

  PasswordChangeResponse({
    required this.status,
    required this.code,
    required this.message,
  });

  factory PasswordChangeResponse.fromRawJson(String str) => PasswordChangeResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PasswordChangeResponse.fromJson(Map<String, dynamic> json) => PasswordChangeResponse(
    status: json["status"],
    code: json["code"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "message": message,
  };
}
