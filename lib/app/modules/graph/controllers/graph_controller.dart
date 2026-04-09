import 'package:get/get.dart';
import 'package:more_fish/app/response/graph_response.dart';
import '../../../repo/devices_repo.dart';

class GraphController extends GetxController {
  DevicesRepository devicesRepository = DevicesRepository();
  final graphResponse = Rxn<GraphResponse>();

  var sensorValues = <double>[].obs;
  var timeLabels = <String>[].obs;

  var comId;
  var assetId;
  var sensorId;
  var type;

  var selectedPeriod = 'Daily'.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> graphData({type}) async {


    if (Get.arguments != null && type == null){
      comId = Get.arguments["comId"];
      assetId = Get.arguments["assetId"];
      sensorId = Get.arguments["sensorId"];
      type = Get.arguments["type"];
    }
    else{
      comId = Get.arguments["comId"];
      assetId = Get.arguments["assetId"];
      sensorId = Get.arguments["sensorId"];
      type = type;
    }

    var response = await devicesRepository.getGraphData(
      comId: comId,
      assetId: assetId,
      sensorId: sensorId,
      type: type,
    );

    response.fold(
          (l) {
        print('Failed to fetch graph: ${l.message}');
      },
          (r) {
        graphResponse.value = r;

      },
    );

    final dataList = graphResponse.value?.data;
    if (dataList != null && dataList.isNotEmpty) {
      final firstItem = dataList.first;

      final sensorVal = firstItem.sensorVal;
      final time = firstItem.time;

      if (sensorVal != null && time != null) {
        sensorValues.value = sensorVal.map((e) => double.tryParse(e) ?? 0.0).toList();
        timeLabels.value = List<String>.from(time);
      }
    }
  }
}
