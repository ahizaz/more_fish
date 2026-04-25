import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../repo/devices_repo.dart';
import '../../../response/aerator_command_response.dart';
import '../../../response/company_list_response.dart';
import '../../../response/pond_data_response.dart';
import '../../../response/pond_list_response.dart';
import '../../../response/sensor_list_response.dart';

class WaterQualityDeviceController extends GetxController {
  DevicesRepository devicesRepository = DevicesRepository();
  var pondListResponse = Rxn<PondListResponse>();
  var pondDataResponse = Rxn<PondDataResponse>();
  var sensorListResponse = Rxn<SensorListResponse>();
  var companyListResponse = Rxn<CompanyListResponse>();
  var aeratorCommandResponse = Rxn<AeratorCommandResponse>();
  var aeratorSwitch = [].obs;
  var selectedAstName = ''.obs;
  var selectedAstId = 0.obs;
  var comId = 19.obs;
  Timer? _pollTimer;
  var isFetching = false.obs;
  bool _firstFetch = true;

  @override
  void onInit() {
    super.onInit();
    pondList();
    sensorList();
    CompanyList();
    // start periodic polling every 5 seconds
    _startPolling();
  }

  @override
  void onClose() {
    _pollTimer?.cancel();
    super.onClose();
  }

  void _startPolling() {
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (isFetching.value) {
        debugPrint('[poll] Skipping poll: fetch already in progress');
        return;
      }

      if (selectedAstId.value == 0) {
        debugPrint('[poll] Skipping poll: no selected asset id yet');
        return;
      }

      debugPrint(
        '[poll] Polling pond data for id: ${selectedAstId.value} at ${DateTime.now()}',
      );
      pondData(id: selectedAstId.value);
    });
  }

  pondList() async {
    var response = await devicesRepository.getPondList();
    response.fold(
      (l) {
        print("${l.message}");
      },
      (r) {
        pondListResponse.value = r;
        pondData(id: pondListResponse.value?.data[0].id);

        print("=================================");
        print(pondListResponse.value);
        print("=================================");
      },
    );
  }

  pondData({id}) async {
    // prevent overlapping requests
    if (isFetching.value) {
      debugPrint('[pondData] Request skipped because another fetch is running');
      return;
    }

    isFetching.value = true;

    // show a loading indicator only for the first fetch to avoid heavy UI churn
    if (_firstFetch) {
      try {
        EasyLoading.show(status: 'Loading...');
      } catch (_) {}
    }

    // remember the last requested asset id
    if (id != null) selectedAstId.value = id;

    var response = await devicesRepository.getPondData(id: id);
    response.fold(
      (l) {
        print("${l.message}");
        isFetching.value = false;
        _firstFetch = false;
        try {
          EasyLoading.dismiss();
        } catch (_) {}
      },
      (r) {
        pondDataResponse.value = r;

        // reset aerator switches and populate from fresh response
        aeratorSwitch.clear();
        if (pondDataResponse.value!.data.devices[0].aerators.isNotEmpty) {
          for (
            int i = 0;
            i < pondDataResponse.value!.data.devices[0].aerators.length;
            i++
          ) {
            aeratorSwitch.add(
              pondDataResponse.value!.data.devices[0].aerators[i].isRunning,
            );
          }
        }

        debugPrint('=================================');
        debugPrint(pondDataResponse.value.toString());
        debugPrint('=================================');

        // done
        isFetching.value = false;
        _firstFetch = false;
        try {
          EasyLoading.dismiss();
        } catch (_) {}
      },
    );
  }

  sensorList() async {
    var response = await devicesRepository.getSensorList();
    response.fold(
      (l) {
        print("${l.message}");
      },
      (r) {
        sensorListResponse.value = r;
        debugPrint("=================================");
        debugPrint("sensorListResponse.value");
        debugPrint("=================================");
      },
    );
  }

  CompanyList() async {
    var response = await devicesRepository.getCompanyList();
    response.fold(
      (l) {
        print("${l.message}");
      },
      (r) {
        companyListResponse.value = r;
        print("=================================");
        print(companyListResponse.value);
        print("=================================");
      },
    );
  }

  aeratorCommand({id, command}) async {
    var response = await devicesRepository.setAeratorCommand(
      id: id,
      command: command,
    );
    response.fold(
      (l) {
        print("${l.message}");
      },
      (r) {
        aeratorCommandResponse.value = r;

        print("=================================");
        print(aeratorCommandResponse.value);
        print("=================================");
      },
    );
  }
}
