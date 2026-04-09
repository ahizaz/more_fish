// app/modules/cattle_index/views/cattle_live_monitoring_view.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../common_widgets/common_app_bar.dart';
import '../controllers/cattle_live_monitoring_controller.dart';
import '../controllers/cattle_header_controller.dart';

class CattleLiveMonitoringView extends StatelessWidget {
  const CattleLiveMonitoringView({super.key});

  @override
  Widget build(BuildContext context) {
    final header = Get.find<CattleHeaderController>();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(255, 255, 255, 255),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          body: Column(
            children: [
              Obx(
                () => CommonAppBar(
                  title: 'Cattle Care',
                  cityName: 'Dhaka',
                  date: header.formattedDate.value,
                  time: header.formattedTime.value,
                  temp: header.tempText.value,
                  humidity: header.humidityText.value,
                  logoAssetPath: 'assets/icons/dma_cattle_care.png',
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              Expanded(
                // Cattle Care live monitoring UI is visible even when a device isn't connected yet.
                // (No login-gating for now; backend/device integration will be added later.)
                child: Builder(
                  builder: (_) {
                    final ctrl = Get.put(CattleLiveMonitoringController());
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

  final CattleLiveMonitoringController controller;

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

      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header illustration under the Cattle Care app bar.
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
                children: [
                  _MetricCard(
                    iconAsset: 'assets/icons/cattle_nh3.png',
                    title: 'NH3',
                    value: live == null
                        ? '--'
                        : '${live.nh3MgL.toStringAsFixed(2)} mg/L',
                  ),
                  _MetricCard(
                    iconAsset: 'assets/icons/cattle_temperature.png',
                    title: 'Temperature',
                    value: live == null
                        ? '--'
                        : '${live.temperatureC.toStringAsFixed(2)} °C',
                  ),
                  _MetricCard(
                    iconAsset: 'assets/icons/cattle_humidity.png',
                    title: 'Humidity',
                    value: live == null ? '--' : '${live.humidityPct} %',
                  ),
                  _MetricCard(
                    iconAsset: 'assets/icons/cattle_voc.png',
                    title: 'Volatile Organic Compounds(VOCs)',
                    value: live == null
                        ? '--'
                        : '${live.vocMgM3.toStringAsFixed(2)} mg/m³',
                  ),
                  _MetricCard(
                    iconAsset: 'assets/icons/cattle_co2.png',
                    title: 'Carbon dioxide',
                    value: live == null ? '--' : '${live.co2Ppm} ppm',
                  ),
                  _MetricCard(
                    iconAsset: 'assets/icons/cattle_pm25.png',
                    title: 'PM 2.5',
                    value: live == null ? '--' : '${live.pm25UgM3} µg/m³',
                  ),
                  _MetricCard(
                    iconAsset: 'assets/icons/cattle_pm10.png',
                    title: 'PM 10',
                    value: live == null ? '--' : '${live.pm10UgM3} µg/m³',
                  ),
                  _MetricCard(
                    iconAsset: 'assets/icons/cattle_noise.png',
                    title: 'Noise level',
                    value: live == null ? '--' : '${live.noiseDb} dB',
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Temporary note until Cattle Care devices/backend are connected.
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 254, 254),
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

  final CattleLiveMonitoringController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = controller.devices;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 224, 230, 230),
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

class _DeviceHeader extends StatelessWidget {
  const _DeviceHeader({required this.deviceName, required this.timestampIso});

  final String deviceName;
  final String timestampIso;

  @override
  Widget build(BuildContext context) {
    String ts = timestampIso;
    try {
      final dt = DateTime.parse(timestampIso).toLocal();
      ts =
          '${dt.day.toString().padLeft(2, '0')} ${_monthName(dt.month)} ${dt.year}'
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {}

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
        Text(ts, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }

  static String _monthName(int m) {
    const names = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return (m >= 1 && m <= 12) ? names[m - 1] : '';
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    this.iconAsset,
    this.icon,
    required this.title,
    required this.value,
  });

  final String? iconAsset;
  final IconData? icon;
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
          color: const Color.fromARGB(255, 255, 255, 255),
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
            if (iconAsset != null)
              Image.asset(iconAsset!, height: 56, fit: BoxFit.contain)
            else if (icon != null)
              Icon(icon, size: 56, color: Colors.green)
            else
              const SizedBox(height: 56),
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
