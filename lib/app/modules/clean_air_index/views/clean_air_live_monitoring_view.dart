import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../common_widgets/common_app_bar.dart';
import '../../../common_widgets/common_container.dart';
import '../../../common_widgets/common_text.dart';
import '../../../common_widgets/safe_network_image.dart';
import '../../../routes/app_pages.dart';
import '../../../service/service.dart';
import '../controllers/clean_air_header_controller.dart';
import '../controllers/clean_air_live_monitoring_controller.dart';

class CleanAirLiveMonitoringView
    extends GetView<CleanAirLiveMonitoringController> {
  const CleanAirLiveMonitoringView({super.key});

  String _formatSensorValue({
    required String? sensorName,
    required String? rawValue,
  }) {
    final parsedValue = double.tryParse(rawValue ?? '');
    if (parsedValue == null) return '0';

    final normalizedSensorName = sensorName?.trim().toUpperCase();
    final displayValue = normalizedSensorName == 'DO'
        ? parsedValue.clamp(1.62, 16.0).toDouble()
        : parsedValue;

    return displayValue.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final header = Get.find<CleanAirHeaderController>();

    Future<void> handlePullToRefresh() async {
      try {
        final fetch = controller.pondData(id: controller.selectedAstId.value);
        await fetch.timeout(const Duration(seconds: 2), onTimeout: () {});
      } catch (_) {
        // keep refresh lightweight
      }
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xffd4fcfd),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) {
            final box = context.findRenderObject() as RenderBox?;
            final localPosition = box?.globalToLocal(details.globalPosition);

            if (localPosition != null &&
                localPosition.dy > MediaQuery.of(context).size.height * 0.4) {
              return;
            }

            if (controller.commandInProgress.value) {
              controller.commandInProgress.value = false;
              debugPrint('[ui] User dismissed loading via tap');
              return;
            }

            controller.pondDataResponse.value = null;
            controller.pondList();
            controller.sensorList();
            controller.CompanyList();
          },
          child: Column(
            children: [
              const SizedBox(height: 40),
              Obx(
                () => CommonAppBar(
                  title: 'Pharma Care',
                  cityName: 'Dhaka',
                  date: header.formattedDate.value,
                  time: header.formattedTime.value,
                  temp: header.tempText.value,
                  humidity: header.humidityText.value,
                  logoAssetPath: 'assets/icons/dma_pharmaceutical.png',
                  backgroundColor: const Color(0xff4F84B5),
                  textColor: Colors.white,
                  iconColor: Colors.white,
                ),
              ),
              Expanded(
                child: Obx(() {
                  final data = controller.pondDataResponse.value;
                  return data == null
                      ? const Center(child: Text('Waiting for live data...'))
                      : Column(
                          children: [
                            Center(
                              child: Obx(() {
                                final pondList =
                                    controller.pondListResponse.value?.data ??
                                    [];

                                if (pondList.isEmpty) {
                                  return const SizedBox();
                                }

                                final astNameIdList = pondList
                                    .map(
                                      (pond) => {
                                        'astName': pond.astName,
                                        'id': pond.id,
                                      },
                                    )
                                    .toList();

                                final astNames = astNameIdList
                                    .map((e) => e['astName'] as String)
                                    .toList();

                                if (!astNames.contains(
                                  controller.selectedAstName.value,
                                )) {
                                  controller.selectedAstName.value =
                                      astNames.first;
                                }

                                return Column(
                                  children: [
                                    const SizedBox(height: 12),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          value:
                                              controller.selectedAstName.value,
                                          onChanged: (String? newValue) {
                                            if (newValue != null) {
                                              final selectedItem = astNameIdList
                                                  .firstWhere(
                                                    (e) =>
                                                        e['astName'] ==
                                                        newValue,
                                                  );
                                              final selectedId =
                                                  selectedItem['id'];
                                              controller.selectAsset(
                                                name: newValue,
                                                id: selectedId as int,
                                              );
                                            }
                                          },
                                          items: astNames
                                              .map<DropdownMenuItem<String>>((
                                                String value,
                                              ) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: CommonText(
                                                    value,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                );
                                              })
                                              .toList(),
                                          buttonStyleData: ButtonStyleData(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            height: 60,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                            maxHeight: 300,
                                            direction:
                                                DropdownDirection.textDirection,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          iconStyleData: const IconStyleData(
                                            icon: Icon(
                                              Icons.arrow_drop_down,
                                              size: 35,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                            Expanded(
                              child: RefreshIndicator(
                                onRefresh: handlePullToRefresh,
                                displacement: 40,
                                color: Theme.of(context).primaryColor,
                                child: SingleChildScrollView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 12),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    data
                                                                .data
                                                                .devices[0]
                                                                .deviceStatus ==
                                                            'Online'
                                                        ? Container(
                                                            height: 16,
                                                            width: 16,
                                                            decoration: BoxDecoration(
                                                              color:
                                                                  const Color(
                                                                    0xff00cc00,
                                                                  ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    100,
                                                                  ),
                                                            ),
                                                          )
                                                        : Container(
                                                            height: 18,
                                                            width: 18,
                                                            decoration:
                                                                BoxDecoration(
                                                                  color: Colors
                                                                      .red,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        100,
                                                                      ),
                                                                ),
                                                          ),
                                                    const SizedBox(width: 6),
                                                    Expanded(
                                                      child: CommonText(
                                                        data
                                                            .data
                                                            .devices[0]
                                                            .deviceName,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        color: const Color(
                                                          0xff0370c3,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                  ],
                                                ),
                                              ),
                                              CommonText(
                                                data
                                                    .data
                                                    .devices[0]
                                                    .sensors[0]
                                                    .dataTime,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                textAlign: TextAlign.center,
                                                color: const Color(0xff0370c3),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          height: 2,
                                          color: const Color(0xff0370c3),
                                        ),
                                        Obx(() {
                                          return GridView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 16,
                                            ),
                                            itemCount: controller
                                                .pondDataResponse
                                                .value
                                                ?.data
                                                .devices[0]
                                                .sensors
                                                .length,
                                            shrinkWrap: true,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  crossAxisSpacing: 10,
                                                  mainAxisSpacing: 10,
                                                  childAspectRatio: 1.3,
                                                ),
                                            itemBuilder: (context, index) {
                                              final sensorData = controller
                                                  .pondDataResponse
                                                  .value
                                                  ?.data
                                                  .devices[0]
                                                  .sensors[index];

                                              for (var i
                                                  in controller
                                                      .companyListResponse
                                                      .value!
                                                      .data!) {
                                                if (i.name ==
                                                    controller
                                                        .pondListResponse
                                                        .value
                                                        ?.data[0]
                                                        .astName) {
                                                  controller.comId.value =
                                                      i.id!;
                                                  break;
                                                }
                                              }

                                              return InkWell(
                                                onTap: () {
                                                  final passedAssetId =
                                                      controller
                                                          .pondDataResponse
                                                          .value
                                                          ?.data
                                                          .assetId ??
                                                      controller
                                                          .selectedAstId
                                                          .value
                                                          .toString();

                                                  String? mappedSensorIdString;
                                                  try {
                                                    final sensorName =
                                                        (sensorData?.sensorName ??
                                                                '')
                                                            .toString()
                                                            .toLowerCase();
                                                    final mapped = controller
                                                        .sensorListResponse
                                                        .value
                                                        ?.data
                                                        .firstWhere(
                                                          (s) =>
                                                              s.sensorSensorName
                                                                  .toString()
                                                                  .toLowerCase() ==
                                                              sensorName,
                                                        );
                                                    if (mapped != null) {
                                                      mappedSensorIdString =
                                                          mapped.sensorId
                                                              .toString();
                                                    }
                                                  } catch (_) {
                                                    mappedSensorIdString = null;
                                                  }

                                                  final sensorIdForGraph =
                                                      mappedSensorIdString ??
                                                      sensorData?.sensorId;

                                                  Get.toNamed(
                                                    Routes.GRAPH,
                                                    arguments: {
                                                      'flow': 'pharma',
                                                      'comId': controller
                                                          .comId
                                                          .value,
                                                      'assetId': passedAssetId,
                                                      'sensorId':
                                                          sensorIdForGraph,
                                                      'type': 'daily',
                                                    },
                                                  );
                                                },
                                                child: CommonContainer(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 4,
                                                      ),
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: SafeNetworkImage(
                                                          url: '${ApiService.baseUrl}/${controller.pondDataResponse.value?.data.devices[0].sensors[index].sensorIcon}',
                                                          height: 40,
                                                          width: 40,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                CommonText(
                                                                  sensorData?.dangerStatus ==
                                                                          'invalid'
                                                                      ? 'No Data'
                                                                      : _formatSensorValue(
                                                                          sensorName:
                                                                              sensorData?.sensorName,
                                                                          rawValue:
                                                                              sensorData?.lastValue,
                                                                        ),
                                                                  fontSize:
                                                                      sensorData
                                                                              ?.dangerStatus ==
                                                                          'invalid'
                                                                      ? 16
                                                                      : 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      sensorData
                                                                              ?.dangerStatus ==
                                                                          'perfect'
                                                                      ? const Color(
                                                                          0xff00cc00,
                                                                        )
                                                                      : Colors
                                                                            .red,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                                const SizedBox(
                                                                  width: 3,
                                                                ),
                                                                CommonText(
                                                                  sensorData?.dangerStatus ==
                                                                          'invalid'
                                                                      ? ''
                                                                      : '${sensorData?.sensorUnit}',
                                                                  fontSize: 20,
                                                                  color:
                                                                      sensorData
                                                                              ?.dangerStatus ==
                                                                          'perfect'
                                                                      ? const Color(
                                                                          0xff00cc00,
                                                                        )
                                                                      : Colors
                                                                            .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ],
                                                            ),
                                                            CommonText(
                                                              '${sensorData?.sensorName}',
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }),
                                        const SizedBox(height: 16),
                                        Obx(() {
                                          final aerators =
                                              controller
                                                  .pondDataResponse
                                                  .value
                                                  ?.data
                                                  .devices[0]
                                                  .aerators ??
                                              [];
                                          return ListView.builder(
                                            itemCount: aerators.length,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (BuildContext context, int index) {
                                              final aerator = aerators[index];
                                              final bool isOnline =
                                                  aerator.isOnline == true;

                                              return CommonContainer(
                                                margin: const EdgeInsets.only(
                                                  left: 14,
                                                  right: 14,
                                                  bottom: 16,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 6,
                                                    ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 18,
                                                          height: 18,
                                                          decoration: BoxDecoration(
                                                            color: isOnline
                                                                ? const Color(
                                                                    0xff2fbf71,
                                                                  )
                                                                : const Color(
                                                                    0xffe74c3c,
                                                                  ),
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 12,
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              MediaQuery.of(
                                                                context,
                                                              ).size.width -
                                                              220,
                                                          child: CommonText(
                                                            aerator.aeratorName,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Obx(() {
                                                      final bool
                                                      switchValue = controller
                                                          .aeratorSwitchValueFor(
                                                            aerator.aeratorPk,
                                                            fallback:
                                                                aerator
                                                                    .isRunning ==
                                                                true,
                                                          );

                                                      return Switch(
                                                        key: ValueKey(
                                                          aerator.aeratorPk,
                                                        ),
                                                        value: switchValue,
                                                        onChanged:
                                                            !isOnline ||
                                                                controller
                                                                    .isAeratorBusy(
                                                                      aerator
                                                                          .aeratorPk,
                                                                    )
                                                            ? null
                                                            : (bool value) {
                                                                controller.aeratorCommand(
                                                                  id: aerator
                                                                      .aeratorId,
                                                                  command: value
                                                                      ? 1
                                                                      : 0,
                                                                  index: index,
                                                                  isOnline:
                                                                      isOnline,
                                                                  aeratorPk: aerator
                                                                      .aeratorPk,
                                                                );
                                                              },
                                                        thumbColor: MaterialStateProperty.resolveWith<Color>((
                                                          states,
                                                        ) {
                                                          final isDisabled =
                                                              states.contains(
                                                                MaterialState
                                                                    .disabled,
                                                              );

                                                          if (isDisabled) {
                                                            return switchValue
                                                                ? const Color(
                                                                    0xff93b39f,
                                                                  )
                                                                : const Color(
                                                                    0xffb59a97,
                                                                  );
                                                          }

                                                          return switchValue
                                                              ? Colors.green
                                                              : Colors.red;
                                                        }),
                                                        trackColor: MaterialStateProperty.resolveWith<Color>((
                                                          states,
                                                        ) {
                                                          final isDisabled =
                                                              states.contains(
                                                                MaterialState
                                                                    .disabled,
                                                              );

                                                          if (isDisabled) {
                                                            return switchValue
                                                                ? const Color(
                                                                    0xffc6d8cd,
                                                                  )
                                                                : const Color(
                                                                    0xffdbc7c4,
                                                                  );
                                                          }

                                                          return switchValue
                                                              ? Colors.green
                                                                    .withOpacity(
                                                                      0.45,
                                                                    )
                                                              : Colors.red
                                                                    .withOpacity(
                                                                      0.45,
                                                                    );
                                                        }),
                                                      );
                                                    }),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        }),
                                        controller.pondDataResponse.value ==
                                                null
                                            ? const SizedBox()
                                            : Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 14,
                                                      vertical: 12,
                                                    ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: List.generate(
                                                    controller
                                                        .pondDataResponse
                                                        .value!
                                                        .data
                                                        .devices[0]
                                                        .sensors
                                                        .length,
                                                    (index) {
                                                      final sensor = controller
                                                          .pondDataResponse
                                                          .value!
                                                          .data
                                                          .devices[0]
                                                          .sensors[index];
                                                      final data =
                                                          sensor.sensorName;
                                                      final value =
                                                          double.tryParse(
                                                            sensor.lastValue
                                                                .toString(),
                                                          ) ??
                                                          0.0;

                                                      if (data == 'pH' &&
                                                          value < 7) {
                                                        return const Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            CommonText(
                                                              'Warning: ',
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            Expanded(
                                                              child: CommonText(
                                                                'Apply lime.',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                maxLines: 3,
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                      if (data == 'pH' &&
                                                          value > 8.5) {
                                                        return const Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            CommonText(
                                                              'Warning: ',
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            Expanded(
                                                              child: CommonText(
                                                                'Add TSP, gypsum, vinegar, or deep tube-well water.',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                maxLines: 3,
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                      if (data == 'DO' &&
                                                          value < 3) {
                                                        return const Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            CommonText(
                                                              'Warning: ',
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            Expanded(
                                                              child: CommonText(
                                                                'Run the aerator or add deep tube-well water.',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                maxLines: 3,
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                      if (data == 'TDS' &&
                                                          value < 100) {
                                                        return const Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            CommonText(
                                                              'Warning: ',
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            Expanded(
                                                              child: CommonText(
                                                                'Add lime, gypsum, or salt.',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                maxLines: 3,
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                      if (data == 'TDS' &&
                                                          value > 1000) {
                                                        return const Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            CommonText(
                                                              'Warning: ',
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            Expanded(
                                                              child: CommonText(
                                                                'Add deep tube-well water.',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                maxLines: 3,
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                      if (data ==
                                                              'Temperature' &&
                                                          value > 34) {
                                                        return const Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            CommonText(
                                                              'Warning: ',
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            Expanded(
                                                              child: CommonText(
                                                                'Add deep tube-well water.',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                maxLines: 3,
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                      if (data == 'NH3' &&
                                                          value > 0.5) {
                                                        return const Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            CommonText(
                                                              'Warning: ',
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            Expanded(
                                                              child: CommonText(
                                                                'Use a net or drag net.',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                maxLines: 3,
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      } else {
                                                        return const CommonText(
                                                          '',
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.iconAsset,
    required this.title,
    required this.value,
  });

  final String iconAsset;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final w = (MediaQuery.of(context).size.width - 14 * 2 - 12) / 2;
    return SizedBox(
      width: w,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 207, 255, 197),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(iconAsset, height: 56, fit: BoxFit.contain),
            const SizedBox(height: 6),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
