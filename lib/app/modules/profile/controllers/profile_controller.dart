
import 'package:get/get.dart';
import 'package:more_fish/app/repo/auth.dart';
import 'package:more_fish/app/response/profile_response.dart';
import 'package:more_fish/app/service/local_storage.dart';



class ProfileController extends GetxController {
  late LoginTokenStorage loginTokenStorage;
  var isLoggedIn = ''.obs;
  AuthRepository authRepository = AuthRepository();
  final profileResponse = Rxn<ProfileResponse>();


  @override
  void onInit() {
    super.onInit();

  }

  checkLogin() {
    loginTokenStorage = Get.find<LoginTokenStorage>();
    final token = loginTokenStorage.getToken();
    print(token);
    if (token != null) {
      isLoggedIn.value = token;
      userProfile();
    }

  }

  userProfile() async{

    var response = await authRepository.getProfile();
    response.fold(
      (l){
      print('${l.message}');
      }, (r) async {
        profileResponse.value = r;

      });

  }




}
