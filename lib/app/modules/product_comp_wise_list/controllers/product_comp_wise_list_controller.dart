
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../repo/products.dart';
import '../../../response/product_list_response.dart';

class ProductCompWiseListController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getProductList();
  }

  ProductsRepository productsRepository = ProductsRepository();
  final productListResponse = Rxn<ProductListResponse>();

  getProductList() async {
    var id = Get.arguments["guid"];
    var response = await productsRepository.getProductCompWiseList(guid: id);

    response.fold(
          (l) {
        debugPrint('Failed to fetch product list: ${l.message}');
      }, (r) {
      productListResponse.value = r;
      debugPrint("=================================");
      debugPrint("productListResponse.value");
      debugPrint("=================================");
    },
    );
  }


}
