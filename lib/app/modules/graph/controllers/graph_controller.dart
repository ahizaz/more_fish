import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:more_fish/app/service/local_storage.dart';
import 'package:more_fish/app/response/graph_response.dart';
import '../../../repo/devices_repo.dart';
import '../../../service/service.dart';

class GraphController extends GetxController {
  static const String _fallbackPoultryToken =
      '21067c389d5d27d6ecfd22dc13e0ccb792714ad6';

  DevicesRepository devicesRepository = DevicesRepository();
  final graphResponse = Rxn<GraphResponse>();

  var sensorValues = <double>[].obs;
  var timeLabels = <String>[].obs;
  final isLoading = false.obs;
  final hasLoaded = false.obs;
  final error = ''.obs;

  var comId;
  var assetId;
  var sensorId;
  var type;
  int? farmId;
  String sensorKey = '';
  String sensorName = '';
  String sensorUnit = '';
  bool isPoultryFlow = false;

  var selectedPeriod = 'Daily'.obs;

  String get graphTitle {
    if (isPoultryFlow) {
      if (sensorName.trim().isNotEmpty) {
        return sensorName;
      }
      if (sensorKey.trim().isNotEmpty) {
        return _toTitleCase(sensorKey);
      }
      return 'Graph';
    }

    if (sensorId == 1) return 'pH';
    if (sensorId == 2) return 'Temperature';
    if (sensorId == 3) return 'DO';
    if (sensorId == 4) return 'TDS';
    if (sensorId == 5) return 'NH3';
    if (sensorId == 6) return 'Salinity';
    return 'Graph';
  }

  @override
  void onInit() {
    super.onInit();
    _readArguments();
    graphData();
  }

  Future<void> graphData({String? type}) async {
    final requestedType = (type ?? _initialType()).toLowerCase();
    selectedPeriod.value = _capitalize(requestedType);
    isLoading.value = true;
    error.value = '';

    EasyLoading.show(status: 'Loading graph...');
    debugPrint(
      'Graph loading start: flow=${isPoultryFlow ? 'poultry' : 'default'} type=$requestedType',
    );

    try {
      if (isPoultryFlow) {
        await _loadPoultryGraph(type: requestedType);
      } else {
        await _loadDefaultGraph(type: requestedType);
      }
      hasLoaded.value = true;
    } catch (e) {
      error.value = e.toString();
      debugPrint('Graph loading error: $e');
    } finally {
      isLoading.value = false;
      if (EasyLoading.isShow) {
        EasyLoading.dismiss();
      }
    }
  }

  void _readArguments() {
    final args = Get.arguments;
    if (args is! Map) {
      return;
    }

    final map = Map<String, dynamic>.from(args);
    isPoultryFlow = map['flow']?.toString().toLowerCase() == 'poultry';

    if (isPoultryFlow) {
      farmId = int.tryParse('${map['farmId']}');
      sensorKey = (map['sensorKey'] ?? '').toString().trim();
      sensorName = (map['sensorName'] ?? '').toString().trim();
      sensorUnit = (map['unit'] ?? '').toString().trim();
      type = (map['type'] ?? 'daily').toString().trim().toLowerCase();
      return;
    }

    comId = map['comId'];
    assetId = map['assetId'];
    sensorId = map['sensorId'];
    type = map['type'];
  }

  String _initialType() {
    final fromArgs = type?.toString().trim().toLowerCase();
    if (fromArgs == 'daily' ||
        fromArgs == 'weekly' ||
        fromArgs == 'monthly' ||
        fromArgs == 'yearly') {
      return fromArgs!;
    }
    return 'daily';
  }

  Future<void> _loadDefaultGraph({required String type}) async {
    final response = await devicesRepository.getGraphData(
      comId: comId,
      assetId: assetId,
      sensorId: sensorId,
      type: type,
    );

    response.fold(
      (l) {
        throw Exception('Failed to fetch graph: ${l.message}');
      },
      (r) {
        graphResponse.value = r;
        _applyChartData(r);
      },
    );
  }

  Future<void> _loadPoultryGraph({required String type}) async {
    if (farmId == null || sensorKey.isEmpty) {
      throw Exception('Missing farm_id or sensor_key for poultry graph.');
    }

    final token = _getPoultryToken();
    final uri = Uri.parse(
      '${ApiService.poultryBaseUrl}/poultry_care/data/graph/?farm_id=$farmId&sensor_key=$sensorKey&type=$type',
    );

    debugPrint('Poultry graph GET: $uri');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    debugPrint('Poultry graph status: ${response.statusCode}');
    debugPrint('Poultry graph body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(
        'Poultry graph API failed with status ${response.statusCode}',
      );
    }

    final parsed = GraphResponse.fromRawJson(response.body);
    graphResponse.value = parsed;
    _applyChartData(parsed);
  }

  String _getPoultryToken() {
    if (Get.isRegistered<LoginTokenStorage>()) {
      final token = Get.find<LoginTokenStorage>().getPoultryToken();
      final normalized = token?.trim();
      if (normalized != null && normalized.isNotEmpty) {
        return normalized;
      }
    }
    return _fallbackPoultryToken;
  }

  void _applyChartData(GraphResponse response) {
    final dataList = response.data;
    if (dataList == null || dataList.isEmpty) {
      sensorValues.clear();
      timeLabels.clear();
      return;
    }

    final firstItem = dataList.first;
    final sensorVal = firstItem.sensorVal ?? const <String>[];
    final time = firstItem.time ?? const <String>[];

    sensorValues.value = sensorVal
        .map((e) => double.tryParse(e) ?? 0.0)
        .toList();
    timeLabels.value = List<String>.from(time);

    if (isPoultryFlow && sensorName.isEmpty) {
      sensorName = (firstItem.sensorName ?? '').toString();
    }
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }

  String _toTitleCase(String value) {
    return value
        .replaceAll('_', ' ')
        .split(' ')
        .where((e) => e.isNotEmpty)
        .map((e) => '${e[0].toUpperCase()}${e.substring(1)}')
        .join(' ');
  }
}
