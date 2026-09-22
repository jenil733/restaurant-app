import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/utils/helper/texthelper.dart';
import 'package:restaurant_app/src/presentation/controller/category_controller.dart';
import 'package:restaurant_app/src/presentation/view/products/widgets/product_textfield.dart';
import 'package:restaurant_app/src/presentation/view/products/widgets/upload_image_widget.dart';
import 'package:restaurant_app/src/presentation/widgets/app_bar.dart';
import 'package:restaurant_app/src/presentation/widgets/app_notification.dart';
import 'package:restaurant_app/src/presentation/widgets/button.dart';

class AddCategoryScreen extends StatelessWidget {
  final String? initialName;
  const AddCategoryScreen({super.key, this.initialName});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<CategoryController>()
        ? Get.find<CategoryController>()
        : Get.put(CategoryController());

    if (initialName != null &&
        initialName!.trim().isNotEmpty &&
        controller.addNameController.text.isEmpty) {
      controller.addNameController.text = initialName!.trim();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: "Add Category",
      ),
      body: GetBuilder<CategoryController>(
        builder: (controller) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Upload Category Image",
                    style: TextHelper.button.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  UploadImageWidget(
                    imagePath: controller.selectedImagePath,
                    onSourceSelected: controller.pickCategoryImage,
                    onRemove: controller.removeCategoryImage,
                  ),
                  const SizedBox(height: 24),
                  ProductTextField(
                    title: "Category Name",
                    hint: "e.g. Pizza, Burger, Desserts",
                    controller: controller.addNameController,
                  ),
                  const SizedBox(height: 20),
                  ProductTextField(
                    title: "Description (Optional)",
                    hint: "Enter a short description about this category",
                    maxLines: 4,
                    controller: controller.addDescController,
                  ),
                  const SizedBox(height: 40),
                  CustomButton(
                    text: "Add Category",
                    isLoading: controller.isAddingCategory,
                    onTap: () async {
                      final categoryName =
                          controller.addNameController.text.trim();
                      final success = await controller.addCategory();
                      if (success) {
                        Get.back();
                        AppNotification.showSuccess(
                          title: 'Category Added',
                          message: categoryName.isNotEmpty
                              ? "Category '$categoryName' added successfully."
                              : "Category added successfully.",
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
