import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common_widgets/common_app_bar.dart';
import '../controllers/poultry_header_controller.dart';
import '../controllers/poultry_notifications_controller.dart';

class PoultryNotificationsView extends GetView<PoultryNotificationsController> {
  const PoultryNotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final header = Get.find<PoultryHeaderController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xffdbcc68),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xffebffff),
          body: Column(
            children: [
              Obx(
                () => CommonAppBar(
                  title: 'Poultry Care',
                  cityName: 'Dhaka',
                  date: header.formattedDate.value,
                  time: header.formattedTime.value,
                  temp: header.tempText.value,
                  humidity: header.humidityText.value,
                  logoAssetPath: 'assets/icons/dma_poultry_pulse.png',
                  backgroundColor: const Color(0xffdbcc68),
                ),
              ),
              Expanded(
                child: Obx(() {
                  if (!controller.hasToken.value) {
                    return const Center(
                      child: Text(
                        'নোটিফিকেশন দেখতে লগইন করুন',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }

                  if (controller.isLoading.value &&
                      controller.notifications.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.error.value.isNotEmpty &&
                      controller.notifications.isEmpty) {
                    return Center(
                      child: Text(
                        controller.error.value,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }

                  if (controller.notifications.isEmpty) {
                    return const Center(
                      child: Text(
                        'এখনও কোনো নোটিফিকেশন নেই',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () =>
                        controller.fetchNotifications(showLoader: false),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      itemCount: controller.notifications.length,
                      itemBuilder: (context, index) {
                        final item = controller.notifications[index];
                        final translated = controller.toBanglaMessage(
                          item.message,
                        );

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: _decoration(),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.white, Color(0xffebffff)],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item.notifiedAt != null
                                          ? DateFormat(
                                              'dd:MM:yyyy',
                                            ).format(item.notifiedAt!.toLocal())
                                          : '--:--:----',
                                      style: const TextStyle(
                                        color: Color(0xff0d66a8),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      item.notifiedAt != null
                                          ? DateFormat(
                                              'hh:mm a',
                                            ).format(item.notifiedAt!.toLocal())
                                          : '--:--',
                                      style: const TextStyle(
                                        color: Color(0xff0d66a8),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      _UrgencyChip(urgency: item.urgency),
                                      Text(
                                        item.sensorName,
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  translated,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.justify,
                                  maxLines: 20,
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _decoration() => BoxDecoration(
    gradient: const LinearGradient(
      colors: [Color(0xfffbffff), Colors.white],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
        color: Colors.blueGrey.withOpacity(0.5),
        spreadRadius: 1,
        blurRadius: 1,
        offset: const Offset(.2, .2),
      ),
    ],
  );
}

class _UrgencyChip extends StatelessWidget {
  const _UrgencyChip({required this.urgency});

  final String urgency;

  @override
  Widget build(BuildContext context) {
    final normalized = urgency.toUpperCase().trim();
    final isWarning = normalized == 'WARNING';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isWarning ? const Color(0xfffff2f2) : const Color(0xffecf8ff),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isWarning ? const Color(0xffdb5a5a) : const Color(0xff0d66a8),
        ),
      ),
      child: Text(
        normalized.isEmpty ? 'INFO' : normalized,
        style: TextStyle(
          color: isWarning ? const Color(0xffa13434) : const Color(0xff0d66a8),
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
