import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../res/colors/colors.dart';
import '../controllers/graph_controller.dart';

class GraphView extends GetView<GraphController> {
  const GraphView({super.key});

  double _computePadding(double minValue, double maxValue) {
    final range = (maxValue - minValue).abs();
    if (range < 0.001) {
      return 1.0;
    }
    return (range * 0.1).clamp(0.2, range).toDouble();
  }

  double _computeYAxisInterval(
    double minY,
    double maxY, {
    required bool isMonthly,
  }) {
    final range = (maxY - minY).abs();
    if (range <= 0) {
      return 1.0;
    }

    final targetTicks = isMonthly ? 5.0 : 6.0;
    final roughInterval = range / targetTicks;
    final magnitude = math
        .pow(10, (math.log(roughInterval) / math.ln10).floor())
        .toDouble();
    final residual = roughInterval / magnitude;

    double niceMultiplier;
    if (residual <= 1) {
      niceMultiplier = 1;
    } else if (residual <= 2) {
      niceMultiplier = 2;
    } else if (residual <= 5) {
      niceMultiplier = 5;
    } else {
      niceMultiplier = 10;
    }

    return niceMultiplier * magnitude;
  }

  String _formatYAxisValue(double value, {required bool isMonthly}) {
    final absValue = value.abs();

    if (absValue >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (absValue >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    if (isMonthly || absValue >= 100) {
      return value.toStringAsFixed(0);
    }
    if (absValue >= 10) {
      return value.toStringAsFixed(1);
    }
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGround,
      appBar: AppBar(
        backgroundColor: const Color(0xffd4fcfd),
        title: Text(
          controller.graphTitle,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          // Popup menu in the AppBar for selecting period (Daily/Weekly/Monthly/Yearly)
          Obx(
            () => PopupMenuButton<String>(
              initialValue: controller.selectedPeriod.value,
              onSelected: (value) {
                controller.selectedPeriod.value = value;
                controller.graphData(type: value.toLowerCase());
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'Daily', child: Text('Daily')),
                PopupMenuItem(value: 'Weekly', child: Text('Weekly')),
                PopupMenuItem(value: 'Monthly', child: Text('Monthly')),
                PopupMenuItem(value: 'Yearly', child: Text('Yearly')),
              ],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Center(
                  child: Text(
                    controller.selectedPeriod.value,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value && !controller.hasLoaded.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value.isNotEmpty &&
            controller.sensorValues.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(controller.error.value, textAlign: TextAlign.center),
            ),
          );
        }

        if (controller.sensorValues.isEmpty) {
          return const Center(child: Text('No graph data available'));
        }

        final sensorValues = controller.sensorValues;
        final timeLabels = controller.timeLabels;
        final minValue = sensorValues.reduce((a, b) => a < b ? a : b);
        final maxValue = sensorValues.reduce((a, b) => a > b ? a : b);
        final padding = _computePadding(minValue, maxValue);
        final minY = minValue - padding;
        final maxY = maxValue + padding;
        final isMonthly = controller.selectedPeriod.value == 'Monthly';
        final isWeekly = controller.selectedPeriod.value == 'Weekly';
        final isYearly = controller.selectedPeriod.value == 'Yearly';
        final yInterval = _computeYAxisInterval(
          minY,
          maxY,
          isMonthly: isMonthly || isYearly,
        );

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Dropdown for Daily / Weekly / Monthly / Yearly
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DropdownButton<String>(
                    value: controller.selectedPeriod.value,
                    items: const [
                      DropdownMenuItem(value: 'Daily', child: Text('Daily')),
                      DropdownMenuItem(value: 'Weekly', child: Text('Weekly')),
                      DropdownMenuItem(
                        value: 'Monthly',
                        child: Text('Monthly'),
                      ),
                      DropdownMenuItem(value: 'Yearly', child: Text('Yearly')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        controller.selectedPeriod.value = value;
                        controller.graphData(
                          type: value.toLowerCase(),
                        ); // fetch new data
                      }
                    },
                    underline: Container(),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    dropdownColor: Colors.white,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Graph Section
              Expanded(
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      horizontalInterval: yInterval,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.grey.withOpacity(0.3),
                        strokeWidth: 1,
                      ),
                      getDrawingVerticalLine: (value) => FlLine(
                        color: Colors.grey.withOpacity(0.3),
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),

                      //  X-axis
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          interval: (isWeekly || isYearly)
                              ? 1
                              : (sensorValues.length / 5).floorToDouble().clamp(
                                  1,
                                  10,
                                ),
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt();
                            if (index >= 0 && index < timeLabels.length) {
                              final label = timeLabels[index].trim();
                              if (label.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return Transform.rotate(
                                angle: -0.7,
                                child: Text(
                                  label,
                                  style: const TextStyle(fontSize: 9),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),

                      // Y-axis
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: (isMonthly || isYearly) ? 56 : 48,
                          interval: yInterval,
                          getTitlesWidget: (value, meta) {
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              space: 6,
                              child: Text(
                                _formatYAxisValue(
                                  value,
                                  isMonthly: isMonthly || isYearly,
                                ),
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    minY: minY,
                    maxY: maxY,
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          sensorValues.length,
                          (i) => FlSpot(i.toDouble(), sensorValues[i]),
                        ),
                        isCurved: false,
                        color: Colors.blueAccent,
                        barWidth: 2,
                        dotData: const FlDotData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
