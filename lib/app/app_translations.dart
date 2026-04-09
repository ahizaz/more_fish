import 'package:get/get.dart';
import 'translations/bn_BD.dart';
import 'translations/en_US.dart';


class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_us': enUS,
    'bn_BD': bnBD,
  };
}
