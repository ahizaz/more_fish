class PoultryLiveData {
  final String deviceId;
  final String timestamp; // ISO or formatted
  final double nh3MgL;
  final double temperatureC;
  final int humidityPct;
  final double vocMgM3;
  final int co2Ppm;
  /// Methane concentration in ppm (CH4).
  final int ch4Ppm;
  /// Dust particle concentration PM1.0 (µg/m³).
  final int pm1UgM3;
  final int pm25UgM3;
  /// Dust particle concentration PM4.0 (µg/m³).
  final int pm4UgM3;
  final int pm10UgM3;
  final int noiseDb;
  final int lightLux;

  const PoultryLiveData({
    required this.deviceId,
    required this.timestamp,
    required this.nh3MgL,
    required this.temperatureC,
    required this.humidityPct,
    required this.vocMgM3,
    required this.co2Ppm,
    required this.ch4Ppm,
    required this.pm1UgM3,
    required this.pm25UgM3,
    required this.pm4UgM3,
    required this.pm10UgM3,
    required this.noiseDb,
    required this.lightLux,
  });

  factory PoultryLiveData.fromJson(Map<String, dynamic> json) {
    int _intVal(dynamic v) {
      if (v is num) return v.toInt();
      return int.tryParse('$v') ?? 0;
    }

    return PoultryLiveData(
      deviceId: (json['deviceId'] ?? '').toString(),
      timestamp: (json['timestamp'] ?? '').toString(),
      nh3MgL: (json['nh3'] is num) ? (json['nh3'] as num).toDouble() : double.tryParse('${json['nh3']}') ?? 0,
      temperatureC: (json['temperature'] is num) ? (json['temperature'] as num).toDouble() : double.tryParse('${json['temperature']}') ?? 0,
      humidityPct: _intVal(json['humidity']),
      vocMgM3: (json['voc'] is num) ? (json['voc'] as num).toDouble() : double.tryParse('${json['voc']}') ?? 0.0,
      co2Ppm: _intVal(json['co2']),
      // Backend might send methane as `ch4` or `methane`.
      ch4Ppm: _intVal(json['ch4'] ?? json['methane']),
      pm1UgM3: _intVal(json['pm1']),
      pm25UgM3: _intVal(json['pm25']),
      pm4UgM3: _intVal(json['pm4']),
      pm10UgM3: _intVal(json['pm10']),
      noiseDb: _intVal(json['noise']),
      lightLux: _intVal(json['lightLux']),
    );
  }

  Map<String, dynamic> toJson() => {
        'deviceId': deviceId,
        'timestamp': timestamp,
        'nh3': nh3MgL,
        'temperature': temperatureC,
        'humidity': humidityPct,
        'voc': vocMgM3,
        'co2': co2Ppm,
        'ch4': ch4Ppm,
        'pm1': pm1UgM3,
        'pm25': pm25UgM3,
        'pm4': pm4UgM3,
        'pm10': pm10UgM3,
        'noise': noiseDb,
        'lightLux': lightLux,
      };
}

class PoultryDevice {
  final String id;
  final String name;

  const PoultryDevice({required this.id, required this.name});

  factory PoultryDevice.fromJson(Map<String, dynamic> json) {
    return PoultryDevice(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
    );
  }
}
