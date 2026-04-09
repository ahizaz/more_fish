import 'package:get/get.dart';

class ComingSoonController extends GetxController {
  String get title {
    final args = Get.arguments;
    if (args is Map && args['title'] is String) {
      return args['title'] as String;
    }
    return 'Coming Soon';
  }
}
