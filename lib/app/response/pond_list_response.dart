import 'dart:convert';

class PondListResponse {
  String success;
  int statusCode;
  String message;
  List<Datum> data;

  PondListResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory PondListResponse.fromRawJson(String str) => PondListResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PondListResponse.fromJson(Map<String, dynamic> json) => PondListResponse(
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status_code": statusCode,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String astName;

  Datum({
    required this.id,
    required this.astName,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    astName: json["ast_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ast_name": astName,
  };
}
