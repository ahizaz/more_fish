import 'package:get/get.dart';

import '../modules/about_app/bindings/about_app_binding.dart';
import '../modules/about_app/views/about_app_view.dart';
import '../modules/about_app_details/bindings/about_app_details_binding.dart';
import '../modules/about_app_details/views/about_app_details_view.dart';
import '../modules/about_devices/bindings/about_devices_binding.dart';
import '../modules/about_devices/views/about_devices_view.dart';
import '../modules/about_devices_details/bindings/about_devices_details_binding.dart';
import '../modules/about_devices_details/views/about_devices_details_view.dart';
import '../modules/coming_soon/bindings/coming_soon_binding.dart';
import '../modules/coming_soon/views/coming_soon_view.dart';
import '../modules/dma_technologies/bindings/dma_technologies_binding.dart';
import '../modules/dma_technologies/views/dma_technologies_shell_view.dart';
import '../modules/aerator_connection/bindings/aerator_connection_binding.dart';
import '../modules/aerator_connection/views/aerator_connection_view.dart';
import '../modules/faq/bindings/faq_binding.dart';
import '../modules/faq/views/faq_view.dart';
import '../modules/faq_details/bindings/faq_details_binding.dart';
import '../modules/faq_details/views/faq_details_view.dart';
import '../modules/farm_management/bindings/farm_management_binding.dart';
import '../modules/farm_management/views/farm_management_view.dart';
import '../modules/farm_management_details/bindings/farm_management_details_binding.dart';
import '../modules/farm_management_details/views/farm_management_details_view.dart';
import '../modules/feed_management/bindings/feed_management_binding.dart';
import '../modules/feed_management/views/feed_management_view.dart';
import '../modules/feed_management_details/bindings/feed_management_details_binding.dart';
import '../modules/feed_management_details/views/feed_management_details_view.dart';
import '../modules/feeder_connection/bindings/feeder_connection_binding.dart';
import '../modules/feeder_connection/views/feeder_connection_view.dart';
import '../modules/fish_disease_treatment/bindings/fish_disease_treatment_binding.dart';
import '../modules/fish_disease_treatment/views/fish_disease_treatment_view.dart';
import '../modules/fish_disease_detector/bindings/fish_disease_detector_binding.dart';
import '../modules/fish_disease_detector/views/fish_disease_detector_view.dart';
import '../modules/fish_disease_treatment_details/bindings/fish_disease_treatment_details_binding.dart';
import '../modules/fish_disease_treatment_details/views/fish_disease_treatment_details_view.dart';
import '../modules/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/forgot_password/views/forgot_password_view.dart';
import '../modules/graph/bindings/graph_binding.dart';
import '../modules/graph/views/graph_view.dart';
import '../modules/high_density_fish_farming/bindings/high_density_fish_farming_binding.dart';
import '../modules/high_density_fish_farming/views/high_density_fish_farming_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/index/bindings/index_binding.dart';
import '../modules/index/views/index_view.dart';
import '../modules/poultry_index/bindings/poultry_index_binding.dart';
import '../modules/poultry_index/views/poultry_index_view.dart';
import '../modules/cattle_index/bindings/cattle_index_binding.dart';
import '../modules/cattle_index/views/cattle_index_view.dart';
import '../modules/clean_air_index/bindings/clean_air_index_binding.dart';
import '../modules/clean_air_index/views/clean_air_index_view.dart';
import '../modules/internet_checker/bindings/internet_checker_binding.dart';
import '../modules/internet_checker/views/internet_checker_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/poultry_login/bindings/poultry_login_binding.dart';
import '../modules/poultry_login/views/poultry_login_view.dart';
import '../modules/more/bindings/more_binding.dart';
import '../modules/more/views/more_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/otp_verify/bindings/otp_verify_binding.dart';
import '../modules/otp_verify/views/otp_verify_view.dart';
import '../modules/password_change/bindings/password_change_binding.dart';
import '../modules/password_change/views/password_change_view.dart';
import '../modules/pond_management/bindings/pond_management_binding.dart';
import '../modules/pond_management/views/pond_management_view.dart';
import '../modules/pond_management_details/bindings/pond_management_details_binding.dart';
import '../modules/pond_management_details/views/pond_management_details_view.dart';
import '../modules/pond_management_table/bindings/pond_management_table_binding.dart';
import '../modules/pond_management_table/views/pond_management_table_view.dart';
import '../modules/product_comp_wise_list/bindings/product_comp_wise_list_binding.dart';
import '../modules/product_comp_wise_list/views/product_comp_wise_list_view.dart';
import '../modules/product_companies/bindings/product_companies_binding.dart';
import '../modules/product_companies/views/product_companies_view.dart';
import '../modules/product_details/bindings/product_details_binding.dart';
import '../modules/product_details/views/product_details_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/registration/bindings/registration_binding.dart';
import '../modules/registration/views/registration_view.dart';
import '../modules/reset_password/bindings/reset_password_binding.dart';
import '../modules/reset_password/views/reset_password_view.dart';
import '../modules/smart_khamari/bindings/smart_khamari_binding.dart';
import '../modules/smart_khamari/views/smart_khamari_view.dart';
import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';
import '../modules/training_and_workshop/bindings/training_and_workshop_binding.dart';
import '../modules/training_and_workshop/views/training_and_workshop_view.dart';
import '../modules/version_checker/bindings/version_checker_binding.dart';
import '../modules/version_checker/views/version_checker_view.dart';
import '../modules/water_quality_device/bindings/water_quality_device_binding.dart';
import '../modules/water_quality_device/views/water_quality_device_view.dart';
import '../modules/weather_forecast/bindings/weather_forecast_binding.dart';
import '../modules/weather_forecast/views/weather_forecast_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.DMA_TECHNOLOGIES,
      page: () => const DmaTechnologiesShellView(),
      binding: DmaTechnologiesBinding(),
    ),
    GetPage(
      name: _Paths.COMING_SOON,
      page: () => const ComingSoonView(),
      binding: ComingSoonBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.INDEX,
      page: () => const IndexView(),
      binding: IndexBinding(),
    ),
    GetPage(
      name: _Paths.POULTRY_INDEX,
      page: () => const PoultryIndexView(),
      binding: PoultryIndexBinding(),
    ),
    GetPage(
      name: _Paths.CATTLE_INDEX,
      page: () => const CattleIndexView(),
      binding: CattleIndexBinding(),
    ),
    GetPage(
      name: _Paths.CLEAN_AIR_INDEX,
      page: () => const CleanAirIndexView(),
      binding: CleanAirIndexBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.MORE,
      page: () => const MoreView(),
      binding: MoreBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.POULTRY_LOGIN,
      page: () => const PoultryLoginView(),
      binding: PoultryLoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTRATION,
      page: () => const RegistrationView(),
      binding: RegistrationBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_COMPANIES,
      page: () => const ProductCompaniesView(),
      binding: ProductCompaniesBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_DETAILS,
      page: () => const ProductDetailsView(),
      binding: ProductDetailsBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_COMP_WISE_LIST,
      page: () => const ProductCompWiseListView(),
      binding: ProductCompWiseListBinding(),
    ),
    GetPage(
      name: _Paths.POND_MANAGEMENT,
      page: () => const PondManagementView(),
      binding: PondManagementBinding(),
    ),
    GetPage(
      name: _Paths.FEED_MANAGEMENT,
      page: () => const FeedManagementView(),
      binding: FeedManagementBinding(),
    ),
    GetPage(
      name: _Paths.FISH_DISEASE_TREATMENT,
      page: () => const FishDiseaseTreatmentView(),
      binding: FishDiseaseTreatmentBinding(),
    ),
    GetPage(
      name: _Paths.FISH_DISEASE_DETECTOR,
      page: () => const FishDiseaseDetectorView(),
      binding: FishDiseaseDetectorBinding(),
    ),
    GetPage(
      name: _Paths.FARM_MANAGEMENT,
      page: () => const FarmManagementView(),
      binding: FarmManagementBinding(),
    ),
    GetPage(
      name: _Paths.AERATOR_CONNECTION,
      page: () => const AeratorConnectionView(),
      binding: AeratorConnectionBinding(),
    ),
    GetPage(
      name: _Paths.FEEDER_CONNECTION,
      page: () => const FeederConnectionView(),
      binding: FeederConnectionBinding(),
    ),
    GetPage(
      name: _Paths.WEATHER_FORECAST,
      page: () => const WeatherForecastView(),
      binding: WeatherForecastBinding(),
    ),
    GetPage(
      name: _Paths.TRAINING_AND_WORKSHOP,
      page: () => const TrainingAndWorkshopView(),
      binding: TrainingAndWorkshopBinding(),
    ),
    GetPage(
      name: _Paths.FARM_MANAGEMENT_DETAILS,
      page: () => const FarmManagementDetailsView(),
      binding: FarmManagementDetailsBinding(),
    ),
    GetPage(
      name: _Paths.WATER_QUALITY_DEVICE,
      page: () => const WaterQualityDeviceView(),
      binding: WaterQualityDeviceBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT_DEVICES,
      page: () => const AboutDevicesView(),
      binding: AboutDevicesBinding(),
    ),
    GetPage(
      name: _Paths.FAQ,
      page: () => const FaqView(),
      binding: FaqBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT_APP,
      page: () => const AboutAppView(),
      binding: AboutAppBinding(),
    ),
    GetPage(
      name: _Paths.PASSWORD_CHANGE,
      page: () => const PasswordChangeView(),
      binding: PasswordChangeBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD,
      page: () => const ResetPasswordView(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.FORGET_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.OTP_VERIFY,
      page: () => const OtpVerifyView(),
      binding: OtpVerifyBinding(),
    ),
    GetPage(
      name: _Paths.INTERNET_CHECKER,
      page: () => const InternetCheckerView(),
      binding: InternetCheckerBinding(),
    ),
    GetPage(
      name: _Paths.VERSION_CHECKER,
      page: () => const VersionCheckerView(),
      binding: VersionCheckerBinding(),
    ),
    GetPage(
      name: _Paths.HIGH_DENSITY_FISH_FARMING,
      page: () => const HighDensityFishFarmingView(),
      binding: HighDensityFishFarmingBinding(),
    ),
    GetPage(
      name: _Paths.FISH_DISEASE_TREATMENT_DETAILS,
      page: () => const FishDiseaseTreatmentDetailsView(),
      binding: FishDiseaseTreatmentDetailsBinding(),
    ),
    GetPage(
      name: _Paths.FAQ_DETAILS,
      page: () => const FaqDetailsView(),
      binding: FaqDetailsBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT_APP_DETAILS,
      page: () => const AboutAppDetailsView(),
      binding: AboutAppDetailsBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT_DEVICES_DETAILS,
      page: () => const AboutDevicesDetailsView(),
      binding: AboutDevicesDetailsBinding(),
    ),
    GetPage(
      name: _Paths.POND_MANAGEMENT_DETAILS,
      page: () => const PondManagementDetailsView(),
      binding: PondManagementDetailsBinding(),
    ),
    GetPage(
      name: _Paths.POND_MANAGEMENT_TABLE,
      page: () => const PondManagementTableView(),
      binding: PondManagementTableBinding(),
    ),
    GetPage(
      name: _Paths.FEED_MANAGEMENT_DETAILS,
      page: () => const FeedManagementDetailsView(),
      binding: FeedManagementDetailsBinding(),
    ),
    GetPage(
      name: _Paths.SMART_KHAMARI,
      page: () => const SmartKhamariView(),
      binding: SmartKhamariBinding(),
    ),
    GetPage(
      name: _Paths.GRAPH,
      page: () => const GraphView(),
      binding: GraphBinding(),
    ),
  ];
}
