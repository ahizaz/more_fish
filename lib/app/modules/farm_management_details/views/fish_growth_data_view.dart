import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common_widgets/common_container.dart';
import '../controllers/farm_management_details_controller.dart';


class FishGrowthDataView extends StatelessWidget {
  const FishGrowthDataView(this.controller, {super.key,});
  final controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CommonContainer(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              controller.data,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Table(
                          border: TableBorder.all(),
                          columnWidths: const {
                            0: FixedColumnWidth(50),
                            1: FixedColumnWidth(60),
                            2: FixedColumnWidth(60),
                            3: FixedColumnWidth(60),
                            4: FixedColumnWidth(70),
                            5: FixedColumnWidth(80),
                            6: FixedColumnWidth(85),
                            7: FixedColumnWidth(120),
                            8: FixedColumnWidth(110),
                            9: FixedColumnWidth(100),
                            10: FixedColumnWidth(85),
                            11: FixedColumnWidth(100),

                            12: FixedColumnWidth(250),
                            13: FixedColumnWidth(80),
                            14: FixedColumnWidth(90),
                            15: FixedColumnWidth(90),
                          },
                          children: [
                            TableRow(
                              decoration: BoxDecoration(color: Colors.grey[300]),
                              children: [
                                tableCell("Pond No.", isHeader: true),
                                tableCell("Pond Type", isHeader: true),
                                tableCell("পুকুরের আয়তন", isHeader: true),
                                tableCell("পুকুরের গভীরতা", isHeader: true),
                                tableCell("মাছের জাত", isHeader: true),
                                tableCell("সাথী মাছের জাত", isHeader: true),
                                tableCell("মাছ মজুদের তারিখ", isHeader: true),
                                tableCell("মজুদকৃত মাছের সংখ্যা", isHeader: true),
                                tableCell("মজুদকৃত মাছের বয়স", isHeader: true),
                                tableCell("মজুদকৃত মাছের ওজন", isHeader: true),
                                tableCell("মাছের বর্তমান বয়স", isHeader: true),
                                tableCell("মাছের বর্তমান ওজন", isHeader: true),
                                tableCell("খাবার প্রয়োগ পদ্ধতি", isHeader: true),
                                tableCell("সার প্রয়োগ পদ্ধতি", isHeader: true),
                                tableCell("মেডিসিন প্রয়োগ পদ্ধতি", isHeader: true),
                                tableCell("মাছ উত্তলনের তারিখ", isHeader: true),
                              ],
                            ),

                            TableRow(
                              children: [
                                tableCell("১(১১)", ),
                                tableCell("কালচার পুকুর", ),
                                tableCell("৫০০ শতক", ),
                                tableCell("৭ ফিট", ),
                                tableCell("তেলাপিয়া", ),
                                tableCell("সিলভার,\nরুই, কাতলা,\nমিরর কার্প,\nব্রিগেড", ),
                                tableCell("05-06-2023", ),
                                tableCell("তেলাপিয়া - ৭০,০০০\nসাথী মাছ - ১০,০০০",),
                                tableCell("তেলাপিয়া – ১মাস\nসাথী মাছ – ৩মাস",),
                                tableCell("তেলাপিয়া-৭৫ পিস পার কেজি\nসাথী -৮ পিস পার কেজি", ),
                                tableCell("৯০ দিন", ),
                                tableCell("তেলাপিয়া- প্রতি কেজিতে ১৯টি\nসাথী মাছ- প্রতি কেজিতে ৩টি", ),
                                tableCell("৩ মিলি Grower", ),
                                tableCell("সার প্রয়োগ করা হয়নি", ),
                                tableCell("১৫ দিন পরপর  Probiotic Super pH – 4L",),
                                tableCell("15 September",),
                              ],
                            ),
                            TableRow(
                              children: [
                                tableCell("২(১০)", ),
                                tableCell("কালচার পুকুর", ),
                                tableCell("১৬০ শতক", ),
                                tableCell("৭ ফিটা", ),
                                tableCell("তেলাপিয়া", ),
                                tableCell("সিলভার, রুই, কাতলা, মিরর কার্প, ব্রিগেড", ),
                                tableCell("05-06-2023", ),
                                tableCell("তেলাপিয়া - ৭০,০০০\nসাথী মাছ - ১০,০০০",),
                                tableCell("তেলাপিয়া – ১মাস\nসাথী মাছ – ৩মাস",),
                                tableCell("তেলাপিয়া-৭৫ পিস পার কেজি\nসাথী -৮ পিস পার কেজি", ),
                                tableCell("৯০ দিন", ),
                                tableCell("তেলাপিয়া- প্রতি কেজিতে ১১টি\nসাথী মাছ- প্রতি কেজিতে ৩টি", ),
                                tableCell("৩ মিলি Grower প্রতিদিন ৩ বেলা ৭ বস্তা । ২০ কেজি পার বস্তা । পার বস্তা খরচ - ১১৬০ । ( বৃষ্টিতে খাবারের পরিমাণ কমিয়ে দেয়া হয়। তাই গতকাল কেবল ১ বেলা খাবার দেয়া হয়েছে । )", ),
                                tableCell("সার প্রয়োগ করা হয়নি", ),
                                tableCell("১৫ দিন পরপর  Probiotic Super pH – 2L",),
                                tableCell("15 September",),
                              ],
                            ),
                            TableRow(
                              children: [
                                tableCell("১(১১)", ),
                                tableCell("কালচার পুকুর", ),
                                tableCell("৫০০ শতক", ),
                                tableCell("৭ ফিট", ),
                                tableCell("তেলাপিয়া", ),
                                tableCell("সিলভার, রুই, কাতলা, মিরর কার্প, ব্রিগেড", ),
                                tableCell("05-06-2023", ),
                                tableCell("তেলাপিয়া - ৭০,০০০\nসাথী মাছ - ১০,০০০",),
                                tableCell("তেলাপিয়া – ১মাস\nসাথী মাছ – ৩মাস",),
                                tableCell("", ),
                                tableCell("৯৭ দিন", ),
                                tableCell("তেলাপিয়া- প্রতি কেজিতে ১৩টি \nসাথী মাছ- ৪০০ গ্রাম+", ),
                                tableCell("৩ মিলি Growerপ্রতিদিন ৩ বেলা ৯ বস্তা । ২০ কেজি পার বস্তা । পার বস্তা খরচ - ১১৬০ ।", ),
                                tableCell("সার প্রয়োগ করা হয়নি", ),
                                tableCell("15th August Super pH – 4L",),
                                tableCell("15 September",),
                              ],
                            ),
                            TableRow(
                              children: [
                                tableCell("২(১০)", ),
                                tableCell("কালচার পুকুর", ),
                                tableCell("১৬০ শতক", ),
                                tableCell("৭ ফিট", ),
                                tableCell("তেলাপিয়া", ),
                                tableCell("সিলভার, রুই, কাতলা, মিরর কার্প, ব্রিগেড", ),
                                tableCell("05-06-2023", ),
                                tableCell("তেলাপিয়া - ৭০,০০০\nসাথী মাছ - ১০,০০০",),
                                tableCell("তেলাপিয়া – ১মাস\nসাথী মাছ – ৩মাস",),
                                tableCell("", ),
                                tableCell("৯৭ দিন", ),
                                tableCell("তেলাপিয়া- প্রতি কেজিতে ৮.৫টি \nসাথী মাছ- প্রতি কেজিতে ৮.৫টি", ),
                                tableCell("৩ মিলি Grower প্রতিদিন ৩ বেলা ৯ বস্তা । ২০ কেজি পার বস্তা । পার বস্তা খরচ - ১১৬০ ।", ),
                                tableCell("সার প্রয়োগ করা হয়নি", ),
                                tableCell("15th August Super pH – 4L",),
                                tableCell("15 September",),
                              ],
                            ),
                          ],
                        ),
                      ),


                      SizedBox(height: 10),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () async {
            final Uri launchUri = Uri(
              scheme: 'tel',
              path: "+8801783038202",
            );
            if (await canLaunchUrl(launchUri)) {
              await launchUrl(launchUri);
            } else {
              // Handle error here
            }
          },
          child: CommonContainer(
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone, color: Colors.green.shade700),
                const SizedBox(width: 12),
                Text(
                  "Call Now",
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget tableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
      ),
    );
  }
}
