import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../../../common_widgets/common_app_bar.dart';
import '../../../common_widgets/common_text.dart';
import '../../../res/colors/colors.dart';
import '../../../res/strings/pond_management.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/pond_management_table_controller.dart';

class PondManagementTableView extends GetView<PondManagementTableController> {
  const PondManagementTableView({super.key});


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
          backgroundColor: AppColors.backGround,
          body: Column(
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
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: boxDecoration(),
                          child: Column(
                            children: [
                              title(text: "${PondManagementData.title1}"),
                              SizedBox(height: 10,),
                              Table(
                                border: TableBorder.all(),
                                columnWidths: {
                                  0: FixedColumnWidth(140),
                                  1: FlexColumnWidth(),
                                },
                                children: [
                                  TableRow(
                                    decoration: BoxDecoration(color: Colors.grey[300]),
                                    children: [
                                      tableCell("Parameter", isHeader: true),
                                      tableCell("Ideal Range", isHeader: true),
                                    ],
                                  ),
                                  TableRow(children: [
                                    tableCell("Water Depth"),
                                    tableCell("1.5-2 meter"),
                                  ]),
                                  TableRow(children: [
                                    tableCell("Water Color"),
                                    tableCell("Light green / Light brown"),

                                  ]),
                                  TableRow(children: [
                                    tableCell("Water pH"),
                                    tableCell("7.0–8.5"),
                                  ]),
                                  TableRow(children: [
                                    tableCell("Soil pH"),
                                    tableCell("6.5–8.0"),
                                  ]),
                                  TableRow(children: [
                                    tableCell("Dissolved Oxygen (DO)"),
                                    tableCell(">5 mg/L"),
                                  ]),
                                  TableRow(children: [
                                    tableCell("Temperature"),
                                    tableCell("25–30°C"),
                                  ]),
                                  TableRow(children: [
                                    tableCell("Ammonia (NH₃)"),
                                    tableCell("≤0.25 mg/L"),
                                  ]),
                                  TableRow(children: [
                                    tableCell("Transparency"),
                                    tableCell("25–40 cm (Secchi disk)"),
                                  ]),
                                  TableRow(children: [
                                    tableCell("Total Dissolved Solids (TDS)"),
                                    tableCell("100–500 mg/L (freshwater)\n"
                                        "1000–5000 mg/L (salt water)"),
                                  ]),
                                  TableRow(children: [
                                    tableCell("Hardness"),
                                    tableCell("50–150 mg/L"),
                                  ]),
                                  TableRow(children: [
                                    tableCell("Alkalinity"),
                                    tableCell("50–150 mg/L"),
                                  ]),
                                ],
                              ),
                              SizedBox(height: 10,),
                            ],
                          ),
                        ),
                        SizedBox(height: 12,),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  title({text}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: CommonText(
            "${text}",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xff0370c3),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  section({text}){
    return Container(
      margin: EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Expanded(
            child: CommonText(
              "${text}",
              fontSize: 16,
              fontWeight: FontWeight.w500,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }

  section2({text}){
    return Container(
      margin: EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Expanded(
            child: CommonText(
              "${text}",
              fontSize: 18,
              fontWeight: FontWeight.bold,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }

  subSection({text}){
    return Container(
      margin: EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Expanded(
            child: CommonText(
              "${text}",
              fontSize: 16,
              fontWeight: FontWeight.w500,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }

  Widget tableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: 16,
        ),
      ),
    );
  }

  boxDecoration(){
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xffebffff), // Start color
          Colors.white,      // End color
        ],
        begin: Alignment.topLeft,   // Gradient start position
        end: Alignment.bottomRight, // Gradient end position
      ),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.blueGrey.withOpacity(0.5),  // Shadow color with opacity
          spreadRadius: 1,   // How much the shadow spreads
          blurRadius: 1,     // How blurry the shadow is
          offset: Offset(.2, .2), // Position of shadow: (x, y)
        ),
      ],
    );
  }
}
