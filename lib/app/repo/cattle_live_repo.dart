import 'cattle_live_models.dart';

abstract class CattleLiveRepository {
  Future<List<CattleDevice>> getDevices();
  Future<CattleLiveData> getLatestLiveData({required String deviceId});
}
