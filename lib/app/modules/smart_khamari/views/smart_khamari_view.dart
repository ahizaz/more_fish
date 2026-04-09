import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:more_fish/app/common_widgets/common_container.dart';
import 'package:more_fish/app/common_widgets/common_text.dart';

import '../../../res/colors/colors.dart';
import '../controllers/smart_khamari_controller.dart';

class SmartKhamariView extends GetView<SmartKhamariController> {
  const SmartKhamariView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGround,
      appBar: AppBar(
        backgroundColor: Color(0xffd4fcfd),
        title: const Text(
          'Smart Khamari',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        itemCount: controller.dataList.length,
        itemBuilder: (context, index){
          return CommonContainer(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            margin: EdgeInsets.only(bottom: 12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CommonText(
                        "${controller.titleList[index]}",
                        fontSize: 18,
                        maxLines: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                controller.dataList[index].isEmpty ? SizedBox() :
                Column(
                  children: [
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CommonText(
                            "${controller.dataList[index]}",
                            fontSize: 16,
                            maxLines: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
