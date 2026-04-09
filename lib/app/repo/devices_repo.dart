import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import '../response/aerator_command_response.dart';
import '../response/company_list_response.dart';
import '../response/graph_response.dart';
import '../response/pond_data_response.dart';
import '../response/pond_list_response.dart';
import '../response/sensor_list_response.dart';
import '../service/failure.dart';
import '../service/service.dart';
import 'package:more_fish/app/service/local_storage.dart';

class DevicesRepository{

  var loginTokenStorage = Get.find<LoginTokenStorage>();

  Future<Either<Failure, PondListResponse>> getPondList() async {
    try {
    var token = await loginTokenStorage.getToken();
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    
    var request = http.Request('GET', Uri.parse("${ApiService.baseUrl}/devices/data/pond/list"));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      PondListResponse pondListResponse = PondListResponse.fromRawJson(data);
      return Right(pondListResponse);
    }
    else {
      return Left(Failure('Failed to fetch pond list with status: ${response.statusCode}'));
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

    var request = http.Request('GET', Uri.parse("${ApiService.baseUrl}/devices/data/pond/data?asset_id=$id"));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      PondDataResponse pondDataResponse = PondDataResponse.fromRawJson(data);
      return Right(pondDataResponse);
    }
    else {
      return Left(Failure('Failed to fetch pond data with status: ${response.statusCode}'));
    }
  } catch (e) {
  return Left(Failure('Error: $e'));
  }

  }


  Future<Either<Failure, SensorListResponse>> getSensorList() async {
    try {
    var token = await loginTokenStorage.getToken();
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var request = http.Request('GET', Uri.parse("${ApiService.baseUrl}/devices/sensor/list"));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      SensorListResponse sensorListResponse = SensorListResponse.fromRawJson(data);
      return Right(sensorListResponse);
    }
    else {
      return Left(Failure('Failed to fetch sensor list with status: ${response.statusCode}'));
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

    var request = http.Request('GET', Uri.parse("${ApiService.baseUrl}/auth/company/list"));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      CompanyListResponse companyListResponse = CompanyListResponse.fromRawJson(data);
      return Right(companyListResponse);
    }
    else {
      return Left(Failure('Failed to fetch Company list with status: ${response.statusCode}'));
    }
  } catch (e) {
  return Left(Failure('Error: $e'));
  }

  }


  Future<Either<Failure, AeratorCommandResponse>> setAeratorCommand({id, command}) async {

    try {
    var token = await loginTokenStorage.getToken();
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var request = http.Request('POST', Uri.parse("${ApiService.baseUrl}/devices/aerators/command/"));
    request.headers.addAll(headers);
    request.body = jsonEncode({
      "aerator_id": "$id",
      "command": command
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      AeratorCommandResponse aeratorCommandResponse = AeratorCommandResponse.fromRawJson(data);
      return Right(aeratorCommandResponse);
    }
    else {
      return Left(Failure('Failed to fetch aerator with status: ${response.statusCode}'));
    }
  } catch (e) {
  return Left(Failure('Error: $e'));
  }

  }


  Future<Either<Failure, GraphResponse>> getGraphData({comId, assetId, sensorId, type}) async  {
    try {
      var token = await loginTokenStorage.getToken();
      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      var request = http.Request('GET', Uri.parse("${ApiService.baseUrl}/devices/data/graph?company_id=$comId&assst_id=$assetId&sensor_id=$sensorId&type=$type"));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        GraphResponse graphResponse = GraphResponse.fromRawJson(data);
        return Right(graphResponse);
      }
      else if (response.statusCode == 201) {
        var data = await response.stream.bytesToString();
        GraphResponse graphResponse = GraphResponse.fromRawJson(data);
        return Right(graphResponse);
      }
      else {
        return Left(Failure('Failed to fetch graph data with status: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(Failure('Error: $e'));
    }

  }

}