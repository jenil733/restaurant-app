import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/presentation/controller/home_controller.dart';
import 'package:restaurant_app/src/presentation/controller/product_controller.dart';
import 'package:restaurant_app/src/presentation/view/products/add_product_screen.dart';
import 'package:restaurant_app/src/presentation/view/products/edit_product_screen.dart';
import 'package:restaurant_app/src/presentation/view/products/widgets/product_card_widget.dart';
import 'package:restaurant_app/src/presentation/widgets/app_bar.dart';

import 'package:restaurant_app/src/core/utils/helper/approval_helper.dart';
import 'package:restaurant_app/src/presentation/view/products/category_screen.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  void _onAddProduct(BuildContext context) {
    if (!isRestaurantApproved()) {
      showApprovalRequiredDialog(context, action: 'add and manage products');
      return;
    }
    Get.to(() => const AddProductScreen());
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ProductController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Product',
        actionText: 'Add Product',
        onActionPressed: () => _onAddProduct(context),
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
          if (controller.isLoading && controller.products.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.products.isEmpty) {
            final approved = isRestaurantApproved();
            return RefreshIndicator(
              onRefresh: () => controller.fetchProducts(isRefresh: true),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              approved
                                  ? Icons.restaurant_menu_outlined
                                  : Icons.hourglass_top_rounded,
                              size: 64,
                              color: approved ? Colors.grey.shade400 : Colors.orange.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              approved ? 'No Products Added Yet' : 'Account Verification Pending',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              approved
                                  ? 'Add items to your menu to start receiving orders.'
                                  : 'Once your restaurant registration is approved by admin, you will be able to add and publish products.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            if (approved)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                    ),
                                    onPressed: () => _onAddProduct(context),
                                    icon: const Icon(Icons.add, color: Colors.white),
                                    label: const Text(
                                      'Add Product',
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.primary,
                                      side: const BorderSide(color: AppColors.primary),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                    ),
                                    onPressed: () => Get.to(() => const CategoryScreen()),
                                    icon: const Icon(Icons.category_outlined),
                                    label: const Text(
                                      'Categories',
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => controller.fetchProducts(isRefresh: true),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: controller.products.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = controller.products[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Get.to(() => EditProductScreen(productData: item));
                  },
                  child: ProductCard(
                    title: item['title'] ?? '',
                    isVeg: item['isVeg'] ?? true,
                    originalPrice: item['originalPrice'] ?? '0',
                    discountedPrice: item['discountedPrice'] ?? '0',
                    discountText: item['discountText'] ?? '0%',
                    description: item['description'] ?? '',
                    image: item['image'],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}