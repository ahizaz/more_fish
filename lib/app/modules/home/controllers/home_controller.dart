import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../repo/products.dart';
import '../../../response/category_response.dart';
import '../../../service/local_storage.dart';
import '../../../service/service.dart';

class HomeController extends GetxController {
  final PageController pageController = PageController();
  Timer? timer;
  var activeCallButton = false.obs;

  var currentPage = 0.obs;

  var bannerList = ["assets/banners/banner_bn_4.png"].obs;

  var listItemsEnglish1 = [
    'live_data_monitoring',
    'fish_disease_detector',
    "pond_management",
    "feed_management",
    "fish_disease_treatment",
    "live_consultancy",
    "fish_farm_marketplace",
    "fingerlings_marketplace",
    "grown_fish_sell",
    "fish_medicine_enzyme",
    "FCR Calculator",
  ].obs;

  var iconList1 = [
    "assets/icons/water_quality_check.png",
    "assets/icons/fish_disease_treatment.png",
    "assets/icons/pond_management.png",
    "assets/icons/feed_management.png",
    "assets/icons/fish_disease_treatment.png",
    "assets/icons/doctor_service.png",
    "assets/icons/fish_farm_materials.png",
    "assets/icons/fingerlings.png",
    "assets/icons/grown_fish.png",
    "assets/icons/fish_medicine.png",
    "assets/icons/feed_management.png",
  ].obs;

  var listItemsEnglish2 = [
    "fish_feed_marketplace",
    "training_workshop",
    "farm_management",
    "auto_aerator_connection",
    "auto_feeder_connection",
    "weather_forecast",
  ].obs;

  var iconList2 = [
    "assets/icons/fish_feed.png",
    "assets/icons/training_and_workshop.png",
    "assets/icons/farm_management.png",
    "assets/icons/auto_aerator.png",
    "assets/icons/auto-feeder.png",
    "assets/icons/weather_forecast.png",
  ].obs;

  var listItemsBangla1 = [
    "২৪ ঘন্টা পানি পনিক্ষণ নিভাইস",
    "পুকুি প্রস্তুত বযব্স্থাপিা",
    "খাদ্য ব্যব্স্থাপিা ",
    "রিাগ ব্ালাই পিীক্ষণ ওনিিসি ",
    "২৪ ঘন্টা পানি পনিক্ষণ নিভাইস",
    "২৪ ঘন্টা পানি পনিক্ষণ নিভাইস",
    "২৪ ঘন্টা পানি পনিক্ষণ নিভাইস",
    "২৪ ঘন্টা পানি পনিক্ষণ নিভাইস",
    "২৪ ঘন্টা পানি পনিক্ষণ নিভাইস",
    "২৪ ঘন্টা পানি পনিক্ষণ নিভাইস",
    "২৪ ঘন্টা পানি পনিক্ষণ নিভাইস",
    "২৪ ঘন্টা পানি পনিক্ষণ নিভাইস",
    "২৪ ঘন্টা পানি পনিক্ষণ নিভাইস",
    "২৪ ঘন্টা পানি পনিক্ষণ নিভাইস",
  ];

  var formattedDate = "".obs;
  var formattedTime = "".obs;

  late LoginTokenStorage loginTokenStorage;
  var isLoggedIn = ''.obs;

  final String apiKey = ApiService.apiKey;
  var weatherData = {}.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  ProductsRepository productsRepository = ProductsRepository();
  final categoryResponse = Rxn<CategoryResponse>();

  @override
  void onInit() {
    super.onInit();
    fetchWeatherData("dhaka");
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      DateTime now = DateTime.now();
      formattedDate.value = DateFormat('d-MMM-yyyy').format(now);
      formattedTime.value = DateFormat('h:mm:ss a').format(now);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      bannerRotation();
    });
    getCategories();
  }

  void bannerRotation() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (pageController.hasClients) {
        int nextPage = (pageController.page?.toInt() ?? 0) + 1;

        if (nextPage >= bannerList.length) {
          nextPage = 0;
        }

        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  getCategories() async {
    var response = await productsRepository.getProductCategories();

    response.fold(
      (l) {
        print('Failed to fetch categories: ${l.message}');
      },
      (r) {
        categoryResponse.value = r;

        debugPrint("=================================");
        print(categoryResponse.value);
        print("=================================");
      },
    );
  }

  checkLogin() {
    loginTokenStorage = Get.find<LoginTokenStorage>();
    final token = loginTokenStorage.getToken();
    print(token);
    if (token != null) {
      isLoggedIn.value = token;
    }
  }

  Future<void> fetchWeatherData(String city) async {
    isLoading.value = true;
    errorMessage.value = '';
    weatherData.clear();

    try {
      final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        weatherData.value = json.decode(response.body);
      } else {
        final error = json.decode(response.body);
        errorMessage.value = error['message'] ?? 'City not found';
      }
    } catch (e) {
      errorMessage.value = 'Something went wrong. Check your internet.';
    } finally {
      isLoading.value = false;
    }
  }
}
