import 'dart:math';

import 'cattle_live_models.dart';
import 'cattle_live_repo.dart';

/// Mock repository for Clean Air module.
/// Keeps Clean Air device list separate from Cattle Care.
class MockCleanAirLiveRepository implements CattleLiveRepository {
  final _rand = Random();

  @override
  Future<List<CattleDevice>> getDevices() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [
      CattleDevice(id: 'Barishal-008', name: 'Barishal-008'),
    ];
  }

  @override
  Future<CattleLiveData> getLatestLiveData({required String deviceId}) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final now = DateTime.now();
    return CattleLiveData(
      deviceId: deviceId,
      timestamp: now.toIso8601String(),
      nh3MgL: double.parse((_rand.nextDouble() * 0.10).toStringAsFixed(2)),
      temperatureC:
          double.parse((16 + _rand.nextDouble() * 15).toStringAsFixed(2)),
      humidityPct: 55 + _rand.nextInt(35),
      co2Ppm: 250 + _rand.nextInt(250),
      vocMgM3: double.parse((_rand.nextDouble() * 0.30).toStringAsFixed(2)),
      noiseDb: 45 + _rand.nextInt(45),
      pm25UgM3: 5 + _rand.nextInt(60),
      pm10UgM3: 10 + _rand.nextInt(100),
    );
  }
}
