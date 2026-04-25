import 'dart:convert';

class GraphResponse {
  String? success;
  int? statusCode;
  String? message;
  List<Datum>? data;

  GraphResponse({this.success, this.statusCode, this.message, this.data});

  factory GraphResponse.fromRawJson(String str) =>
      // Some endpoints may return a top-level List instead of the expected
      // Map. Handle both cases: if decoded is a Map, use it directly;
      // if it's a List, treat it as the `data` array.
      (() {
        final decoded = json.decode(str);
        if (decoded is Map<String, dynamic>) {
          return GraphResponse.fromJson(decoded);
        }

        if (decoded is List) {
          // If the list contains maps, parse them as data items.
          if (decoded.isNotEmpty && decoded.first is Map) {
            return GraphResponse(
              success: 'True',
              statusCode: 200,
              message: '',
              data: List<Datum>.from(
                decoded.map(
                  (x) => Datum.fromJson(Map<String, dynamic>.from(x)),
                ),
              ),
            );
          }

          // If the API returned a list of strings (usually error messages),
          // capture them in `message` and return an empty data array.
          if (decoded.isNotEmpty && decoded.first is String) {
            return GraphResponse(
              success: 'False',
              statusCode: 500,
              message: decoded.map((e) => e.toString()).join('; '),
              data: [],
            );
          }

          // Unknown list contents: return empty data.
          return GraphResponse(
            success: 'False',
            statusCode: 500,
            message: '',
            data: [],
          );
        }

        // Fallback: try parsing as map (may throw if not compatible)
        return GraphResponse.fromJson(Map<String, dynamic>.from(decoded));
      })();

  String toRawJson() => json.encode(toJson());

  factory GraphResponse.fromJson(Map<String, dynamic> json) => GraphResponse(
    success: json["success"]?.toString(),
    statusCode: json["status_code"],
    message: json["message"],
    data: json["data"] == null
        ? []
        : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status_code": statusCode,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
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
    sensorVal: json["sensor_val"] == null
        ? []
        : List<String>.from(json["sensor_val"]!.map((x) => x.toString())),
    sensorName: json["sensor_name"],
    time: json["time"] == null
        ? []
        : List<String>.from(json["time"]!.map((x) => x.toString())),
    dateTime: json["date_time"],
  );

  Map<String, dynamic> toJson() => {
    "asset_id": assetId,
    "asset_name": assetName,
    "sensor_val": sensorVal == null
        ? []
        : List<dynamic>.from(sensorVal!.map((x) => x)),
    "sensor_name": sensorName,
    "time": time == null ? [] : List<dynamic>.from(time!.map((x) => x)),
    "date_time": dateTime,
  };
}
