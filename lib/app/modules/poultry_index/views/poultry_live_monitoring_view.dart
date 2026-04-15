// app/modules/poultry_index/views/poultry_live_monitoring_view.dart
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
                children: [
                  _MetricCard(
                    iconAsset: 'assets/icons/poultry_co.png',
                    title: 'Air Quality Index (AQI)',
                    value: live == null
                        ? '--'
                        : (live.aqi ?? 0.0).toStringAsFixed(1),
                  ),
                  _MetricCard(
                    iconAsset: 'assets/icons/poultry_nh3.png',
                    title: 'Ammonia (NH3)',
                    value: live == null
                        ? '--'
                        : '${live.nh3MgL.toStringAsFixed(2)} mg/L',
                  ),
                  _MetricCard(
                    iconAsset: 'assets/icons/poultry_temperature.png',
                    title: 'Temperature',
                    value: live == null
                        ? '--'
                        : '${live.temperatureC.toStringAsFixed(2)} °C',
                  ),
                  // _MetricCard(
                  //   iconAsset: 'assets/icons/poultry_temperature.png',
                  //   title: 'Reference temperature',
                  //   value: live == null
                  //       ? '--'
                  //       : '${(live.refTemperatureC ?? 0.0).toStringAsFixed(2)} °C',
                  // ),
                  _MetricCard(
                    iconAsset: 'assets/icons/poultry_humidity.png',
                    title: 'Humidity',
                    value: live == null ? '--' : '${live.humidityPct} %',
                  ),
                  _MetricCard(
                    iconAsset: 'assets/icons/poultry_co2.png',
                    title: 'Carbon dioxide',
                    value: live == null ? '--' : '${live.co2Ppm} ppm',
                  ),
                  _MetricCard(
                    iconAsset: 'assets/icons/cattle_voc.png',
                    title: 'TVOC',
                    value: live == null
                        ? '--'
                        : '${live.vocMgM3.toStringAsFixed(2)} mg/m³',
                  ),
                  _MetricCard(
                    iconAsset: 'assets/icons/poultry_noise.png',
                    title: 'Sound',
                    value: live == null ? '--' : '${live.noiseDb} dB',
                  ),
                  _MetricCard(
                    iconAsset: 'assets/icons/poultry_ch4.png',
                    title: 'Methane (CH₄)',
                    value: live == null ? '--' : '${live.ch4Ppm} ppm',
                  ),
                ],
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
          '${dt.day.toString().padLeft(2, '0')} ${_monthName(dt.month)} ${dt.year}   '
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
          ...switches.map(
            (item) => Padding(
              padding: const EdgeInsets.only(top: 6),
              child: _SwitchCard(controller: controller, item: item),
            ),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(iconAsset, height: 56, fit: BoxFit.contain), //
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
