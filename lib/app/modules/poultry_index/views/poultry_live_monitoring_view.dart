// app/modules/poultry_index/views/poultry_live_monitoring_view.dart
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../common_widgets/common_app_bar.dart';
import '../../../repo/poultry_live_models.dart';
import '../controllers/poultry_live_monitoring_controller.dart';
import '../controllers/poultry_header_controller.dart';

class PoultryLiveMonitoringView extends StatelessWidget {
  const PoultryLiveMonitoringView({super.key});

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
                // Poultry Pulse live monitoring UI is visible even when a device isn't connected yet.
                // (No login-gating for now; backend/device integration will be added later.)
                child: Builder(
                  builder: (_) {
                    final ctrl = Get.put(PoultryLiveMonitoringController());
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ctrl.refreshWhenPageVisible();
                    });
                    return _LoggedInDashboard(controller: ctrl);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoggedInDashboard extends StatelessWidget {
  const _LoggedInDashboard({required this.controller});

  final PoultryLiveMonitoringController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.liveData.value == null) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.error.value.isNotEmpty &&
          controller.liveData.value == null) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Failed to load: ${controller.error.value}'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: controller.loadDevices,
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      final live = controller.liveData.value;
      final dynamicMetrics = live?.metrics ?? const <PoultrySensorMetric>[];

      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header illustration under the Poultry Pulse app bar.
              // (Removed header illustration as requested.)
              const SizedBox(height: 10),
              _DeviceDropdown(controller: controller),
              const SizedBox(height: 10),
              if (live != null)
                _DeviceHeader(
                  deviceName: live.deviceId,
                  timestampIso: live.timestamp,
                ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: dynamicMetrics
                    .map(
                      (metric) => _MetricCard(
                        onTap: () => controller.openSensorGraph(metric),
                        iconAsset: _metricIconAsset(metric.name),
                        iconData: _dynamicMetricIcon(metric.name),
                        title: metric.title,
                        value: _formatDynamicMetricValue(metric),
                        borderColor: _metricBorderColor(metric.dangerStatus),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 14),
              _SwitchesSection(controller: controller, live: live),
              const SizedBox(height: 14),
              _DustParticlesSection(live: live),
              const SizedBox(height: 14),
              // Temporary note until Poultry Pulse devices/backend are connected.
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffdbcc68),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Note: The parameters are changeable according to installation of device.',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              if (controller.error.value.isNotEmpty)
                Text(
                  'Last error: ${controller.error.value}',
                  style: const TextStyle(color: Colors.redAccent),
                ),
            ],
          ),
        ),
      );
    });
  }
}

class _DeviceDropdown extends StatelessWidget {
  const _DeviceDropdown({required this.controller});

  final PoultryLiveMonitoringController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = controller.devices;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 234, 240, 183),
          borderRadius: BorderRadius.circular(14),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: controller.selectedDeviceId.value.isEmpty
                ? null
                : controller.selectedDeviceId.value,
            hint: const Text('Select device'),
            icon: const Icon(Icons.keyboard_arrow_down),
            items: items
                .map(
                  (d) => DropdownMenuItem<String>(
                    value: d.id,
                    child: Text(
                      d.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) controller.onDeviceChanged(v);
            },
          ),
        ),
      );
    });
  }
}

// class _DeviceHeader extends StatelessWidget {
//   const _DeviceHeader({required this.deviceName, required this.timestampIso});

//   final String deviceName;
//   final String timestampIso;

//   @override
//   Widget build(BuildContext context) {
//     String ts = timestampIso;

//     try {
//       // ✅ Existing parsed time + 6 hours added
//       final dt = DateTime.parse(timestampIso).toLocal().add(
//         const Duration(hours: 6),
//       );

//       ts =
//           '${dt.day.toString().padLeft(2, '0')} ${_monthName(dt.month)} ${dt.year}   '
//           '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
//     } catch (_) {}

//     return Row(
//       children: [
//         const Icon(Icons.circle, color: Colors.green, size: 12),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Text(
//             deviceName,
//             style: const TextStyle(fontWeight: FontWeight.w600),
//           ),
//         ),
//         Text(
//           ts,
//           style: const TextStyle(
//             fontSize: 12,
//             color: Colors.black54,
//           ),
//         ),
//       ],
//     );
//   }

//   static String _monthName(int m) {
//     const names = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'May',
//       'Jun',
//       'Jul',
//       'Aug',
//       'Sep',
//       'Oct',
//       'Nov',
//       'Dec',
//     ];
//     return (m >= 1 && m <= 12) ? names[m - 1] : '';
//   }
// }
class _DeviceHeader extends StatelessWidget {
  const _DeviceHeader({required this.deviceName, required this.timestampIso});

  final String deviceName;
  final String timestampIso;

