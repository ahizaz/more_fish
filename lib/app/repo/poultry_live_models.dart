class PoultryLiveData {
  final String deviceId;
  final String deviceStatus;
  final String timestamp; // ISO or formatted
  final double? aqi;
  final double nh3MgL;
  final double temperatureC;
  final double? refTemperatureC;
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
  final List<PoultrySensorMetric> metrics;
  final List<PoultrySwitch> switches;

  const PoultryLiveData({
    required this.deviceId,
    required this.deviceStatus,
    required this.timestamp,
    this.aqi,
    required this.nh3MgL,
    required this.temperatureC,
    this.refTemperatureC,
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
    this.metrics = const <PoultrySensorMetric>[],
    this.switches = const <PoultrySwitch>[],
  });

  factory PoultryLiveData.fromJson(Map<String, dynamic> json) {
    int _intVal(dynamic v) {
      if (v is num) return v.toInt();
      return int.tryParse('$v') ?? 0;
    }

    return PoultryLiveData(
      deviceId: (json['deviceId'] ?? '').toString(),
      deviceStatus: (json['device_status'] ?? '').toString(),
      timestamp: (json['timestamp'] ?? '').toString(),
      aqi: (json['aqi'] is num)
          ? (json['aqi'] as num).toDouble()
          : double.tryParse('${json['aqi']}') ?? 0.0,
      nh3MgL: (json['nh3'] is num)
          ? (json['nh3'] as num).toDouble()
          : double.tryParse('${json['nh3']}') ?? 0,
      temperatureC: (json['temperature'] is num)
          ? (json['temperature'] as num).toDouble()
          : double.tryParse('${json['temperature']}') ?? 0,
      refTemperatureC: (json['ref_temperature'] is num)
          ? (json['ref_temperature'] as num).toDouble()
          : double.tryParse('${json['ref_temperature']}') ?? 0.0,
      humidityPct: _intVal(json['humidity']),
      vocMgM3: (json['voc'] is num)
          ? (json['voc'] as num).toDouble()
          : double.tryParse('${json['voc']}') ?? 0.0,
      co2Ppm: _intVal(json['co2']),
      // Backend might send methane as `ch4` or `methane`.
      ch4Ppm: _intVal(json['ch4'] ?? json['methane']),
      pm1UgM3: _intVal(json['pm1']),
      pm25UgM3: _intVal(json['pm25']),
      pm4UgM3: _intVal(json['pm4']),
      pm10UgM3: _intVal(json['pm10']),
      noiseDb: _intVal(json['noise']),
      lightLux: _intVal(json['lightLux']),
      metrics: ((json['metrics'] as List?) ?? const <dynamic>[])
          .whereType<Map>()
          .map(
            (e) => PoultrySensorMetric.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList(),
      switches: ((json['switches'] as List?) ?? const <dynamic>[])
          .whereType<Map>()
          .map((e) => PoultrySwitch.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'deviceId': deviceId,
    'device_status': deviceStatus,
    'timestamp': timestamp,
    'aqi': aqi,
    'nh3': nh3MgL,
    'temperature': temperatureC,
    'ref_temperature': refTemperatureC,
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
    'metrics': metrics.map((e) => e.toJson()).toList(),
    'switches': switches.map((e) => e.toJson()).toList(),
  };
}

class PoultrySensorMetric {
  final String name;
  final String title;
  final String unit;
  final double value;
  final String dangerStatus;
  final String dataTime;

  const PoultrySensorMetric({
    required this.name,
    required this.title,
    required this.unit,
    required this.value,
    required this.dangerStatus,
    required this.dataTime,
  });

  factory PoultrySensorMetric.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic v) {
      if (v is num) return v.toDouble();
      return double.tryParse('$v') ?? 0.0;
    }

    return PoultrySensorMetric(
      name: (json['name'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      unit: (json['unit'] ?? '').toString(),
      value: toDouble(json['value']),
      dangerStatus: (json['danger_status'] ?? '').toString(),
      dataTime: (json['data_time'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'title': title,
    'unit': unit,
    'value': value,
    'danger_status': dangerStatus,
    'data_time': dataTime,
  };
}

class PoultrySwitch {
  final int? id;
  final String switchId;
  final String switchName;
  final bool isOn;
  final bool isActive;
  final String updatedAt;

  const PoultrySwitch({
    this.id,
    required this.switchId,
    required this.switchName,
    required this.isOn,
    required this.isActive,
    required this.updatedAt,
  });

  factory PoultrySwitch.fromJson(Map<String, dynamic> json) {
    bool toBool(dynamic value) {
      if (value is bool) return value;
      if (value is num) return value != 0;
      final v = value.toString().trim().toLowerCase();
      return v == 'true' || v == '1' || v == 'on';
    }

    return PoultrySwitch(
      id: json['id'] is num ? (json['id'] as num).toInt() : null,
      switchId: (json['switch_id'] ?? '').toString(),
      switchName: (json['switch_name'] ?? '').toString(),
      isOn: toBool(json['is_on']),
      isActive: toBool(json['is_active']),
      updatedAt: (json['updated_at'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'switch_id': switchId,
    'switch_name': switchName,
    'is_on': isOn,
    'is_active': isActive,
    'updated_at': updatedAt,
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
