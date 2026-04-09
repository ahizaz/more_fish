import 'dart:convert';

class GraphResponse {
  String? success;
  int? statusCode;
  String? message;
  List<Datum>? data;

  GraphResponse({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory GraphResponse.fromRawJson(String str) => GraphResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GraphResponse.fromJson(Map<String, dynamic> json) => GraphResponse(
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status_code": statusCode,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? assetId;
  String? assetName;
  List<String>? sensorVal;
  String? sensorName;
  List<String>? time;
  String? dateTime;

  Datum({
    this.assetId,
    this.assetName,
    this.sensorVal,
    this.sensorName,
    this.time,
    this.dateTime,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    assetId: json["asset_id"],
    assetName: json["asset_name"],
    sensorVal: json["sensor_val"] == null ? [] : List<String>.from(json["sensor_val"]!.map((x) => x)),
    sensorName: json["sensor_name"],
    time: json["time"] == null ? [] : List<String>.from(json["time"]!.map((x) => x)),
    dateTime: json["date_time"],
  );

  Map<String, dynamic> toJson() => {
    "asset_id": assetId,
    "asset_name": assetName,
    "sensor_val": sensorVal == null ? [] : List<dynamic>.from(sensorVal!.map((x) => x)),
    "sensor_name": sensorName,
    "time": time == null ? [] : List<dynamic>.from(time!.map((x) => x)),
    "date_time": dateTime,
  };
}
