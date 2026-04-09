import 'package:get/get.dart';

import '../controllers/product_comp_wise_list_controller.dart';

class ProductCompWiseListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductCompWiseListController>(
      () => ProductCompWiseListController(),
    );
  }
}
