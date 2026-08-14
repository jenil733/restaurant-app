import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/presentation/controller/home_controller.dart';
import 'package:restaurant_app/src/presentation/controller/product_controller.dart';
import 'package:restaurant_app/src/presentation/view/products/add_product_screen.dart';
import 'package:restaurant_app/src/presentation/view/products/edit_product_screen.dart';
import 'package:restaurant_app/src/presentation/view/products/widgets/product_card_widget.dart';
import 'package:restaurant_app/src/presentation/widgets/app_bar.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Product',
        actionText: 'Add Product',
        onActionPressed: () {
           Get.to(() => const AddProductScreen());
        },
        onBackPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else if (Get.isRegistered<HomeController>()) {
            Get.find<HomeController>().changeTab(0);
          }
        },
      ),
      body: GetBuilder<ProductController>(
        builder: (controller) {
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final item = controller.products[index];

              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Get.to(() => const EditProductScreen());
                },
                child: ProductCard(
                  title: item['title'],
                  isVeg: item['isVeg'],
                  originalPrice: item['originalPrice'],
                  discountedPrice: item['discountedPrice'],
                  discountText: item['discountText'],
                  description: item['description'],
                ),
              );
            },
          );
        },
      ),
    );
  }
}