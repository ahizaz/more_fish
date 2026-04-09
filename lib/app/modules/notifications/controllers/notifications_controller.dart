import 'package:get/get.dart';
import '../../../common_widgets/common_alert_dialog.dart';
import '../../../repo/auth.dart';
import '../../../repo/notifications.dart';
import '../../../response/notification_response.dart';
import '../../../response/profile_response.dart';
import '../../../routes/app_pages.dart';
import '../../../service/local_storage.dart';
import '../../profile/controllers/profile_controller.dart';

class NotificationsController extends GetxController {

  var items = [
    "Aqua, the color of calm seas and clear skies, often symbolizes freshness, purity, and tranquility. It reminds us of flowing rivers, sparkling waves, and the cool serenity of water that brings life to everything around it.",
    "Aqua, the color of calm seas and clear skies, often symbolizes freshness, purity, and tranquility. It reminds us of flowing rivers, sparkling waves, and the cool serenity of water that brings life to everything around it.",
    "Aqua, the color of calm seas and clear skies, often symbolizes freshness, purity, and tranquility. It reminds us of flowing rivers, sparkling waves, and the cool serenity of water that brings life to everything around it.",
    "Aqua, the color of calm seas and clear skies, often symbolizes freshness, purity, and tranquility. It reminds us of flowing rivers, sparkling waves, and the cool serenity of water that brings life to everything around it.",
    "Aqua, the color of calm seas and clear skies, often symbolizes freshness, purity, and tranquility. It reminds us of flowing rivers, sparkling waves, and the cool serenity of water that brings life to everything around it.",
    "Aqua, the color of calm seas and clear skies, often symbolizes freshness, purity, and tranquility. It reminds us of flowing rivers, sparkling waves, and the cool serenity of water that brings life to everything around it.",
    "Aqua, the color of calm seas and clear skies, often symbolizes freshness, purity, and tranquility. It reminds us of flowing rivers, sparkling waves, and the cool serenity of water that brings life to everything around it.",
    "Aqua, the color of calm seas and clear skies, often symbolizes freshness, purity, and tranquility. It reminds us of flowing rivers, sparkling waves, and the cool serenity of water that brings life to everything around it.",
    "Aqua, the color of calm seas and clear skies, often symbolizes freshness, purity, and tranquility. It reminds us of flowing rivers, sparkling waves, and the cool serenity of water that brings life to everything around it.",

  ].obs;
  late LoginTokenStorage loginTokenStorage;
  var isLoggedIn = ''.obs;
  final _hasShownLoginPrompt = false.obs;
  NotificationsRepository notificationsRepository = NotificationsRepository();
  final notificationResponse = Rxn<NotificationResponse>();
  AuthRepository authRepository = AuthRepository();
  final profileResponse = Rxn<ProfileResponse>();
  ProfileController profileController = ProfileController();

  @override
  void onInit() {
    super.onInit();
    // Intentionally empty; login check is triggered in onReady so
    // it runs after dependencies are available.
  }

  @override
  void onReady() {
    super.onReady();
    checkLogin();
  }

  checkLogin() {
    loginTokenStorage = Get.find<LoginTokenStorage>();
    final token = loginTokenStorage.getToken();
    final id = loginTokenStorage.getUserId();
    print(id);
    print(token);
    if (token != null) {
      isLoggedIn.value = token;
      notificationList();
    } else {
      _showLoginPromptOnce();
    }

  }

  void _showLoginPromptOnce() {
    if (_hasShownLoginPrompt.value) return;
    _hasShownLoginPrompt.value = true;

    // Show the same login prompt dialog used elsewhere in the app.
    Get.dialog(
      CommonAlertDialog(
        notNow: () {
          Get.back();
          // If user opens Notifications via a direct route, send them to Home.
          Get.offAllNamed(Routes.INDEX);
        },
        login: () {
          Get.back();
          Get.toNamed(Routes.LOGIN);
        },
      ),
      barrierDismissible: true,
    );
  }



  notificationList() async {
    var response = await notificationsRepository.getNotification();
    response.fold(
        (l){
          print('${l.message}');
        },
        (r){
          notificationResponse.value = r;
          print("=================================");
          print(notificationResponse.value);
          print("=================================");
        });
  }


}
