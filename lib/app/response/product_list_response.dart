import 'dart:convert';

class ProductListResponse {
  Data data;
  int statusCode;
  String message;
  String success;

  ProductListResponse({
    required this.data,
    required this.statusCode,
    required this.message,
    required this.success,
  });

  factory ProductListResponse.fromRawJson(String str) => ProductListResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductListResponse.fromJson(Map<String, dynamic> json) => ProductListResponse(
    data: Data.fromJson(json["data"]),
    statusCode: json["status_code"],
    message: json["message"],
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "status_code": statusCode,
    "message": message,
    "success": success,
  };
}

class Data {
  int pageNumber;
  int totalPages;
  int totalItems;
  bool hasNext;
  bool hasPrev;
  int pageSize;
  List<Datum> data;

  Data({
    required this.pageNumber,
    required this.totalPages,
    required this.totalItems,
    required this.hasNext,
    required this.hasPrev,
    required this.pageSize,
    required this.data,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    pageNumber: json["page_number"],
    totalPages: json["total_pages"],
    totalItems: json["total_items"],
    hasNext: json["has_next"],
    hasPrev: json["has_prev"],
    pageSize: json["page_size"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "page_number": pageNumber,
    "total_pages": totalPages,
    "total_items": totalItems,
    "has_next": hasNext,
    "has_prev": hasPrev,
    "page_size": pageSize,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String guid;
  String name;
  String description;
  String price;
  Category category;
  List<ProductimageSet> productimageSet;

  Datum({
    required this.guid,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.productimageSet,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    guid: json["guid"],
    name: json["name"],
    description: json["description"],
    price: json["price"],
    category: Category.fromJson(json["category"]),
    productimageSet: List<ProductimageSet>.from(json["productimage_set"].map((x) => ProductimageSet.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "guid": guid,
    "name": name,
    "description": description,
    "price": price,
    "category": category.toJson(),
    "productimage_set": List<dynamic>.from(productimageSet.map((x) => x.toJson())),
  };
}

class Category {
  String guid;
  String categoryName;
  String categoryImage;

  Category({
    required this.guid,
    required this.categoryName,
    required this.categoryImage,
  });

  factory Category.fromRawJson(String str) => Category.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Category.fromJson(Map<String, dynamic> json) => Category(
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

class ProductimageSet {
  String guid;
  String image;

  ProductimageSet({
    required this.guid,
    required this.image,
  });

  factory ProductimageSet.fromRawJson(String str) => ProductimageSet.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductimageSet.fromJson(Map<String, dynamic> json) => ProductimageSet(
    guid: json["guid"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "guid": guid,
    "image": image,
  };
}
