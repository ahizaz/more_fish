import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../common_widgets/common_container.dart';
import '../../../common_widgets/common_text.dart';
import '../../../res/colors/colors.dart';
import '../controllers/faq_details_controller.dart';

class FaqDetailsView extends GetView<FaqDetailsController> {
  const FaqDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGround,
      appBar: AppBar(
        backgroundColor: Color(0xffcbffff),
        title: Text(
          '${controller.title}'.tr,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: CommonContainer(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(
              "${controller.data}".tr,
              maxLines: 10,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.blueGrey.shade800,
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 15,),
          ],
        ),
      ),
    );
  }
}
