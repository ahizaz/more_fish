import 'package:get/get.dart';

import '../controllers/product_companies_controller.dart';

class ProductCompaniesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductCompaniesController>(
      () => ProductCompaniesController(),
    );
  }
}
