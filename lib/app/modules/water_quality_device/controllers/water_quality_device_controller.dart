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


  @override
  void onInit() {
    super.onInit();
    pondList();
    sensorList();
    CompanyList();
  }


  pondList() async {
    var response = await devicesRepository.getPondList();
    response.fold(
            (l){
          print("${l.message}");
        },
            (r){
          pondListResponse.value = r;
          pondData(id: pondListResponse.value?.data[0].id);

          print("=================================");
          print(pondListResponse.value);
          print("=================================");

        }
    );
  }

  pondData({id}) async {
    var response = await devicesRepository.getPondData(id: id);
    response.fold(
            (l){
          print("${l.message}");
        },
            (r){
          pondDataResponse.value = r;
          if(pondDataResponse.value!.data.devices[0].aerators.isNotEmpty){
            for(int i = 0; i< pondDataResponse.value!.data.devices[0].aerators.length; i++)
            aeratorSwitch.add(pondDataResponse.value!.data.devices[0].aerators[i].isRunning);
          }
          print("=================================");
          print(pondDataResponse.value);
          print("=================================");

        }
    );
  }

  sensorList() async {
    var response = await devicesRepository.getSensorList();
    response.fold(
            (l){
          print("${l.message}");
        },
            (r){
          sensorListResponse.value = r;
          print("=================================");
          print(sensorListResponse.value);
          print("=================================");

        }
    );
  }

  CompanyList() async {
    var response = await devicesRepository.getCompanyList();
    response.fold(
            (l){
          print("${l.message}");
        },
            (r){
              companyListResponse.value = r;
          print("=================================");
          print(companyListResponse.value);
          print("=================================");

        }
    );
  }

  aeratorCommand({id, command}) async {

    var response = await devicesRepository.setAeratorCommand(id: id, command: command);
    response.fold(
            (l){
          print("${l.message}");
        },
            (r){
              aeratorCommandResponse.value = r;

          print("=================================");
          print(aeratorCommandResponse.value);
          print("=================================");

        }
    );
  }

}
