import 'dart:convert';

class CategoryResponse {
  List<Datum>? data;
  int? statusCode;
  String? success;

  CategoryResponse({
    this.data,
    this.statusCode,
    this.success,
  });

  factory CategoryResponse.fromRawJson(String str) => CategoryResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoryResponse.fromJson(Map<String, dynamic> json) => CategoryResponse(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    statusCode: json["status_code"],
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "status_code": statusCode,
    "success": success,
  };
}

class Datum {
  String? guid;
  String? categoryName;
  String? categoryImage;

  Datum({
    this.guid,
    this.categoryName,
    this.categoryImage,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    guid: json["guid"],
    categoryName: json["category_name"],
    categoryImage: json["category_image"],
  );

  Map<String, dynamic> toJson() => {
    "guid": guid,
    "category_name": categoryName,
    "category_image": categoryImage,
  };
}
