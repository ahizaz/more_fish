import 'package:get/get.dart';
import 'package:more_fish/app/repo/devices_repo.dart';
import 'package:more_fish/app/res/strings/pond_management.dart';

import '../../../response/pond_list_response.dart';

class PondManagementController extends GetxController {

  var titleList =[
    'parameter',
    'farming',
    'pond',
    'guide',
  ];

  var dataList =[
    PondManagementData.data1,
    PondManagementData.data2,
    PondManagementData.data3,
    PondManagementData.data4,
  ];


  @override
  void onInit() {
    super.onInit();
  }


}