  @override
  Widget build(BuildContext context) {
    String ts = timestampIso;

    try {
      // ✅ API format parse + 6 hours add
      final parsed = DateFormat(
        'dd MMM yyyy hh:mm a',
      ).parse(timestampIso);

      final dt = parsed.add(const Duration(hours: 6));

      ts =
          '${dt.day.toString().padLeft(2, '0')} ${_monthName(dt.month)} ${dt.year}   '
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      debugPrint('Time parse error: $e');
    }

    return Row(
      children: [
        const Icon(Icons.circle, color: Colors.green, size: 12),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            deviceName,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          ts,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  static String _monthName(int m) {
    const names = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return (m >= 1 && m <= 12) ? names[m - 1] : '';
  }
}
class _DustParticlesSection extends StatelessWidget {
  const _DustParticlesSection({required this.live});

  final PoultryLiveData? live;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xfff3f4c5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Center(
              child: Text(
                'Dust particles',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ),

          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.2,
            children: [
              _DustParticleCard(
                iconAsset: 'assets/icons/poultry_pm1_sensor.png',
                sizeLabel: 'Size 1.0',
                value: live == null ? '--' : '${live!.pm1UgM3} µg/m³',
              ),
              _DustParticleCard(
                iconAsset: 'assets/icons/poultry_pm25.png',
                sizeLabel: 'Size 2.5',
                value: live == null ? '--' : '${live!.pm25UgM3} µg/m³',
              ),
              _DustParticleCard(
                iconAsset: 'assets/icons/poultry_pm4_sensor.png',
                sizeLabel: 'Size 4.0',
                value: live == null ? '--' : '${live!.pm4UgM3} µg/m³',
              ),
              _DustParticleCard(
                iconAsset: 'assets/icons/poultry_pm10.png',
                sizeLabel: 'Size 10',
                value: live == null ? '--' : '${live!.pm10UgM3} µg/m³',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SwitchesSection extends StatelessWidget {
  const _SwitchesSection({required this.controller, required this.live});

  final PoultryLiveMonitoringController controller;
  final PoultryLiveData? live;

  @override
  Widget build(BuildContext context) {
    final switches = live?.switches ?? const <PoultrySwitch>[];
    if (switches.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xfff3f4c5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              'Switch Controls',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 6.0;
              final itemWidth = (constraints.maxWidth - spacing) / 2;

              return Wrap(
                spacing: spacing,
                runSpacing: 6,
                children: switches
                    .map(
                      (item) => SizedBox(
                        width: itemWidth,
                        child: _SwitchCard(controller: controller, item: item),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SwitchCard extends StatelessWidget {
  const _SwitchCard({required this.controller, required this.item});

  final PoultryLiveMonitoringController controller;
  final PoultrySwitch item;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final busy = controller.switchBusy[item.switchId] ?? false;
      final value = controller.switchUiState[item.switchId] ?? item.isOn;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 216, 226, 180),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                item.switchName.isEmpty ? item.switchId : item.switchName,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Switch(
              value: value,
              onChanged: (!item.isActive || busy)
                  ? null
                  : (v) {
                      controller.onSwitchChanged(item: item, nextValue: v);
                    },
            ),
          ],
        ),
      );
    });
  }
}

class _DustParticleCard extends StatelessWidget {
  const _DustParticleCard({
    required this.iconAsset,
    required this.sizeLabel,
    required this.value,
  });

  final String iconAsset;
  final String sizeLabel;
  final String value;

  @override
  Widget build(BuildContext context) {
    final w = (MediaQuery.of(context).size.width - 14 * 2 - 12 - 12 * 2) / 2;
    return SizedBox(
      width: w,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 216, 226, 180),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(iconAsset, height: 40, fit: BoxFit.contain),
            const SizedBox(height: 6),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sizeLabel,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    this.onTap,
    this.iconAsset,
    this.iconData,
    required this.title,
    required this.value,
    required this.borderColor,
  });

  final VoidCallback? onTap;
  final String? iconAsset;
  final IconData? iconData;
  final String title;
  final String value;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final w = (MediaQuery.of(context).size.width - 14 * 2 - 12) / 2;
    return SizedBox(
      width: w,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xfff3f4c5),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: borderColor, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (iconAsset != null)
                  Image.asset(iconAsset!, height: 56, fit: BoxFit.contain)
                else
                  Icon(
                    iconData ?? Icons.sensors,
                    size: 42,
                    color: Colors.black87,
                  ),
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
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _formatDynamicMetricValue(PoultrySensorMetric metric) {
  final unit = metric.unit.trim();
  final value = metric.value;
  final formatted = value % 1 == 0
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(2);
  if (unit.isEmpty || unit.toLowerCase() == 'null') {
    return formatted;
  }
  return '$formatted $unit';
}

Color _metricBorderColor(String status) {
  final normalized = status.trim().toLowerCase();
  if (normalized == 'perfect') {
    return Colors.green;
  }
  // Requirements: danger and invalid should be red.
  return Colors.red;
}

IconData _dynamicMetricIcon(String name) {
  switch (name) {
    case 'light_intensity':
      return Icons.light_mode;
    case 'pm1':
    case 'pm25':
    case 'pm4':
    case 'pm10':
      return Icons.blur_on;
    default:
      return Icons.sensors;
  }
}

String? _metricIconAsset(String name) {
  switch (name) {
    case 'aqi':
      return 'assets/icons/poultry_co.png';
    case 'nh3_gas':
      return 'assets/icons/poultry_nh3.png';
    case 'temperature':
      return 'assets/icons/poultry_temperature.png';
    case 'humidity':
      return 'assets/icons/poultry_humidity.png';
    case 'co2':
      return 'assets/icons/poultry_co2.png';
    case 'tvoc':
      return 'assets/icons/cattle_voc.png';
    case 'sound_db':
      return 'assets/icons/poultry_noise.png';
    case 'methane_ppm':
      return 'assets/icons/poultry_ch4.png';
    default:
      return null;
  }
}
