import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../../../common_widgets/common_app_bar.dart';
import '../../../common_widgets/common_container.dart';
import '../../../common_widgets/common_text.dart';
import '../../../res/colors/colors.dart';
import '../../../res/strings/feed_management.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/feed_management_details_controller.dart';

class FeedManagementDetailsView
    extends GetView<FeedManagementDetailsController> {
  const FeedManagementDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.put(HomeController());
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xffd4fcfd),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.backGround,
          body: Column(
            children: [
              Obx(() {
                return CommonAppBar(
                  title: 'title'.tr,
                  cityName: "dhaka".tr,
                  date: '${homeController.formattedDate}',
                  time: '${homeController.formattedTime}',
                  temp: '${homeController.weatherData['main']['temp']}°C',
                  humidity:
                      '${homeController.weatherData['main']['humidity']}%',
                );
              }),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        if (controller.title.value == "Types of Feed")
                          Column(
                            children: [
                              CommonContainer(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                child: Column(
                                  children: [
                                    title(text: FeedManagementData.title1),
                                    const SizedBox(height: 10),
                                    section(
                                      text: FeedManagementData.title1Subtitle1,
                                    ),
                                    section(
                                      text: FeedManagementData.title1Subtitle2,
                                    ),
                                    section(
                                      text: FeedManagementData
                                          .title1Subtitle2Value1,
                                    ),
                                    section(
                                      text: FeedManagementData
                                          .title1Subtitle2Value2,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        if (controller.title.value ==
                            "Feed Selection Guidelines")
                          Column(
                            children: [
                              CommonContainer(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                child: Column(
                                  children: [
                                    title(text: FeedManagementData.title2),
                                    const SizedBox(height: 10),
                                    Table(
                                      border: TableBorder.all(),
                                      columnWidths: const {
                                        0: FixedColumnWidth(140),
                                        1: FlexColumnWidth(),
                                      },
                                      children: [
                                        TableRow(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                          ),
                                          children: [
                                            tableCell(
                                              "Fish Stage",
                                              isHeader: true,
                                            ),
                                            tableCell(
                                              "Protein Requirement",
                                              isHeader: true,
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            tableCell("Fry/Fingerlings"),
                                            tableCell("30–35%"),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            tableCell("Medium-size Fish"),
                                            tableCell("25–30%"), ////
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            tableCell("Market-size Fish"),
                                            tableCell("22–25%"),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            tableCell("Shrimp/Crab"),
                                            tableCell("35–40%"),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const CommonText(
                                          "* ",
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        Expanded(
                                          child: CommonText(
                                            "Feed should also contain carbs, fats, vitamins, and minerals.",
                                            color: Colors.red.shade800,
                                            maxLines: 2,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        if (controller.title.value ==
                            "Feeding Time and Quantity")
                          Column(
                            children: [
                              CommonContainer(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                child: Column(
                                  children: [
                                    title(text: FeedManagementData.title3),
                                    const SizedBox(height: 10),
                                    section(
                                      text: FeedManagementData.title3Subtitle1,
                                    ),
                                    section(
                                      text: FeedManagementData.title3Subtitle2,
                                    ),
                                    section(
                                      text: FeedManagementData
                                          .title3Subtitle2Value1,
                                    ),
                                    section(
                                      text: FeedManagementData
                                          .title3Subtitle2Value2,
                                    ),
                                    section(
                                      text: FeedManagementData
                                          .title3Subtitle2Value3,
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const CommonText(
                                          "* ",
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        Expanded(
                                          child: CommonText(
                                            "Adjust based on water quality and natural food availability.",
                                            color: Colors.red.shade800,
                                            maxLines: 2,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        if (controller.title.value == "Feeding Methods")
                          Column(
                            children: [
                              CommonContainer(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                child: Column(
                                  children: [
                                    title(text: FeedManagementData.title4),
                                    const SizedBox(height: 10),
                                    section(
                                      text: FeedManagementData.title4Subtitle1,
                                    ),
                                    section(
                                      text: FeedManagementData.title4Subtitle2,
                                    ),
                                    section(
                                      text: FeedManagementData.title4Subtitle3,
                                    ),
                                    section(
                                      text: FeedManagementData.title4Subtitle4,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        if (controller.title.value ==
                            "Relationship Between Water & Feed Management")
                          Column(
                            children: [
                              CommonContainer(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                child: Column(
                                  children: [
                                    title(text: FeedManagementData.title5),
                                    const SizedBox(height: 10),
                                    section(
                                      text: FeedManagementData.title5Subtitle1,
                                    ),
                                    section(
                                      text: FeedManagementData.title5Subtitle2,
                                    ),
                                    section(
                                      text: FeedManagementData.title5Subtitle3,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        if (controller.title.value == "Special Feeding Tips")
                          Column(
                            children: [
                              CommonContainer(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                child: Column(
                                  children: [
                                    title(text: FeedManagementData.title6),
                                    const SizedBox(height: 10),
                                    section(
                                      text: FeedManagementData.title6Subtitle1,
                                    ),
                                    section(
                                      text: FeedManagementData.title6Subtitle2,
                                    ),
                                    section(
                                      text: FeedManagementData.title6Subtitle3,
                                    ),
                                    section(
                                      text: FeedManagementData.title6Subtitle4,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        if (controller.title.value ==
                            "Feed Conversion Ratio (FCR)")
                          CommonContainer(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            child: Column(
                              children: [
                                title(text: FeedManagementData.title7),
                                const SizedBox(height: 10),
                                section2(
                                  text: FeedManagementData.title7Subtitle1,
                                ),
                                section(
                                  text:
                                      FeedManagementData.title7Subtitle1Value1,
                                ),
                                section2(
                                  text: FeedManagementData.title7Subtitle2,
                                ),
                                section(
                                  text:
                                      FeedManagementData.title7Subtitle2Value1,
                                ),
                                section(
                                  text:
                                      FeedManagementData.title7Subtitle2Value2,
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CommonText(
                                      "* ",
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    Expanded(
                                      child: CommonText(
                                        FeedManagementData.title7Subtitle3,
                                        color: Colors.red.shade800,
                                        maxLines: 2,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 12),
                        if (controller.title.value ==
                            "Feed Requirement Calculator")
                          Column(
                            children: [
                              CommonContainer(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                child: Column(
                                  children: [
                                    title(text: FeedManagementData.title8),
                                    const SizedBox(height: 10),
                                    section2(
                                      text: FeedManagementData.title8Subtitle1,
                                    ),
                                    section(
                                      text: FeedManagementData
                                          .title8Subtitle1Value1,
                                    ),
                                    section(
                                      text: FeedManagementData
                                          .title8Subtitle1Value2,
                                    ),
                                    section(
                                      text: FeedManagementData
                                          .title8Subtitle1Value3,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
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

  title({text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: CommonText(
            "$text",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xff0370c3),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  section({text}) {
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

  section2({text}) {
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

  subSection({text}) {
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
}
