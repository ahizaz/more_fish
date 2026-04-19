import 'dart:convert';

class NotificationResponse {
  final String? success;
  final int? statusCode;
  final String? message;
  final List<Datum>? data;

  NotificationResponse({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory NotificationResponse.fromRawJson(String str) => NotificationResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationResponse.fromJson(Map<String, dynamic> json) => NotificationResponse(
    success: json["success"],
    statusCode: json["status code"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status code": statusCode,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  final int? id;
  final DateTime? notTime;
  final NotUrgency? notUrgency;
  final NotPond? notPond;
  final String? notMessageBody;
  final NotWarning? notWarning;
  final NotWarningMsg? notWarningMsg;
  final String? notValue;
  final NotColor? notColor;
  final String? notFinal;
  final int? notSensorId;
  final int? devId;
  final int? notUserId;
  final DateTime? notDate;
  final int? confId;

  Datum({
    this.id,
    this.notTime,
    this.notUrgency,
    this.notPond,
    this.notMessageBody,
    this.notWarning,
    this.notWarningMsg,
    this.notValue,
    this.notColor,
    this.notFinal,
    this.notSensorId,
    this.devId,
    this.notUserId,
    this.notDate,
    this.confId,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    notTime: json["not_time"] == null ? null : DateTime.parse(json["not_time"]),
    notUrgency: notUrgencyValues.map[json["not_urgency"]],
    notPond: notPondValues.map[json["not_pond"]],
    notMessageBody: json["not_message_body"],
    notWarning: notWarningValues.map[json["not_warning"]],
    notWarningMsg: notWarningMsgValues.map[json["not_warning_msg"]],
    notValue: json["not_value"],
    notColor: notColorValues.map[json["not_color"]],
    notFinal: json["not_final"],
    notSensorId: json["not_sensor_id"],
    devId: json["dev_id"],
    notUserId: json["not_user_id"],
    notDate: json["not_date"] == null ? null : DateTime.parse(json["not_date"]),
    confId: json["conf_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "not_time": notTime?.toIso8601String(),
    "not_urgency": notUrgencyValues.reverse[notUrgency],
    "not_pond": notPondValues.reverse[notPond],
    "not_message_body": notMessageBody,
    "not_warning": notWarningValues.reverse[notWarning],
    "not_warning_msg": notWarningMsgValues.reverse[notWarningMsg],
    "not_value": notValue,
    "not_color": notColorValues.reverse[notColor],
    "not_final": notFinal,
    "not_sensor_id": notSensorId,
    "dev_id": devId,
    "not_user_id": notUserId,
    "not_date": "${notDate!.year.toString().padLeft(4, '0')}-${notDate!.month.toString().padLeft(2, '0')}-${notDate!.day.toString().padLeft(2, '0')}",
    "conf_id": confId,
  };
}

enum NotColor {
  // ignore: constant_identifier_names
  GREEN,
  // ignore: constant_identifier_names
  ORANGE
}

final notColorValues = EnumValues({
  "green": NotColor.GREEN,
  "orange": NotColor.ORANGE
});

enum NotPond {
  NAOGAON_01
}

final notPondValues = EnumValues({
  "Naogaon-01": NotPond.NAOGAON_01
});

enum NotUrgency {
  EMPTY,
  NOT_URGENCY,
  PURPLE
}

final notUrgencyValues = EnumValues({
  "সতর্ক হোন !!!": NotUrgency.EMPTY,
  "সাধারণ।": NotUrgency.NOT_URGENCY,
  "জরুরি !!!": NotUrgency.PURPLE
});

enum NotWarning {
  // ignore: constant_identifier_names
  EMPTY,
  // ignore: constant_identifier_names
  NOT_WARNING,
  // ignore: constant_identifier_names
  PURPLE
}

final notWarningValues = EnumValues({
  "কম:": NotWarning.EMPTY,
  ":": NotWarning.NOT_WARNING,
  "বেশি:": NotWarning.PURPLE
});

enum NotWarningMsg {
  AMMONIA,
  DO
}

final notWarningMsgValues = EnumValues({
  "Ammonia": NotWarningMsg.AMMONIA,
  "DO": NotWarningMsg.DO
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}


