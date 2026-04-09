import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common_widgets/common_container.dart';
import '../../../res/colors/colors.dart';
import '../../../routes/app_pages.dart';
import '../../../service/service.dart';
import '../../product_companies/controllers/product_companies_controller.dart';
import '../controllers/product_comp_wise_list_controller.dart';

class ProductCompWiseListView extends GetView<ProductCompWiseListController> {
  const ProductCompWiseListView({super.key});
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.backGround,
      appBar: AppBar(
        backgroundColor: Color(0xffd4fcfd),
        title: const Text(
          'Product List',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx((){
        var data = controller.productListResponse.value?.data;
        return data == null ? Center(child: CircularProgressIndicator()):
        GridView.builder(
          padding: EdgeInsets.all(12),
          itemCount: data.data.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            childAspectRatio: .9,
          ),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: (){
                Get.toNamed(Routes.PRODUCT_DETAILS,arguments: {"id": data.data[index].guid});
              },
              child: CommonContainer(
                padding: EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      "${ApiService.baseUrl}${data.data[index].productimageSet[0].image??Icon(Icons.account_circle_sharp)}",
                      height: 80,
                      width: 80,
                    ),
                    SizedBox(height: 3),
                    Text(
                      "${data.data[index].name}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 3),
                    Row(
                      children: [
                        Text(
                          "৳",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,

                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(width: 1,),
                        Text(
                          "${data.data[index].price}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,

                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
