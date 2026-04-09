import 'dart:convert';

class ProductDetailsResponse {
  Data data;
  int statusCode;
  String success;

  ProductDetailsResponse({
    required this.data,
    required this.statusCode,
    required this.success,
  });

  factory ProductDetailsResponse.fromRawJson(String str) => ProductDetailsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductDetailsResponse.fromJson(Map<String, dynamic> json) => ProductDetailsResponse(
    data: Data.fromJson(json["data"]),
    statusCode: json["status_code"],
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "status_code": statusCode,
    "success": success,
  };
}

class Data {
  String guid;
  String name;
  String description;
  String price;
  List<ProductimageSet> productimageSet;
  List<ProductspecificationsSet> productspecificationsSet;
  Category category;

  Data({
    required this.guid,
    required this.name,
    required this.description,
    required this.price,
    required this.productimageSet,
    required this.productspecificationsSet,
    required this.category,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    guid: json["guid"],
    name: json["name"],
    description: json["description"],
    price: json["price"],
    productimageSet: List<ProductimageSet>.from(json["productimage_set"].map((x) => ProductimageSet.fromJson(x))),
    productspecificationsSet: List<ProductspecificationsSet>.from(json["productspecifications_set"].map((x) => ProductspecificationsSet.fromJson(x))),
    category: Category.fromJson(json["category"]),
  );

  Map<String, dynamic> toJson() => {
    "guid": guid,
    "name": name,
    "description": description,
    "price": price,
    "productimage_set": List<dynamic>.from(productimageSet.map((x) => x.toJson())),
    "productspecifications_set": List<dynamic>.from(productspecificationsSet.map((x) => x.toJson())),
    "category": category.toJson(),
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

class ProductspecificationsSet {
  String guid;
  String specification;

  ProductspecificationsSet({
    required this.guid,
    required this.specification,
  });

  factory ProductspecificationsSet.fromRawJson(String str) => ProductspecificationsSet.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductspecificationsSet.fromJson(Map<String, dynamic> json) => ProductspecificationsSet(
    guid: json["guid"],
    specification: json["specification"],
  );

  Map<String, dynamic> toJson() => {
    "guid": guid,
    "specification": specification,
  };
}
