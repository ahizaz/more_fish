// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import '../../../repo/devices_repo.dart';
// import '../../../response/aerator_command_response.dart';
// import '../../../response/company_list_response.dart';
// import '../../../response/pond_data_response.dart';
// import '../../../response/pond_list_response.dart';
// import '../../../response/sensor_list_response.dart';

// class WaterQualityDeviceController extends GetxController {
//   DevicesRepository devicesRepository = DevicesRepository();
//   var pondListResponse = Rxn<PondListResponse>();
//   var pondDataResponse = Rxn<PondDataResponse>();
//   var sensorListResponse = Rxn<SensorListResponse>();
//   var companyListResponse = Rxn<CompanyListResponse>();
//   var aeratorCommandResponse = Rxn<AeratorCommandResponse>();
//   var aeratorSwitch = [].obs;
//   var selectedAstName = ''.obs;
//   var selectedAstId = 0.obs;
//   var comId = 19.obs;
//   Timer? _pollTimer;
//   var isFetching = false.obs;
//   var commandInProgress = false.obs;
//   bool _firstFetch = true;

//   @override
//   void onInit() {
//     super.onInit();
//     pondList();
//     CompanyList();
//     // start periodic polling every 5 seconds
//     _startPolling();
//   }

//   @override
//   void onClose() {
//     _pollTimer?.cancel();
//     super.onClose();
//   }

//   void _startPolling() {
//     _pollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
//       if (isFetching.value) {
//         debugPrint('[poll] Skipping poll: fetch already in progress');
//         return;
//       }

//       if (selectedAstId.value == 0) {
//         debugPrint('[poll] Skipping poll: no selected asset id yet');
//         return;
//       }

//       debugPrint(
//         '[poll] Polling pond data for id: ${selectedAstId.value} at ${DateTime.now()}',
//       );
//       pondData(id: selectedAstId.value);
//     });
//   }

//   pondList() async {
//     var response = await devicesRepository.getPondList();
//     response.fold(
//       (l) {
//         print("${l.message}");
//       },
//       (r) {
//         pondListResponse.value = r;
//         pondData(id: pondListResponse.value?.data[0].id);

//         print("=================================");
//         print(pondListResponse.value);
//         print("=================================");
//       },
//     );
//   }

//   pondData({id}) async {
//     // prevent overlapping requests
//     if (isFetching.value) {
//       debugPrint('[pondData] Request skipped because another fetch is running');
//       return;
//     }

//     isFetching.value = true;

//     // show a loading indicator only for the first fetch to avoid heavy UI churn
//     if (_firstFetch) {
//       try {
//         EasyLoading.show(status: 'Loading...');
//       } catch (_) {}
//     }

//     // remember the last requested asset id
//     if (id != null) selectedAstId.value = id;

//     var response = await devicesRepository.getPondData(id: id);
//     response.fold(
//       (l) {
//         print("${l.message}");
//         isFetching.value = false;
//         _firstFetch = false;
//         try {
//           EasyLoading.dismiss();
//         } catch (_) {}
//       },
//       (r) {
//         pondDataResponse.value = r;

//         // reset aerator switches and populate from fresh response
//         aeratorSwitch.clear();
//         if (pondDataResponse.value!.data.devices[0].aerators.isNotEmpty) {
//           for (
//             int i = 0;
//             i < pondDataResponse.value!.data.devices[0].aerators.length;
//             i++
//           ) {
//             aeratorSwitch.add(
//               pondDataResponse.value!.data.devices[0].aerators[i].isRunning,
//             );
//           }
//         }

//         debugPrint('=================================');
//         debugPrint(pondDataResponse.value.toString());
//         debugPrint('=================================');

//         // After receiving pond data, extract device_id and fetch sensors for that device
//         try {
//           final deviceId = pondDataResponse.value?.data.devices[0].deviceId;
//           if (deviceId != null && deviceId.toString().isNotEmpty) {
//             sensorList(deviceId: deviceId);
//           }
//         } catch (e) {
//           debugPrint('Failed to extract device id for sensor list: $e');
//         }

//         // done
//         isFetching.value = false;
//         _firstFetch = false;
//         try {
//           EasyLoading.dismiss();
//         } catch (_) {}
//       },
//     );
//   }

//   sensorList({dynamic deviceId}) async {
//     // deviceId is required to fetch sensor list for a specific device
//     if (deviceId == null) {
//       debugPrint('sensorList called without deviceId - skipping');
//       return;
//     }

//     var response = await devicesRepository.getSensorList(deviceId: deviceId);
//     response.fold(
//       (l) {
//         print("${l.message}");
//       },
//       (r) {
//         sensorListResponse.value = r;
//         debugPrint("=================================");
//         debugPrint("sensorListResponse.value");
//         debugPrint("=================================");
//       },
//     );
//   }

