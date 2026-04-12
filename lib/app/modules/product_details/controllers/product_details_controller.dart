
import 'package:get/get.dart';
import '../../../repo/products.dart';

import '../../../response/product_details_response.dart';

class ProductDetailsController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    getDetails();
  }


  ProductsRepository productsRepository = ProductsRepository();
  final productDetailsResponse =  Rxn<ProductDetailsResponse>();

  getDetails() async {
    var id = Get.arguments["id"];
    var response = await productsRepository.getProductDetails(id: id);

    response.fold(
          (l) {
        print('Failed to fetch details: ${l.message}');
      }, (r) {
      productDetailsResponse.value = r;
      print("=================================");
      print(productDetailsResponse.value);
      print("=================================");
    },
    );
  }

}
