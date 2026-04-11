import 'package:get/get.dart';

import 'package:more_fish/app/res/strings/pond_management.dart';



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
