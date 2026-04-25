import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import 'dart:io';
import '../response/aerator_command_response.dart';
import '../response/company_list_response.dart';
import '../response/graph_response.dart';
import '../response/pond_data_response.dart';
import '../response/pond_list_response.dart';
import '../response/sensor_list_response.dart';
import '../service/failure.dart';
import '../service/service.dart';
import 'package:more_fish/app/service/local_storage.dart';

class DevicesRepository {
  var loginTokenStorage = Get.find<LoginTokenStorage>();

  Future<Either<Failure, PondListResponse>> getPondList() async {
    try {
      var token = await loginTokenStorage.getToken();
      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      var request = http.Request(
        'GET',
        Uri.parse("${ApiService.baseUrl}/devices/data/pond/list"),
      );
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        PondListResponse pondListResponse = PondListResponse.fromRawJson(data);
        return Right(pondListResponse);
      } else {
        return Left(
          Failure(
            'Failed to fetch pond list with status: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      return Left(Failure('Error: $e'));
    }
  }

  Future<Either<Failure, PondDataResponse>> getPondData({id}) async {
    try {
      var token = await loginTokenStorage.getToken();
      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      var request = http.Request(
        'GET',
        Uri.parse("${ApiService.baseUrl}/devices/data/pond/data?asset_id=$id"),
      );
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        PondDataResponse pondDataResponse = PondDataResponse.fromRawJson(data);
        return Right(pondDataResponse);
      } else {
        return Left(
          Failure(
            'Failed to fetch pond data with status: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      return Left(Failure('Error: $e'));
    }
  }

  Future<Either<Failure, SensorListResponse>> getSensorList({
    dynamic deviceId,
  }) async {
    try {
      var token = await loginTokenStorage.getToken();
      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      // Build URI with optional device_id query parameter
      final base = Uri.parse("${ApiService.baseUrl}/devices/sensor/list");
      final uri = (deviceId == null)
          ? base
          : base.replace(queryParameters: {'device_id': deviceId.toString()});

      var request = http.Request('GET', uri);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        SensorListResponse sensorListResponse = SensorListResponse.fromRawJson(
          data,
        );
        return Right(sensorListResponse);
      } else {
        return Left(
          Failure(
            'Failed to fetch sensor list with status: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      return Left(Failure('Error: $e'));
    }
  }

  Future<Either<Failure, CompanyListResponse>> getCompanyList() async {
    try {
      var token = await loginTokenStorage.getToken();
      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      var request = http.Request(
        'GET',
        Uri.parse("${ApiService.baseUrl}/auth/company/list"),
      );
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        CompanyListResponse companyListResponse =
            CompanyListResponse.fromRawJson(data);
        return Right(companyListResponse);
      } else {
        return Left(
          Failure(
            'Failed to fetch Company list with status: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      return Left(Failure('Error: $e'));
    }
  }

  Future<Either<Failure, AeratorCommandResponse>> setAeratorCommand({
    id,
    command,
  }) async {
    try {
      var token = await loginTokenStorage.getToken();
      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      var request = http.Request(
        'POST',
        Uri.parse("${ApiService.baseUrl}/devices/aerators/command/"),
      );
      request.headers.addAll(headers);
      request.body = jsonEncode({"aerator_id": "$id", "command": command});

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        AeratorCommandResponse aeratorCommandResponse =
            AeratorCommandResponse.fromRawJson(data);
        return Right(aeratorCommandResponse);
      } else {
        return Left(
          Failure(
            'Failed to fetch aerator with status: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      return Left(Failure('Error: $e'));
    }
  }

  Future<Either<Failure, GraphResponse>> getGraphData({
    comId,
    assetId,
    sensorId,
    type,
  }) async {
    try {
      var token = await loginTokenStorage.getToken();
      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final assetIdStr = assetId?.toString().trim();
      final sensorIdStr = sensorId?.toString().trim();
      final typeStr = (type ?? 'daily').toString().trim();

      // Validate required params early
      if (assetIdStr == null ||
          assetIdStr.isEmpty ||
          assetIdStr.toLowerCase() == 'null') {
        debugPrint('Graph request aborted: invalid assetId -> "$assetId"');
        return Left(Failure('Missing asset id for graph request'));
      }

      if (sensorIdStr == null ||
          sensorIdStr.isEmpty ||
          sensorIdStr.toLowerCase() == 'null') {
        debugPrint('Graph request aborted: invalid sensorId -> "$sensorId"');
        return Left(Failure('Missing sensor id for graph request'));
      }

      // API expects assst_id, sensor_id and type. Do not send company_id here.
      final baseUri = Uri.parse('${ApiService.baseUrl}/devices/data/graph');
      final uri = baseUri.replace(
        queryParameters: {
          'assst_id': assetIdStr,
          'sensor_id': sensorIdStr,
          'type': typeStr,
        },
      );

      debugPrint('Graph GET: $uri');

      // Use a client with a timeout and simple retry to tolerate flaky server
      final client = http.Client();
      try {
        const int maxAttempts = 2;
        int attempt = 0;
        http.Response? res;
        while (attempt < maxAttempts) {
          attempt++;
          try {
            res = await client
                .get(uri, headers: headers)
                .timeout(const Duration(seconds: 8));
            break;
          } on SocketException catch (e) {
            debugPrint('Graph request socket error (attempt $attempt): $e');
            if (attempt >= maxAttempts) rethrow;
            await Future.delayed(const Duration(milliseconds: 250));
          } on http.ClientException catch (e) {
            debugPrint('Graph request client error (attempt $attempt): $e');
            if (attempt >= maxAttempts) rethrow;
            await Future.delayed(const Duration(milliseconds: 250));
          }
        }

        if (res == null) {
          return Left(Failure('No response from graph API'));
        }

        debugPrint('Graph status: ${res.statusCode}');
        debugPrint('Graph response body: ${res.body}');

        if (res.statusCode == 200 || res.statusCode == 201) {
          final graphResponse = GraphResponse.fromRawJson(res.body);
          return Right(graphResponse);
        }

        return Left(
          Failure('Failed to fetch graph data with status: ${res.statusCode}'),
        );
      } finally {
        client.close();
      }
    } catch (e) {
      return Left(Failure('Error: $e'));
    }
  }
}
