import 'dart:math';
import 'poultry_live_models.dart';
import 'poultry_live_repo.dart';

/// Mock repository to develop UI before IoT device/backend is ready.
/// Replace with an API/WebSocket implementation later.
class MockPoultryLiveRepository implements PoultryLiveRepository {
  final _rand = Random();

  @override
  Future<List<PoultryDevice>> getDevices() async {
    // Simulate a short delay
    await Future.delayed(const Duration(milliseconds: 200));
    return const [PoultryDevice(id: 'Jessore-DMA03', name: 'Jessore-DMA03')];
  }

  @override
  Future<PoultryLiveData> getLatestLiveData({required String deviceId}) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final now = DateTime.now();
    return PoultryLiveData(
      deviceId: deviceId,
      timestamp: now.toIso8601String(),
      aqi: double.parse((1 + _rand.nextDouble() * 3).toStringAsFixed(1)),
      nh3MgL: double.parse((_rand.nextDouble() * 0.05).toStringAsFixed(2)),
      temperatureC: double.parse(
        (20 + _rand.nextDouble() * 10).toStringAsFixed(2),
      ),
      refTemperatureC: double.parse(
        (21 + _rand.nextDouble() * 10).toStringAsFixed(2),
      ),
      humidityPct: 60 + _rand.nextInt(30),
      vocMgM3: double.parse((_rand.nextDouble() * 0.30).toStringAsFixed(2)),
      co2Ppm: 250 + _rand.nextInt(200),
      // Methane (CH4) is commonly tracked in ppm.
      ch4Ppm: 350 + _rand.nextInt(200),
      // Dust particles (µg/m³)
      pm1UgM3: 5 + _rand.nextInt(35),
      pm25UgM3: 5 + _rand.nextInt(50),
      pm4UgM3: 8 + _rand.nextInt(60),
      pm10UgM3: 10 + _rand.nextInt(90),
      noiseDb: 50 + _rand.nextInt(40),
      lightLux: 15 + _rand.nextInt(35),
    );
  }
}
