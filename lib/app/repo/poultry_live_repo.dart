import 'poultry_live_models.dart';

abstract class PoultryLiveRepository {
  Future<List<PoultryDevice>> getDevices();
  Future<PoultryLiveData> getLatestLiveData({required String deviceId});
  Future<void> setSwitchState({required String switchId, required bool turnOn});
}
