// app/common_widgets/common_app_bar.dart
/*import 'package:flutter/material.dart';

import 'common_text.dart';


class CommonAppBar extends StatelessWidget{

  CommonAppBar({required this.title, required this.cityName, this.date, this.time, this.humidity, this.temp, this.actions});

  final String title;
  final String cityName;
  final String? date;
  final String? time;
  final String? temp;
  final String? humidity;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 0, left: 12, right: 12),
      height: 75,
      decoration: BoxDecoration(
        color: Color(0xffd4fcfd),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      ClipRRect(
                        child: Image.asset(
                          "assets/icons/logo_trade_mark.jpg",
                          height: 60,
                          width: 60,
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ],
                  ),
                  SizedBox(width: 8,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                date??"",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                time??"",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 16,),
                          Container(
                            height: 30,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(100)
                            ),
                            child: Center( 
                              child: Text(
                                "B",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),


                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, color: Colors.green, size: 16,),
                          SizedBox(width: 2,),
                          CommonText(
                            cityName,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              CommonText(
                                'Air Temp',
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                              CommonText(
                                temp??'',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                          SizedBox(width: 8,),
                          Column(
                            children: [
                              CommonText(
                                'Humidity',
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                              CommonText(
                                humidity??'',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),

                        ],
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }


}*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'common_text.dart';

class CommonAppBar extends StatelessWidget {
  const CommonAppBar({
    super.key,
    required this.title,
    required this.cityName,
    this.logoAssetPath,
    this.backgroundColor,
    this.date,
    this.time,
    this.humidity,
    this.temp,
    this.actions,
  });

  final String title;
  final String cityName;
  final String? logoAssetPath;
  final Color? backgroundColor;
  final String? date;
  final String? time;
  final String? temp;
  final String? humidity;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 80,
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xffd4fcfd),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 🔹 Left side: Logo + Title + Date/Time + Language button
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    logoAssetPath ?? "assets/icons/logo_trade_mark.jpg",
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                date ?? "",
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                time ?? "",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          InkWell(
                            onTap: () {
                              Locale currentLocale =
                                  Get.locale ?? const Locale('en', 'US');
                              if (currentLocale.languageCode == 'en') {
                                Get.updateLocale(
                                  const Locale('bn', 'BD'),
                                ); // switch to Bangla
                              } else {
                                Get.updateLocale(
                                  const Locale('en', 'US'),
                                ); // switch to English
                              }
                            },
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              height: 28,
                              width: 55,
                              decoration: BoxDecoration(
                                color: Color(0xff8beeef),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: Text(
                                  (Get.locale?.languageCode ?? 'en') == 'en'
                                      ? 'বাংলা'
                                      : 'Eng',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 🔹 Right side: Weather info + optional actions
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 2),
                      CommonText(
                        cityName,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Column(
                        children: [
                          CommonText(
                            'Air Temp',
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                          CommonText(
                            temp ?? '',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Column(
                        children: [
                          CommonText(
                            'Humidity',
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                          CommonText(
                            humidity ?? '',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              //if (actions != null) ...actions!,
            ],
          ),
        ],
      ),
    );
  }
}
