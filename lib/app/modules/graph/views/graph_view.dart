import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../res/colors/colors.dart';
import '../controllers/graph_controller.dart';

class GraphView extends GetView<GraphController> {
  const GraphView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.graphData(); // Load data initially

    return Scaffold(
      backgroundColor: AppColors.backGround,
      appBar: AppBar(
        backgroundColor: const Color(0xffd4fcfd),
        title: Text(
          '${Get.arguments["sensorId"] == 1 ? "pH" :
          Get.arguments["sensorId"] == 2 ? "Temperature" :
          Get.arguments["sensorId"] == 3 ? "DO" :
          Get.arguments["sensorId"] == 4 ? "TDS" :
          Get.arguments["sensorId"] == 5 ? "NH3" :
          Get.arguments["sensorId"] == 6 ? "Salinity" : null}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Obx(() {
        if (controller.sensorValues.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final sensorValues = controller.sensorValues;
        final timeLabels = controller.timeLabels;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Dropdown for Daily / Weekly / Monthly
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DropdownButton<String>(
                    value: controller.selectedPeriod.value,
                    items: const [
                      DropdownMenuItem(value: 'Daily', child: Text('Daily')),
                      DropdownMenuItem(value: 'Weekly', child: Text('Weekly')),
                      DropdownMenuItem(value: 'Monthly', child: Text('Monthly')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        controller.sensorValues.clear();
                        controller.selectedPeriod.value = value;
                        controller.graphData(type: value.toLowerCase()); // fetch new data
                      }
                    },
                    underline: Container(),
                    style: const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
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
                      horizontalInterval: 0.05,
                      getDrawingHorizontalLine: (value) =>
                          FlLine(color: Colors.grey.withOpacity(0.3), strokeWidth: 1),
                      getDrawingVerticalLine: (value) =>
                          FlLine(color: Colors.grey.withOpacity(0.3), strokeWidth: 1),
                    ),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

                      //  X-axis
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          interval: (sensorValues.length / 5)
                              .floorToDouble()
                              .clamp(1, 10),
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt();
                            if (index >= 0 && index < timeLabels.length) {
                              return Transform.rotate(
                                angle: -0.7,
                                child: Text(
                                  timeLabels[index],
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
                          reservedSize: 40,
                          interval: .30,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toStringAsFixed(2),
                              style: const TextStyle(fontSize: 10),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    minY: sensorValues.reduce((a, b) => a < b ? a : b) - 0.20,
                    maxY: sensorValues.reduce((a, b) => a > b ? a : b) + 0.20,
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
