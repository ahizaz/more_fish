import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:more_fish/app/res/colors/colors.dart';
import '../../../common_widgets/common_container.dart';
import '../../../common_widgets/common_text.dart';
import '../controllers/internet_checker_controller.dart';

class InternetCheckerView extends GetView<InternetCheckerController> {
  const InternetCheckerView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.checkInternet();
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Color(0xffebffff),
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
        child: SafeArea(
          child: Scaffold(
                body: CommonContainer(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                    "assets/icons/no_internet.png",
                  height: 150,
                  width: 150,
          
                ),
                SizedBox(height: 20,),
                CommonText(
                  'Sorry, No Internet Connection.',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.red,
                ),
              ],
            ),
          ),
                ),
                ),
        ),
    );
  }
}
