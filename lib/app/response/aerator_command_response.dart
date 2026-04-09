import 'dart:convert';

class AeratorCommandResponse {
  String success;
  int statusCode;
  String aeratorId;
  int command;
  int commandLogId;
  String msg;

  AeratorCommandResponse({
    required this.success,
    required this.statusCode,
    required this.aeratorId,
    required this.command,
    required this.commandLogId,
    required this.msg,
  });

  factory AeratorCommandResponse.fromRawJson(String str) => AeratorCommandResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AeratorCommandResponse.fromJson(Map<String, dynamic> json) => AeratorCommandResponse(
    success: json["success"],
    statusCode: json["status_code"],
    aeratorId: json["aerator_id"],
    command: json["command"],
    commandLogId: json["command_log_id"],
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status_code": statusCode,
    "aerator_id": aeratorId,
    "command": command,
    "command_log_id": commandLogId,
    "msg": msg,
  };
}
