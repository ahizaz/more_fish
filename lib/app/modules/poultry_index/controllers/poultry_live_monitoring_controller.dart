import 'dart:async';
import 'package:get/get.dart';
import '../../../repo/mock_poultry_live_repo.dart';
import '../../../repo/poultry_live_models.dart';
import '../../../repo/poultry_live_repo.dart';

class PoultryLiveMonitoringController extends GetxController {
  PoultryLiveMonitoringController({PoultryLiveRepository? repository})
      : _repo = repository ?? MockPoultryLiveRepository();

  final PoultryLiveRepository _repo;

  final devices = <PoultryDevice>[].obs;
  final selectedDeviceId = ''.obs;

  final liveData = Rxn<PoultryLiveData>();
  final isLoading = false.obs;
  final error = ''.obs;

  Timer? _pollTimer;

  @override
  void onInit() {
    super.onInit();
    loadDevices();
  }

  @override
  void onClose() {
    _pollTimer?.cancel();
    super.onClose();
  }

  Future<void> loadDevices() async {
    try {
      isLoading.value = true;
      error.value = '';
      final list = await _repo.getDevices();
      devices.assignAll(list);
      if (list.isNotEmpty) {
        selectedDeviceId.value = list.first.id;
        await refreshLiveData();
        _startPolling();
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onDeviceChanged(String deviceId) async {
    selectedDeviceId.value = deviceId;
    await refreshLiveData();
    _startPolling();
  }

  Future<void> refreshLiveData() async {
    final id = selectedDeviceId.value;
    if (id.isEmpty) return;
    try {
      isLoading.value = true;
      error.value = '';
      liveData.value = await _repo.getLatestLiveData(deviceId: id);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void _startPolling() {
    _pollTimer?.cancel();
    // Easy to swap later with WebSocket/SSE stream.
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      refreshLiveData();
    });
  }
}
