import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../common_widgets/common_container.dart';
import '../../../common_widgets/common_text.dart';
import '../controllers/about_devices_details_controller.dart';

class AboutDevicesDetailsView extends GetView<AboutDevicesDetailsController> {
  const AboutDevicesDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffcbffff),
        title: Text(
          '${controller.title}'.tr,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: CommonContainer(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(
              controller.data.tr,
              maxLines: 10,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.blueGrey.shade800,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 15,),
          ],
        ),
      ),
    );
  }
}
