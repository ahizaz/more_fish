import 'dart:convert';

class PondDataResponse {
  String success;
  int statusCode;
  String message;
  Data data;

  PondDataResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory PondDataResponse.fromRawJson(String str) => PondDataResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PondDataResponse.fromJson(Map<String, dynamic> json) => PondDataResponse(
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status_code": statusCode,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  String assetId;
  Weather weather;
  String assetName;
  List<Device> devices;

  Data({
    required this.assetId,
    required this.weather,
    required this.assetName,
    required this.devices,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    assetId: json["asset_id"],
    weather: Weather.fromJson(json["weather"]),
    assetName: json["asset_name"],
    devices: List<Device>.from(json["devices"].map((x) => Device.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "asset_id": assetId,
    "weather": weather.toJson(),
    "asset_name": assetName,
    "devices": List<dynamic>.from(devices.map((x) => x.toJson())),
  };
}

class Device {
  String deviceId;
  String deviceName;
  String deviceStatus;
  List<Sensor> sensors;
  List<Aerator> aerators;

  Device({
    required this.deviceId,
    required this.deviceName,
    required this.deviceStatus,
    required this.sensors,
    required this.aerators,
  });

  factory Device.fromRawJson(String str) => Device.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Device.fromJson(Map<String, dynamic> json) => Device(
    deviceId: json["device_id"],
    deviceName: json["device_name"],
    deviceStatus: json["device_status"],
    sensors: List<Sensor>.from(json["sensors"].map((x) => Sensor.fromJson(x))),
    aerators: List<Aerator>.from(json["aerators"].map((x) => Aerator.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "device_id": deviceId,
    "device_name": deviceName,
    "device_status": deviceStatus,
    "sensors": List<dynamic>.from(sensors.map((x) => x.toJson())),
    "aerators": List<dynamic>.from(aerators.map((x) => x.toJson())),
  };
}

class Aerator {
  int aeratorPk;
  String aeratorName;
  String aeratorId;
  bool isRunning;

  Aerator({
    required this.aeratorPk,
    required this.aeratorName,
    required this.aeratorId,
    required this.isRunning,
  });

  factory Aerator.fromRawJson(String str) => Aerator.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Aerator.fromJson(Map<String, dynamic> json) => Aerator(
    aeratorPk: json["aerator_pk"],
    aeratorName: json["aerator_name"],
    aeratorId: json["aerator_id"],
    isRunning: json["is_running"],
  );

  Map<String, dynamic> toJson() => {
    "aerator_pk": aeratorPk,
    "aerator_name": aeratorName,
    "aerator_id": aeratorId,
    "is_running": isRunning,
  };
}

class Sensor {
  String sensorId;
  String sensorName;
  String lastValue;
  String sensorUnit;
  String dangerStatus;
  String sensorIcon;
  String dataTime;
  String sensorStatus;

  Sensor({
    required this.sensorId,
    required this.sensorName,
    required this.lastValue,
    required this.sensorUnit,
    required this.dangerStatus,
    required this.sensorIcon,
    required this.dataTime,
    required this.sensorStatus,
  });

  factory Sensor.fromRawJson(String str) => Sensor.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Sensor.fromJson(Map<String, dynamic> json) => Sensor(
    sensorId: json["sensor_id"],
    sensorName: json["sensor_name"],
    lastValue: json["last_value"],
    sensorUnit: json["sensor_unit"],
    dangerStatus: json["danger_status"],
    sensorIcon: json["sensor_icon"],
    dataTime: json["data_time"],
    sensorStatus: json["sensor_status"],
  );

  Map<String, dynamic> toJson() => {
    "sensor_id": sensorId,
    "sensor_name": sensorName,
    "last_value": lastValue,
    "sensor_unit": sensorUnit,
    "danger_status": dangerStatus,
    "sensor_icon": sensorIcon,
    "data_time": dataTime,
    "sensor_status": sensorStatus,
  };
}

class Weather {
  String sunlightLevel;
  String solarRadiation;
  WeatherDistrict weatherDistrict;
  String weatherTemperature;
  String weatherHumidity;
  String weatherDescription;

  Weather({
    required this.sunlightLevel,
    required this.solarRadiation,
    required this.weatherDistrict,
    required this.weatherTemperature,
    required this.weatherHumidity,
    required this.weatherDescription,
  });

  factory Weather.fromRawJson(String str) => Weather.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
    sunlightLevel: json["sunlight_level"],
    solarRadiation: json["solar_radiation"],
    weatherDistrict: WeatherDistrict.fromJson(json["weather_district"]),
    weatherTemperature: json["weather_temperature"],
    weatherHumidity: json["weather_humidity"],
    weatherDescription: json["weather_description"],
  );

  Map<String, dynamic> toJson() => {
    "sunlight_level": sunlightLevel,
    "solar_radiation": solarRadiation,
    "weather_district": weatherDistrict.toJson(),
    "weather_temperature": weatherTemperature,
    "weather_humidity": weatherHumidity,
    "weather_description": weatherDescription,
  };
}

class WeatherDistrict {
  String district;

  WeatherDistrict({
    required this.district,
  });

  factory WeatherDistrict.fromRawJson(String str) => WeatherDistrict.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WeatherDistrict.fromJson(Map<String, dynamic> json) => WeatherDistrict(
    district: json["district"],
  );

  Map<String, dynamic> toJson() => {
    "district": district,
  };
}

