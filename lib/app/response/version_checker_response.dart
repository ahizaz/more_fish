import 'dart:convert';

class VersionCheckerResponse {
  int? count;
  dynamic next;
  dynamic previous;
  List<Result>? results;

  VersionCheckerResponse({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory VersionCheckerResponse.fromRawJson(String str) => VersionCheckerResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VersionCheckerResponse.fromJson(Map<String, dynamic> json) => VersionCheckerResponse(
    count: json["count"],
    next: json["next"],
    previous: json["previous"],
    results: json["results"] == null ? [] : List<Result>.from(json["results"]!.map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "next": next,
    "previous": previous,
    "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
  };
}

class Result {
  String? versionNumber;
  DateTime? releaseDate;

  Result({
    this.versionNumber,
    this.releaseDate,
  });

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    versionNumber: json["version_number"],
    releaseDate: json["release_date"] == null ? null : DateTime.parse(json["release_date"]),
  );

  Map<String, dynamic> toJson() => {
    "version_number": versionNumber,
    "release_date": "${releaseDate!.year.toString().padLeft(4, '0')}-${releaseDate!.month.toString().padLeft(2, '0')}-${releaseDate!.day.toString().padLeft(2, '0')}",
  };
}
