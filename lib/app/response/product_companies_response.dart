import 'dart:convert';

class ProductCompaniesResponse {
  int statusCode;
  String success;
  String message;
  List<Datum> data;

  ProductCompaniesResponse({
    required this.statusCode,
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProductCompaniesResponse.fromRawJson(String str) => ProductCompaniesResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductCompaniesResponse.fromJson(Map<String, dynamic> json) => ProductCompaniesResponse(
    statusCode: json["status_code"],
    success: json["success"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String guid;
  int id;
  String name;
  String companyImage;

  Datum({
    required this.guid,
    required this.id,
    required this.name,
    required this.companyImage,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    guid: json["guid"],
    id: json["id"],
    name: json["name"],
    companyImage: json["company_image"],
  );

  Map<String, dynamic> toJson() => {
    "guid": guid,
    "id": id,
    "name": name,
    "company_image": companyImage,
  };
}
