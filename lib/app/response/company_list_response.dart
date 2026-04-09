import 'dart:convert';

class CompanyListResponse {
  List<Datum>? data;
  String? success;
  int? statusCode;
  String? message;

  CompanyListResponse({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  factory CompanyListResponse.fromRawJson(String str) => CompanyListResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CompanyListResponse.fromJson(Map<String, dynamic> json) => CompanyListResponse(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "success": success,
    "status_code": statusCode,
    "message": message,
  };
}

class Datum {
  int? id;
  String? name;

  Datum({
    this.id,
    this.name,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
