import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import '../response/forget_password_response.dart';
import '../response/login_response.dart';
import '../response/otp_verify_response.dart';
import '../response/password_change_response.dart';
import '../response/profile_response.dart';
import '../response/registration_response.dart';
import '../response/version_checker_response.dart';
import '../service/failure.dart';
import '../service/local_storage.dart';
import '../service/service.dart';

class AuthRepository{

  var loginTokenStorage = Get.find<LoginTokenStorage>();

  Future<Either<Failure, LoginResponse>> setLogin({email, password}) async {
    print("Email====== :${email}");
    print("Password=== : ${password}");
    try{

      var request = http.Request('POST', Uri.parse("${ApiService.baseUrl}/auth/login/"));
      request.headers.addAll(ApiService.headers);
      request.body = jsonEncode({
        "usr_email": "${email}",
        "password": "${password}"
      });

      http.StreamedResponse  response = await request.send();

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        LoginResponse loginResponse = LoginResponse.fromRawJson(data);
        return Right(loginResponse);
      }
      else {
        return Left(Failure('Failed to fetch login with status: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(Failure('Error: $e'));
    }

  }


  Future<Either<Failure, RegistrationResponse>> setRegistration({requestModel}) async {

    try{

      var request = http.Request('POST', Uri.parse("${ApiService.baseUrl}/auth/registration/"));
      request.headers.addAll(ApiService.headers);

      request.body = requestModel.toRawJson();
      http.StreamedResponse  response = await request.send();

      if(response.statusCode == 200){
        var data = await response.stream.bytesToString();
        RegistrationResponse registrationResponse = RegistrationResponse.fromRawJson(data);
        return right(registrationResponse);
      }else{
        return left(Failure("'Failed to registration with status: ${response.statusCode}'"));
      }

    }catch(e){
      return Left(Failure('Error: $e'));
    }

  }


  Future<Either<Failure, PasswordChangeResponse>> changePassword({oldPassword, newPassword}) async {
    try{

      var token = await loginTokenStorage.getToken();

      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      var request = http.Request('POST', Uri.parse("${ApiService.baseUrl}/auth/user/password/change/"));
      request.headers.addAll(headers);
      request.body = jsonEncode({
        "old_password": "${oldPassword}",
        "new_password": "${newPassword}"
      });

      http.StreamedResponse  response = await request.send();

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        PasswordChangeResponse passwordChangeResponse = PasswordChangeResponse.fromRawJson(data);

        return Right(passwordChangeResponse);
      }
      else {
        return Left(Failure('Failed to change pass with status: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(Failure('Error: $e'));
    }

  }


  Future<Either<Failure, ProfileResponse>> getProfile() async {

    try {
      var token = await loginTokenStorage.getToken();
      var id = await loginTokenStorage.getUserId();

      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      var request = http.Request('GET', Uri.parse("${ApiService.baseUrl}/auth/user/details/$id"));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        ProfileResponse profileResponse = ProfileResponse.fromRawJson(data);
        return Right(profileResponse);
      }
      else {
        return Left(Failure('Failed to fetch profile with status: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(Failure('Error: $e'));
    }

  }


  Future<Either<Failure, ForgotPasswordResponse>> forgotPassword({email, phone}) async {
    try{
      var request = http.Request('POST', Uri.parse("${ApiService.baseUrl}/auth/user/forgot/password/"));
      request.headers.addAll(ApiService.headers);
      request.body = jsonEncode({
        "phone": "${phone}",
        "email": "${email}"
      });

      http.StreamedResponse  response = await request.send();

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        ForgotPasswordResponse forgotPasswordResponse = ForgotPasswordResponse.fromRawJson(data);

        return Right(forgotPasswordResponse);
      }
      else {
        return Left(Failure('Failed to send otp with status: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(Failure('Error: $e'));
    }

  }


  Future<Either<Failure, OtpVerifyResponse>> otpVerify({code}) async {
    print(code);
    try{
      var request = http.Request('POST', Uri.parse("${ApiService.baseUrl}/auth/user/otp/verify/"));
      request.headers.addAll(ApiService.headers);
      request.body = jsonEncode({
        "code": "${code}",
      });
      http.StreamedResponse  response = await request.send();

      print(response.statusCode);

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        OtpVerifyResponse otpVerifyResponse = OtpVerifyResponse.fromRawJson(data);

        return Right(otpVerifyResponse);
      }
      else {
        return Left(Failure('Failed to fetch otp with status: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(Failure('Error: $e'));
    }

  }


  Future<Either<Failure, ForgotPasswordResponse>> resetPassword({userId, password}) async {
    try{
      var request = http.Request('POST', Uri.parse("${ApiService.baseUrl}/auth/user/reset/password/"));
      request.headers.addAll(ApiService.headers);
      request.body = jsonEncode({
        "user_id": "${userId}",
        "password": "${password}"
      });

      http.StreamedResponse  response = await request.send();

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        ForgotPasswordResponse forgotPasswordResponse = ForgotPasswordResponse.fromRawJson(data);

        return Right(forgotPasswordResponse);
      }
      else {
        return Left(Failure('Failed to reset pass with status: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(Failure('Error: $e'));
    }

  }


  Future<Either<Failure, VersionCheckerResponse>> getVersion() async {

    try {

      var request = http.Request('GET', Uri.parse("${ApiService.baseUrl}/settings/versions/"));
      request.headers.addAll(ApiService.headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        VersionCheckerResponse versionCheckerResponse = VersionCheckerResponse.fromRawJson(data);
        return Right(versionCheckerResponse);
      }
      else {
        return Left(Failure('Failed to fetch version with status: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(Failure('Error: $e'));
    }

  }



}