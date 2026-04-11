import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../response/notification_response.dart';

import '../service/failure.dart';
import '../service/service.dart';
import 'package:more_fish/app/service/local_storage.dart';

class NotificationsRepository{


  var loginTokenStorage = Get.find<LoginTokenStorage>();

  Future<Either<Failure, NotificationResponse>> getNotification() async {
    try {
      var token = await loginTokenStorage.getToken();
      var id = await loginTokenStorage.getUserId();
      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      var request = http.Request('GET', Uri.parse("${ApiService.baseUrl}/notification/all/list/$id/"));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.statusCode);
        var data = await response.stream.bytesToString();
        NotificationResponse notificationResponse = NotificationResponse.fromRawJson(data);
        return Right(notificationResponse);
      }
      if (response.statusCode == 201) {
        print(response.statusCode);
        var data = await response.stream.bytesToString();
        print("======================================================1");
        NotificationResponse notificationResponse = NotificationResponse.fromRawJson(data);
        print("======================================================2");
        return Right(notificationResponse);
      }
      else {
        return Left(Failure('Failed to fetch notification with status: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(Failure('Error: $e'));
    }

  }


}