//   CompanyList() async {
//     var response = await devicesRepository.getCompanyList();
//     response.fold(
//       (l) {
//         print("${l.message}");
//       },
//       (r) {
//         companyListResponse.value = r;
//         print("=================================");
//         print(companyListResponse.value);
//         print("=================================");
//       },
//     );
//   }

//   aeratorCommand({id, command, int? index}) async {
//     if (commandInProgress.value) return;

//     commandInProgress.value = true;
//     try {
//       EasyLoading.show(status: 'Sending...');
//     } catch (_) {}

//     var response = await devicesRepository.setAeratorCommand(
//       id: id,
//       command: command,
//     );

//     response.fold(
//       (l) {
//         // show error and revert switch state if index provided
//         try {
//           EasyLoading.showError(l.message);
//         } catch (_) {}

//         if (index != null && index >= 0 && index < aeratorSwitch.length) {
//           aeratorSwitch[index] = !aeratorSwitch[index];
//         }
//         commandInProgress.value = false;
//       },
//       (r) {
//         aeratorCommandResponse.value = r;

//         try {
//           EasyLoading.showSuccess(r.msg);
//         } catch (_) {}

//         // refresh pond data to reflect latest state
//         pondData(id: selectedAstId.value);
//         commandInProgress.value = false;
//       },
//     );
//   }
// }
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import '../../../repo/devices_repo.dart';
// import '../../../response/aerator_command_response.dart';
// import '../../../response/company_list_response.dart';
// import '../../../response/pond_data_response.dart';
// import '../../../response/pond_list_response.dart';
// import '../../../response/sensor_list_response.dart';

// class WaterQualityDeviceController extends GetxController {
//   DevicesRepository devicesRepository = DevicesRepository();

//   var pondListResponse = Rxn<PondListResponse>();
//   var pondDataResponse = Rxn<PondDataResponse>();
//   var sensorListResponse = Rxn<SensorListResponse>();
//   var companyListResponse = Rxn<CompanyListResponse>();
//   var aeratorCommandResponse = Rxn<AeratorCommandResponse>();

//   var aeratorSwitch = [].obs;
//   var selectedAstName = ''.obs;
//   var selectedAstId = 0.obs;
//   var comId = 19.obs;

//   Timer? _pollTimer;
//   var isFetching = false.obs;
//   var commandInProgress = false.obs;
//   bool _firstFetch = true;

//   @override
//   void onInit() {
//     super.onInit();
//     pondList();
//     CompanyList();
//     _startPolling();
//   }

//   @override
//   void onClose() {
//     _pollTimer?.cancel();
//     super.onClose();
//   }

//   void _startPolling() {
//     _pollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
//       if (isFetching.value) return;
//       if (selectedAstId.value == 0) return;

//       debugPrint('[poll] Polling pond data for id: ${selectedAstId.value}');
//       pondData(id: selectedAstId.value);
//     });
//   }

//   pondList() async {
//     var response = await devicesRepository.getPondList();
//     response.fold(
//       (l) => print("${l.message}"),
//       (r) {
//         pondListResponse.value = r;
//         if (r.data.isNotEmpty) {
//           pondData(id: r.data[0].id);
//         }
//       },
//     );
//   }

//   pondData({id}) async {
//     if (isFetching.value) return;
//     isFetching.value = true;

//     if (_firstFetch) {
//       try {
//         EasyLoading.show(status: 'Loading...');
//       } catch (_) {}
//     }

//     if (id != null) selectedAstId.value = id;

//     var response = await devicesRepository.getPondData(id: id);
//     response.fold(
//       (l) {
//         print("${l.message}");
//         isFetching.value = false;
//         _firstFetch = false;
//         try { EasyLoading.dismiss(); } catch (_) {}
//       },
//       (r) {
//         pondDataResponse.value = r;

//         // Reset and populate aerator switches from fresh data
//         aeratorSwitch.clear();
//         final aerators = r.data.devices[0].aerators;
//         for (int i = 0; i < aerators.length; i++) {
//           aeratorSwitch.add(aerators[i].isRunning);
//         }

//         // Fetch sensor list
//         try {
//           final deviceId = r.data.devices[0].deviceId;
//           if (deviceId != null && deviceId.toString().isNotEmpty) {
//             sensorList(deviceId: deviceId);
//           }
//         } catch (e) {
//           debugPrint('Failed to extract device id: $e');
//         }

//         isFetching.value = false;
//         _firstFetch = false;
//         try { EasyLoading.dismiss(); } catch (_) {}
//       },
//     );
//   }

