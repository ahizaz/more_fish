
import 'package:get/get.dart';
import '../../../repo/products.dart';
import '../../../response/product_companies_response.dart';

class ProductCompaniesController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    getCompanies();
  }


  ProductsRepository productsRepository = ProductsRepository();
  final productCompaniesResponse =  Rxn<ProductCompaniesResponse>();


  getCompanies() async {
    var id = Get.arguments["id"];
    var response = await productsRepository.getProductCompanies(id: id);

    response.fold(
          (l) {
        print('Failed to fetch companies: ${l.message}');
      },
          (r) {
      productCompaniesResponse.value = r;
      print("=================================");
      print(productCompaniesResponse.value);
      print("=================================");
    },
    );
  }

}
