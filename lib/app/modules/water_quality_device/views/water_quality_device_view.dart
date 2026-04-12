import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:more_fish/app/common_widgets/common_text.dart';
import 'package:more_fish/app/service/service.dart';
import '../../../common_widgets/common_app_bar.dart';
import '../../../common_widgets/common_container.dart';
import '../../../routes/app_pages.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/water_quality_device_controller.dart';

class WaterQualityDeviceView extends GetView<WaterQualityDeviceController> {
  const WaterQualityDeviceView({super.key});
  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.put(HomeController());
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Color(0xffd4fcfd),
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
        child:SafeArea(
          child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          body: InkWell(
            onTapDown: (v){
              controller.pondDataResponse.value = null;
              controller.pondList();
              controller.sensorList();
              controller.CompanyList();
            },
            child: Column(
              children: [
                Obx((){
                  return CommonAppBar(
                    title: 'title'.tr,
                    cityName: "dhaka".tr,
                    date: '${homeController.formattedDate}',
                    time: '${homeController.formattedTime}',
                    temp: '${homeController.weatherData['main']['temp']}°C',
                    humidity: '${homeController.weatherData['main']['humidity']}%',
                  );
                }),
                Expanded(
                  child: Obx((){
                    var data = controller.pondDataResponse.value;
                    return data == null ?
                        const Center(child: CircularProgressIndicator()):
                        Column(
                          children: [
                            Center(
                              child: Obx(() {
                                final pondList = controller.pondListResponse.value?.data ?? [];

                                if (pondList.isEmpty) {
                                  return const SizedBox();
                                }

                                final astNameIdList = pondList.map((pond) => {
                                  'astName': pond.astName,
                                  'id': pond.id,
                                }).toList();

                                final astNames = astNameIdList.map((e) => e['astName'] as String).toList();

                                if (!astNames.contains(controller.selectedAstName.value)) {
                                  controller.selectedAstName.value = astNames.first;
                                }

                                return Column(
                                  children: [
                                    const SizedBox(height: 12,),
                                    Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          value: controller.selectedAstName.value,
                                          onChanged: (String? newValue) {
                                            if (newValue != null) {

                                              final selectedItem = astNameIdList.firstWhere(
                                                    (e) => e['astName'] == newValue,
                                              );
                                              final selectedId = selectedItem['id'];

                                              controller.selectedAstName.value = newValue;

                                              print("name =============================== ${controller.selectedAstName.value}");
                                              print("id =============================== ${selectedId}");
                                              controller.pondData(id: selectedId);
                                            }
                                          },
                                          items: astNames.map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: CommonText(
                                                value,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            );
                                          }).toList(),
                                          buttonStyleData: ButtonStyleData(
                                            padding: const EdgeInsets.symmetric(horizontal: 16),
                                            height: 60,
                                            width: double.infinity,
                                            decoration: BoxDecoration(

                                              borderRadius: BorderRadius.circular(10),
                                            )
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                            maxHeight: 300,
                                            direction: DropdownDirection.textDirection,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10),
                                            )
                                          ),
                                          iconStyleData: const IconStyleData(
                                            icon: Icon(Icons.arrow_drop_down, size: 35,),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 12,),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12,),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  data.data.devices[0].deviceStatus == 'Online' ?
                                                  Container(
                                                    height: 16,
                                                    width: 16,
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xff00cc00),
                                                      borderRadius: BorderRadius.circular(100),
                                                    ),
                                                  ):
                                                  Container(
                                                    height: 16,
                                                    width: 16,
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius: BorderRadius.circular(100),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6,),
                                                  Expanded(
                                                    child: CommonText(
                                                      data.data.devices[0].deviceName,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                      overflow: TextOverflow.ellipsis,
                                                      color: const Color(0xff0370c3),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8,),
                                                ],
                                              ),
                                            ),
                                            CommonText(
                                              data.data.devices[0].sensors[0].dataTime,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              textAlign: TextAlign.center,
                                              color: const Color(0xff0370c3),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10,),
                                      Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 12),
                                        height: 2,
                                        color: const Color(0xff0370c3),
                                      ),
                                      Obx((){
                                        return GridView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                                            itemCount: controller.pondDataResponse.value?.data.devices[0].sensors.length,
                                            shrinkWrap: true,
                                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 10,
                                                mainAxisSpacing: 10,
                                                childAspectRatio: 1.3
                                            ),
                                            itemBuilder: (context, index){

                                              var data = controller.pondDataResponse.value?.data.devices[0].sensors[index];

                                              for(var i in controller.companyListResponse.value!.data!){
                                                if(i.name == controller.pondListResponse.value?.data[0].astName){
                                                  print(controller.pondListResponse.value?.data[0].astName);
                                                  controller.comId.value = i.id!;

                                                  print(controller.comId);
                                                  break;
                                                }
                                              }

                                              return InkWell(
                                                onTap: (){
                                                  Get.toNamed(Routes.GRAPH, arguments: {
                                                    "comId": controller.comId.value,
                                                    "assetId": controller.pondDataResponse.value?.data.assetId,
                                                    "sensorId": data?.sensorName == "pH" ? 1 : data?.sensorName == "Temperature" ? 2 :
                                                    data?.sensorName == "DO" ? 3 : data?.sensorName == "TDS" ? 4 : data?.sensorName == "NH3" ? 5 :
                                                    data?.sensorName == "Salainity"? 6 : null,
                                                    "type": "daily"});

                                                  print("${controller.pondDataResponse.value?.data.devices[0].sensors[index].sensorName}");
                                                },
                                                child: CommonContainer(
                                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: Image.network(
                                                          "${ApiService.baseUrl}/${controller.pondDataResponse.value?.data.devices[0].sensors[index].sensorIcon}",
                                                          height: 40,
                                                          width: 40,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                CommonText(
                                                                  controller.pondDataResponse.value?.data.devices[0].sensors[index].dangerStatus == "invalid" ?
                                                                  "No Data":
                                                                  double.tryParse(controller.pondDataResponse.value?.data.devices[0].sensors[index].lastValue ?? '')?.toStringAsFixed(2) ?? '0',
                                                                  fontSize: controller.pondDataResponse.value?.data.devices[0].sensors[index].dangerStatus == "invalid" ?16:20,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: controller.pondDataResponse.value?.data.devices[0].sensors[index].dangerStatus == "perfect" ?
                                                                  const Color(0xff00cc00): Colors.red,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                                const SizedBox(width: 3,),
                                                                CommonText(
                                                                  controller.pondDataResponse.value?.data.devices[0].sensors[index].dangerStatus == "invalid" ?
                                                                  "":
                                                                  "${controller.pondDataResponse.value?.data.devices[0].sensors[index].sensorUnit}",
                                                                  fontSize: 20,
                                                                  color: controller.pondDataResponse.value?.data.devices[0].sensors[index].dangerStatus == "perfect" ?
                                                                  const Color(0xff00cc00): Colors.red,
                                                                  fontWeight: FontWeight.w500,
                                                                )
                                                              ],

                                                            ),
                                                            CommonText(
                                                              "${controller.pondDataResponse.value?.data.devices[0].sensors[index].sensorName}",
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.bold,
                                                              overflow: TextOverflow.ellipsis,
                                                              maxLines: 1,
                                                            ),

                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                        );
                                      }),

                                      const SizedBox(height: 16,),
                                      Obx((){
                                        return ListView.builder(
                                          itemCount: controller.pondDataResponse.value?.data.devices[0].aerators.length,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context, int index) {
                                            return CommonContainer(
                                              margin: const EdgeInsets.only(left: 14, right: 14, bottom: 16),
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  CommonText(
                                                    "${controller.pondDataResponse.value?.data.devices[0].aerators[index].aeratorName}",
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  Obx((){
                                                    return Switch(
                                                      value: controller.aeratorSwitch[index],
                                                      onChanged: (bool value) {

                                                        controller.aeratorSwitch[index] = value;

                                                        if(controller.aeratorSwitch[index]){

                                                          controller.aeratorCommand(id: controller.pondDataResponse.value?.data.devices[0].aerators[index].aeratorId, command: 1);

                                                        }
                                                        else{
                                                          controller.aeratorCommand(id: controller.pondDataResponse.value?.data.devices[0].aerators[index].aeratorId, command: 0);

                                                        }

                                                      },
                                                      activeColor: Colors.green,
                                                      inactiveThumbColor: Colors.red,
                                                    );
                                                  })
                                                ],
                                              ),
                                            );
                                          },

                                        );
                                      }),
                                      //SizedBox(height: 16,),

                                      controller.pondDataResponse.value == null
                                          ? const SizedBox()
                                          : Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: List.generate(
                                            controller.pondDataResponse.value!.data.devices[0].sensors.length,
                                                (index) {
                                              var sensor = controller.pondDataResponse.value!.data.devices[0].sensors[index];
                                              var data = sensor.sensorName;
                                              var value = double.tryParse(sensor.lastValue.toString()) ?? 0.0;

                                              if (data == "pH" && value < 7)
                                                return const Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    CommonText(
                                                      "⚠️ Warning: ",
                                                      color: Colors.red,
                                                      fontWeight: FontWeight.bold,

                                                    ),
                                                    Expanded(
                                                      child: CommonText(
                                                        "চুন প্রয়োগ করুন।",
                                                        fontWeight: FontWeight.bold,
                                                        maxLines: 3,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                             if(data == "pH" && value > 8.5)
                                                return const Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    CommonText(
                                                        "⚠️ Warning: ",
                                                      color: Colors.red,
                                                      fontWeight: FontWeight.bold,

                                                    ),
                                                    Expanded(
                                                      child: CommonText(
                                                        "টিএসপি, জিপসাম, ভিনেগার অথবা গভীর নলকূপের পানি যোগ করুন।",
                                                        fontWeight: FontWeight.bold,
                                                        maxLines: 3,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              if(data == "DO" && value < 3)
                                                return const Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    CommonText(
                                                      "⚠️ Warning: ",
                                                      color: Colors.red,
                                                      fontWeight: FontWeight.bold,

                                                    ),
                                                    Expanded(
                                                      child: CommonText(
                                                        "এরেটর চালান বা গভীর নলকূপের পানি যোগ করুন।",
                                                        fontWeight: FontWeight.bold,
                                                        maxLines: 3,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              if(data == "TDS" && value < 100)
                                                return const Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    CommonText(
                                                      "⚠️ Warning: ",
                                                      color: Colors.red,
                                                      fontWeight: FontWeight.bold,

                                                    ),
                                                    Expanded(
                                                      child: CommonText(
                                                        "চুন, জিপসাম অথবা লবণ যোগ করুন।",
                                                        fontWeight: FontWeight.bold,
                                                        maxLines: 3,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              if(data == "TDS" && value > 1000)
                                                return const Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    CommonText(
                                                      "⚠️ Warning: ",
                                                      color: Colors.red,
                                                      fontWeight: FontWeight.bold,

                                                    ),
                                                    Expanded(
                                                      child: CommonText(
                                                        "গভীর নলকূপের পানি যোগ করুন।",
                                                        fontWeight: FontWeight.bold,
                                                        maxLines: 3,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              if(data == "Temperature" && value > 34)
                                                return const Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    CommonText(
                                                      "⚠️ Warning: ",
                                                      color: Colors.red,
                                                      fontWeight: FontWeight.bold,

                                                    ),
                                                    Expanded(
                                                      child: CommonText(
                                                        "গভীর নলকূপের পানি যোগ করুন।",
                                                        fontWeight: FontWeight.bold,
                                                        maxLines: 3,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              if(data == "NH3" && value > 0.5)
                                                return const Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    CommonText(
                                                      "⚠️ Warning: ",
                                                      color: Colors.red,
                                                      fontWeight: FontWeight.bold,

                                                    ),
                                                    Expanded(
                                                      child: CommonText(
                                                        "হররা বা জাল টানুন।",
                                                        fontWeight: FontWeight.bold,
                                                        maxLines: 3,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              else
                                                return const CommonText("");

                                            },
                                          ),
                                        ),
                                      )

                                    ],
                                  ),
                                ),
                              ),
                            ),

                          ],
                        );
                  }),
                ),
              ],
            ),
          ),
          ),
        )
    );
  }
}
