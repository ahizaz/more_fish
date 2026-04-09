import 'dart:convert';

class SensorListResponse {
  String success;
  int statusCode;
  String message;
  List<Datum> data;

  SensorListResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory SensorListResponse.fromRawJson(String str) => SensorListResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SensorListResponse.fromJson(Map<String, dynamic> json) => SensorListResponse(
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
  int sensorId;
  String sensorSensorName;

  Datum({
    required this.sensorId,
    required this.sensorSensorName,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    sensorId: json["sensor__id"],
    sensorSensorName: json["sensor__sensor_name"],
  );

  Map<String, dynamic> toJson() => {
    "sensor__id": sensorId,
    "sensor__sensor_name": sensorSensorName,
  };
}