//   sensorList({dynamic deviceId}) async {
//     if (deviceId == null) return;
//     var response = await devicesRepository.getSensorList(deviceId: deviceId);
//     response.fold(
//       (l) => print("${l.message}"),
//       (r) => sensorListResponse.value = r,
//     );
//   }

//   CompanyList() async {
//     var response = await devicesRepository.getCompanyList();
//     response.fold(
//       (l) => print("${l.message}"),
//       (r) => companyListResponse.value = r,
//     );
//   }

//   aeratorCommand({id, command, int? index}) async {
//     if (commandInProgress.value) return;

//     commandInProgress.value = true;
//     try {
//       EasyLoading.show(status: 'Sending...');
//     } catch (_) {}

//     var response = await devicesRepository.setAeratorCommand(id: id, command: command);

//     response.fold(
//       (l) {
//         try {
//           EasyLoading.showError(l.message ?? 'Command failed');
//         } catch (_) {}

//         // Revert switch on error
//         if (index != null && index >= 0 && index < aeratorSwitch.length) {
//           aeratorSwitch[index] = !aeratorSwitch[index];
//         }
//         commandInProgress.value = false;
//       },
//       (r) {
//         aeratorCommandResponse.value = r;
//         try {
//           EasyLoading.showSuccess(r.msg ?? 'Success');
//         } catch (_) {}

//         // Refresh data to get latest state
//         pondData(id: selectedAstId.value);
//         commandInProgress.value = false;
//       },
//     );
//   }
// }
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
  var commandInProgress = false.obs;
  bool _firstFetch = true;

  @override
  void onInit() {
    super.onInit();
    pondList();
    CompanyList();
    _startPolling();
  }

  @override
  void onClose() {
    _pollTimer?.cancel();
    super.onClose();
  }

  void _startPolling() {
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (isFetching.value) return;
      if (selectedAstId.value == 0) return;

      debugPrint('[poll] Polling pond data for id: ${selectedAstId.value}');
      pondData(id: selectedAstId.value);
    });
  }

  pondList() async {
    var response = await devicesRepository.getPondList();
    response.fold((l) => print("${l.message}"), (r) {
      pondListResponse.value = r;
      if (r.data.isNotEmpty) {
        pondData(id: r.data[0].id);
      }
    });
  }

  pondData({id}) async {
    if (isFetching.value) return;
    isFetching.value = true;

    if (_firstFetch) {
      try {
        EasyLoading.show(status: 'Loading...');
      } catch (_) {}
    }

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

        // Reset and populate aerator switches from fresh API data
        aeratorSwitch.clear();
        final aerators = r.data.devices[0].aerators;
        for (int i = 0; i < aerators.length; i++) {
          aeratorSwitch.add(aerators[i].isRunning);
        }

        // Fetch sensor list for graph
        try {
          final deviceId = r.data.devices[0].deviceId;
          if (deviceId != null && deviceId.toString().isNotEmpty) {
            sensorList(deviceId: deviceId);
          }
        } catch (e) {
          debugPrint('Failed to extract device id: $e');
        }

        isFetching.value = false;
        _firstFetch = false;
        try {
          EasyLoading.dismiss();
        } catch (_) {}
      },
    );
  }

  sensorList({dynamic deviceId}) async {
    if (deviceId == null) return;
    var response = await devicesRepository.getSensorList(deviceId: deviceId);
    response.fold(
      (l) => print("${l.message}"),
      (r) => sensorListResponse.value = r,
    );
  }

  CompanyList() async {
    var response = await devicesRepository.getCompanyList();
    response.fold(
      (l) => print("${l.message}"),
      (r) => companyListResponse.value = r,
    );
  }

  // ==================== UPDATED AERATOR COMMAND ====================
  aeratorCommand({id, command, int? index}) async {
    if (commandInProgress.value) return;

    commandInProgress.value = true;

    try {
      EasyLoading.show(status: 'Sending command...');
    } catch (_) {}

    var response = await devicesRepository.setAeratorCommand(
      id: id,
      command: command,
    );

    response.fold(
      (l) {
        // Error case (e.g. "it is not connected", device offline, etc.)
        String errorMsg =
            l.message ?? 'Command failed. Aerator may not be connected.';

        try {
          EasyLoading.showError(errorMsg);
        } catch (_) {}

        // No optimistic update, so no need to revert switch
        commandInProgress.value = false;
      },
      (r) {
        // Success case
        aeratorCommandResponse.value = r;

        try {
          EasyLoading.showSuccess(r.msg ?? 'Command sent successfully');
        } catch (_) {}

        // Refresh pond data to get latest is_running state from server
        pondData(id: selectedAstId.value);
        commandInProgress.value = false;
      },
    );
  }
}
