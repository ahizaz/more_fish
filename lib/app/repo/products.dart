import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import '../response/category_response.dart';
import '../response/product_companies_response.dart';
import '../response/product_details_response.dart';
import '../response/product_list_response.dart';
import '../service/failure.dart';
import '../service/service.dart';

class ProductsRepository{

  Future<Either<Failure, CategoryResponse>> getProductCategories() async {
    try {
      var request = http.Request('GET', Uri.parse("${ApiService.baseUrl}/product/category/list/"));
      request.headers.addAll(ApiService.headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        CategoryResponse categoryResponse = CategoryResponse.fromRawJson(data);
        return Right(categoryResponse);
      }
      else {
        return Left(Failure('Failed to fetch categories with status: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(Failure('Error: $e'));
    }
  }

  Future<Either<Failure, ProductCompaniesResponse>> getProductCompanies({id}) async {
    //var id = "c877b5f5-7f81-4c3a-9950-cab8b2b3336c";
    try{

      var headers = {
        'Content-Type': 'application/json',
      };

      var request = http.Request('GET', Uri.parse("${ApiService.baseUrl}/product/product-companies?category_guid=$id"));
      request.headers.addAll(headers);

      http.StreamedResponse  response = await request.send();

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        ProductCompaniesResponse productCompaniesResponse = ProductCompaniesResponse.fromRawJson(data);
        return Right(productCompaniesResponse);
      }
      else {
        return Left(Failure('Failed to fetch product companies with status: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(Failure('Error: $e'));
    }



  }

  Future<Either<Failure, ProductListResponse>> getProductCompWiseList({guid}) async {

    var page_num = 1;
    var size = 30;
    var prod_comp_id = guid;

    try{

      var headers = {
        'Content-Type': 'application/json',
      };

      var request = http.Request('GET', Uri.parse("${ApiService.baseUrl}/product/search-product-by-company?page_number=$page_num&size=$size&product_company_guid=$prod_comp_id"));
      request.headers.addAll(headers);

      http.StreamedResponse  response = await request.send();

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        ProductListResponse productListResponse = ProductListResponse.fromRawJson(data);
        return Right(productListResponse);
      }
      else {
        return Left(Failure('Failed to fetch product list with status: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(Failure('Error: $e'));
    }



  }

  Future<Either<Failure, ProductDetailsResponse>> getProductDetails({var id}) async {

    try{

      var headers = {
        'Content-Type': 'application/json',
      };

      var request = http.Request('GET', Uri.parse("${ApiService.baseUrl}/product/details?product_guid=$id"));
      request.headers.addAll(headers);

      http.StreamedResponse  response = await request.send();

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        ProductDetailsResponse productDetailsResponse = ProductDetailsResponse.fromRawJson(data);
        return Right(productDetailsResponse);
      }
      else {
        return Left(Failure('Failed to fetch details with status: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(Failure('Error: $e'));
    }



  }

}