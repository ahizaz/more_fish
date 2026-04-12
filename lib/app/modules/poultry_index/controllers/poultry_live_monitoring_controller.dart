import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../repo/poultry_api_live_repo.dart';
import '../../../repo/poultry_live_models.dart';
import '../../../repo/poultry_live_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../service/local_storage.dart';

class PoultryLiveMonitoringController extends GetxController
    with WidgetsBindingObserver {
  PoultryLiveMonitoringController({PoultryLiveRepository? repository})
    : _repo = repository ?? PoultryApiLiveRepository();

  final PoultryLiveRepository _repo;

  final devices = <PoultryDevice>[].obs;
  final selectedDeviceId = ''.obs;

  final liveData = Rxn<PoultryLiveData>();
  final isLoading = false.obs;
  final error = ''.obs;

  Timer? _pollTimer;
  bool _isRefreshInProgress = false;
  DateTime? _lastPageVisibleRefreshAt;

  static const Duration _refreshInterval = Duration(seconds: 10);

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _bootstrap();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _pollTimer?.cancel();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (selectedDeviceId.value.isNotEmpty) {
        refreshLiveData();
        _startPolling();
      }
      return;
    }

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.hidden) {
      _pollTimer?.cancel();
    }
  }

  Future<void> loadDevices() async {
    final showOverlay = liveData.value == null;
    if (showOverlay) {
      EasyLoading.show(status: 'Loading live data...');
    }
    debugPrint('Poultry live monitoring: loading devices');

    try {
      isLoading.value = true;
      error.value = '';
      final list = await _repo.getDevices();
      debugPrint('Poultry live monitoring: devices fetched ${list.length}');
      devices.assignAll(list);
      if (list.isNotEmpty) {
        selectedDeviceId.value = list.first.id;
        await refreshLiveData();
        _startPolling();
      }
    } catch (e) {
      debugPrint('Poultry live monitoring loadDevices error: $e');
      error.value = e.toString();
    } finally {
      isLoading.value = false;
      if (showOverlay) {
        EasyLoading.dismiss();
      }
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
        normalized != 'null' && //
        normalized != 'undefined';
  }

  Future<void> onDeviceChanged(String deviceId) async {
    selectedDeviceId.value = deviceId;
    await refreshLiveData();
    _startPolling();
  }

  Future<void> refreshWhenPageVisible() async {
    final now = DateTime.now();
    final last = _lastPageVisibleRefreshAt;
    if (last != null && now.difference(last) < const Duration(seconds: 2)) {
      return;
    }
    _lastPageVisibleRefreshAt = now;

    if (selectedDeviceId.value.isEmpty || devices.isEmpty) {
      await loadDevices();
      return;
    }

    await refreshLiveData();
    _startPolling();
  }

  Future<void> refreshLiveData() async {
    if (_isRefreshInProgress) return;
    final id = selectedDeviceId.value;
    if (id.isEmpty) return;

    _isRefreshInProgress = true;
    debugPrint('Poultry live monitoring: refreshing device $id');
    try {
      isLoading.value = true;
      error.value = '';
      liveData.value = await _repo.getLatestLiveData(deviceId: id);
      debugPrint('Poultry live monitoring: latest data loaded for $id');
    } catch (e) {
      debugPrint('Poultry live monitoring refresh error: $e');
      error.value = e.toString();
    } finally {
      isLoading.value = false;
      _isRefreshInProgress = false;
    }
  }

  void _startPolling() {
    _pollTimer?.cancel();
    // Easy to swap later with WebSocket/SSE stream.
    _pollTimer = Timer.periodic(_refreshInterval, (_) {
      refreshLiveData();
    });
  }
}
