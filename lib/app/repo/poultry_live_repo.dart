import 'poultry_live_models.dart';

abstract class PoultryLiveRepository {
  Future<List<PoultryDevice>> getDevices();
  Future<PoultryLiveData> getLatestLiveData({required String deviceId});
}
