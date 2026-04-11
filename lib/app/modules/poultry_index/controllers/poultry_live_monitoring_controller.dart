import 'dart:async';
import 'package:get/get.dart';
import '../../../repo/mock_poultry_live_repo.dart';
import '../../../repo/poultry_live_models.dart';
import '../../../repo/poultry_live_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../service/local_storage.dart';

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
    _bootstrap();
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

  Future<void> _bootstrap() async {
    final canProceed = await _ensureLoggedIn();
    if (!canProceed) {
      if (Get.isOverlaysOpen != true) {
        Get.back();
      }
      return;
    }
    await loadDevices();
  }

  Future<bool> _ensureLoggedIn() async {
    final loginTokenStorage = Get.find<LoginTokenStorage>();
    final token = loginTokenStorage.getToken();

    if (loginTokenStorage.hasValidToken()) {
      return true;
    }

    final result = await Get.toNamed(
      Routes.LOGIN,
      arguments: {'fromGuard': true},
    );

    final nextToken = loginTokenStorage.getToken();
    return result == true || _hasValidToken(nextToken);
  }

  bool _hasValidToken(String? token) {
    if (token == null) return false;
    final normalized = token.trim().toLowerCase();
    return normalized.isNotEmpty &&
        normalized != 'null' &&
        normalized != 'undefined';
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
