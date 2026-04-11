import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../../../common_widgets/common_app_bar.dart';
import '../../../common_widgets/common_container.dart';
import '../../../common_widgets/common_text.dart';
import '../../../res/colors/colors.dart';

import '../../../routes/app_pages.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/fish_disease_treatment_controller.dart';

class FishDiseaseTreatmentView extends GetView<FishDiseaseTreatmentController> {
  const FishDiseaseTreatmentView({super.key});
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
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 16),
              itemCount: controller.titleList.length,
              itemBuilder: (context, index){
                return InkWell(
                  onTap: (){
                    Get.toNamed(Routes.FISH_DISEASE_TREATMENT_DETAILS, arguments: {"diseaseName": controller.titleList[index], "data": controller.dataList[index]});
                  },
                  child: CommonContainer(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    margin: EdgeInsetsGeometry.only(left: 16, right: 16,  bottom: 14),
                    child: CommonText(
                      "${controller.titleList[index]}",
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                      textAlign: TextAlign.center,

                    ),
                  ),
                );
              },
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
      margin: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Expanded(
            child: CommonText(
              "$text",
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
      margin: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Expanded(
            child: CommonText(
              "$text",
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


/*Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: boxDecoration(),
                      child: Column(
                        children: [
                          title(text: "${FishDiseaseTreatmentData.title1}"),
                          SizedBox(height: 10,),
                          subSection(text: "${FishDiseaseTreatmentData.title1Subtitle1}"),
                          subSection(text: "${FishDiseaseTreatmentData.title1Subtitle2Value1}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title1Subtitle2Value2}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title1Subtitle2Value3}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title1Subtitle2Value4}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title1Subtitle2Value5}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title1Subtitle2Value6}") ,
                        ],
                      ),
                    ),
                    SizedBox(height: 12,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: boxDecoration(),
                      child: Column(
                        children: [
                          title(text: "${FishDiseaseTreatmentData.title2}",),
                          SizedBox(height: 10,),
                          section2(text: "${FishDiseaseTreatmentData.title2Subtitle1}"),
                          subSection(text: "${FishDiseaseTreatmentData.title2Subtitle2Value1}") ,
                          SizedBox(height: 8,),
                          section2(text: "${FishDiseaseTreatmentData.title2Subtitle2}"),
                          subSection(text: "${FishDiseaseTreatmentData.title2Subtitle2Value1}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title2Subtitle2Value2}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title2Subtitle2Value3}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title2Subtitle2Value4}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title2Subtitle2Value5}") ,
                          SizedBox(height: 8,),
                          section2(text: "${FishDiseaseTreatmentData.title2Subtitle3}"),
                          subSection(text: "${FishDiseaseTreatmentData.title2Subtitle3Value1}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title2Subtitle3Value2}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title2Subtitle3Value3}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title2Subtitle3Value4}") ,
                          SizedBox(height: 8,),
                          section2(text: "${FishDiseaseTreatmentData.title2Subtitle4}"),
                          subSection(text: "${FishDiseaseTreatmentData.title2Subtitle4Value1}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title2Subtitle4Value2}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title2Subtitle4Value3}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title2Subtitle4Value4}") ,

                        ],
                      ),
                    ),
                    SizedBox(height: 12,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: boxDecoration(),
                      child: Column(
                        children: [
                          title(text: "${FishDiseaseTreatmentData.title3}",),
                          SizedBox(height: 10,),
                          section2(text: "${FishDiseaseTreatmentData.title3Subtitle1}"),
                          subSection(text: "${FishDiseaseTreatmentData.title3Subtitle2Value1}") ,
                          SizedBox(height: 8,),
                          section2(text: "${FishDiseaseTreatmentData.title3Subtitle2}"),
                          subSection(text: "${FishDiseaseTreatmentData.title3Subtitle2Value1}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title3Subtitle2Value2}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title3Subtitle2Value3}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title3Subtitle2Value4}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title3Subtitle2Value5}") ,
                          SizedBox(height: 8,),
                          section2(text: "${FishDiseaseTreatmentData.title3Subtitle3}"),
                          subSection(text: "${FishDiseaseTreatmentData.title3Subtitle3Value1}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title3Subtitle3Value2}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title2Subtitle3Value3}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title2Subtitle3Value4}") ,
                          SizedBox(height: 8,),
                          section2(text: "${FishDiseaseTreatmentData.title2Subtitle4}"),
                          subSection(text: "${FishDiseaseTreatmentData.title2Subtitle4Value1}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title2Subtitle4Value2}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title2Subtitle4Value3}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title2Subtitle4Value4}") ,

                        ],
                      ),
                    ),
                    SizedBox(height: 12,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: boxDecoration(),
                      child: Column(
                        children: [
                          title(text: "${FishDiseaseTreatmentData.title4}",),
                          SizedBox(height: 10,),
                          section2(text: "${FishDiseaseTreatmentData.title4Subtitle1}"),
                          subSection(text: "${FishDiseaseTreatmentData.title4Subtitle1Value1}") ,
                          SizedBox(height: 8,),
                          section2(text: "${FishDiseaseTreatmentData.title4Subtitle2}"),
                          subSection(text: "${FishDiseaseTreatmentData.title4Subtitle2Value1}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title4Subtitle2Value2}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title4Subtitle2Value3}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title4Subtitle2Value4}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title4Subtitle2Value5}") ,

                          SizedBox(height: 8,),
                          section2(text: "${FishDiseaseTreatmentData.title4Subtitle3}"),
                          subSection(text: "${FishDiseaseTreatmentData.title4Subtitle3Value1}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title4Subtitle3Value2}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title4Subtitle3Value3}") ,

                          SizedBox(height: 8,),
                          section2(text: "${FishDiseaseTreatmentData.title4Subtitle4}"),
                          subSection(text: "${FishDiseaseTreatmentData.title4Subtitle4Value1}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title4Subtitle4Value2}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title4Subtitle4Value3}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title4Subtitle4Value4}") ,

                        ],
                      ),
                    ),
                    SizedBox(height: 12,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: boxDecoration(),
                      child: Column(
                        children: [
                          title(text: "${FishDiseaseTreatmentData.title5}",),
                          SizedBox(height: 10,),
                          section2(text: "${FishDiseaseTreatmentData.title5Subtitle1}"),
                          subSection(text: "${FishDiseaseTreatmentData.title5Subtitle1Value1}") ,
                          SizedBox(height: 8,),
                          section2(text: "${FishDiseaseTreatmentData.title5Subtitle2}"),
                          subSection(text: "${FishDiseaseTreatmentData.title5Subtitle2Value1}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title5Subtitle2Value2}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title5Subtitle2Value3}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title5Subtitle2Value4}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title5Subtitle2Value5}") ,

                          SizedBox(height: 8,),
                          section2(text: "${FishDiseaseTreatmentData.title5Subtitle3}"),
                          subSection(text: "${FishDiseaseTreatmentData.title5Subtitle3Value1}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title5Subtitle3Value2}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title5Subtitle3Value3}") ,


                          SizedBox(height: 8,),
                          section2(text: "${FishDiseaseTreatmentData.title5Subtitle4}"),
                          subSection(text: "${FishDiseaseTreatmentData.title5Subtitle4Value1}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title5Subtitle4Value2}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title5Subtitle4Value3}") ,

                        ],
                      ),
                    ),
                    SizedBox(height: 12,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: boxDecoration(),
                      child: Column(
                        children: [
                          title(text: "${FishDiseaseTreatmentData.title6}",),
                          SizedBox(height: 10,),
                          section2(text: "${FishDiseaseTreatmentData.title6Subtitle1}"),
                          subSection(text: "${FishDiseaseTreatmentData.title6Subtitle1Value1}") ,
                          SizedBox(height: 8,),
                          section2(text: "${FishDiseaseTreatmentData.title6Subtitle2}"),
                          subSection(text: "${FishDiseaseTreatmentData.title6Subtitle2Value1}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title6Subtitle2Value2}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title6Subtitle2Value3}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title6Subtitle2Value4}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title6Subtitle2Value5}") ,

                          SizedBox(height: 8,),
                          section2(text: "${FishDiseaseTreatmentData.title6Subtitle3}"),
                          subSection(text: "${FishDiseaseTreatmentData.title6Subtitle3Value1}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title6Subtitle3Value2}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title6Subtitle3Value3}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title6Subtitle3Value4}") ,

                          SizedBox(height: 8,),
                          section2(text: "${FishDiseaseTreatmentData.title6Subtitle4}"),
                          subSection(text: "${FishDiseaseTreatmentData.title6Subtitle4Value1}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title6Subtitle4Value2}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title6Subtitle4Value3}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title6Subtitle4Value4}") ,

                        ],
                      ),
                    ),
                    SizedBox(height: 12,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: boxDecoration(),
                      child: Column(
                        children: [
                          title(text: "${FishDiseaseTreatmentData.title7}",),
                          SizedBox(height: 10,),
                          section2(text: "${FishDiseaseTreatmentData.title7Subtitle1}"),
                          subSection(text: "${FishDiseaseTreatmentData.title7Subtitle1Value1}") ,
                          SizedBox(height: 8,),
                          section2(text: "${FishDiseaseTreatmentData.title7Subtitle2}"),
                          subSection(text: "${FishDiseaseTreatmentData.title7Subtitle2Value1}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title7Subtitle2Value2}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title7Subtitle2Value3}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title7Subtitle2Value4}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title7Subtitle2Value5}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title7Subtitle2Value6}") ,

                          SizedBox(height: 8,),
                          section2(text: "${FishDiseaseTreatmentData.title7Subtitle3}"),
                          subSection(text: "${FishDiseaseTreatmentData.title7Subtitle3Value1}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title7Subtitle3Value2}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title7Subtitle3Value3}") ,

                          SizedBox(height: 8,),
                          section2(text: "${FishDiseaseTreatmentData.title7Subtitle4}"),
                          subSection(text: "${FishDiseaseTreatmentData.title7Subtitle4Value1}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title7Subtitle4Value2}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title7Subtitle4Value3}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title7Subtitle4Value4}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title7Subtitle4Value5}") ,


                        ],
                      ),
                    ),
                    SizedBox(height: 12,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: boxDecoration(),
                      child: Column(
                        children: [
                          title(text: "${FishDiseaseTreatmentData.title8}",),
                          SizedBox(height: 8,),
                          section2(text: "${FishDiseaseTreatmentData.title8Subtitle2}"),
                          subSection(text: "${FishDiseaseTreatmentData.title8Subtitle2Value1}") ,

                          SizedBox(height: 8,),
                          section2(text: "${FishDiseaseTreatmentData.title8Subtitle3}"),
                          subSection(text: "${FishDiseaseTreatmentData.title8Subtitle3Value1}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title8Subtitle3Value2}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title8Subtitle3Value3}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title8Subtitle3Value4}") ,


                        ],
                      ),
                    ),
                    SizedBox(height: 12,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: boxDecoration(),
                      child: Column(
                        children: [
                          title(text: "${FishDiseaseTreatmentData.title9}",),
                          SizedBox(height: 8,),
                          section2(text: "${FishDiseaseTreatmentData.title9Subtitle2}"),
                          subSection(text: "${FishDiseaseTreatmentData.title9Subtitle2Value1}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title9Subtitle2Value2}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title9Subtitle2Value3}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title9Subtitle2Value4}") ,

                          SizedBox(height: 8,),
                          section2(text: "${FishDiseaseTreatmentData.title9Subtitle3}"),
                          subSection(text: "${FishDiseaseTreatmentData.title9Subtitle3Value1}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title9Subtitle3Value2}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title9Subtitle3Value3}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title9Subtitle3Value4}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title9Subtitle3Value5}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title9Subtitle3Value6}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title9Subtitle3Value7}") ,


                        ],
                      ),
                    ),
                    SizedBox(height: 12,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: boxDecoration(),
                      child: Column(
                        children: [
                          title(text: "${FishDiseaseTreatmentData.title10}",),
                          SizedBox(height: 8,),
                          section2(text: "${FishDiseaseTreatmentData.title10Subtitle2}"),
                          subSection(text: "${FishDiseaseTreatmentData.title10Subtitle2Value1}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title10Subtitle2Value2}") ,

                          SizedBox(height: 8,),
                          section2(text: "${FishDiseaseTreatmentData.title10Subtitle3}"),
                          subSection(text: "${FishDiseaseTreatmentData.title10Subtitle3Value1}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title10Subtitle3Value2}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title10Subtitle3Value3}") ,

                          SizedBox(height: 8,),
                          section2(text: "${FishDiseaseTreatmentData.title10Subtitle4}"),
                          subSection(text: "${FishDiseaseTreatmentData.title10Subtitle4Value1}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title10Subtitle4Value2}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title10Subtitle4Value3}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title10Subtitle4Value4}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title10Subtitle4Value5}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title10Subtitle4Value6}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title10Subtitle4Value7}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title10Subtitle4Value8}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title10Subtitle4Value9}") ,
                          subSection(text: "${FishDiseaseTreatmentData.title10Subtitle4Value10}") ,


                        ],
                      ),
                    ),*/