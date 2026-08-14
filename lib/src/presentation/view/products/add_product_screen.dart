import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/utils/helper/texthelper.dart';
import 'package:restaurant_app/src/presentation/controller/add_product_controller.dart';
import 'package:restaurant_app/src/presentation/view/products/widgets/product_dropdown.dart';
import 'package:restaurant_app/src/presentation/view/products/widgets/product_textfield.dart';
import 'package:restaurant_app/src/presentation/view/products/widgets/upload_image_widget.dart';

import 'package:restaurant_app/src/presentation/widgets/app_bar.dart';
import 'package:restaurant_app/src/presentation/widgets/button.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddProductController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: "Add Product",
      ),
      body: GetBuilder<AddProductController>(
        builder: (controller) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text(
                "Upload Image",
                style: TextHelper.button.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              const UploadImageWidget(),

              const SizedBox(height: 24),

              ProductTextField(
                title: "Name",
                hint: "Enter",
                controller: controller.nameController,
              ),

              const SizedBox(height: 20),

              ProductDropdown(
                title: "Category",
                hint: "Select",
                value: controller.selectedCategory,
                items: const [
                  "Pizza",
                  "Burger",
                  "Drinks",
                ],
                onChanged: controller.setCategory,
              ),

              const SizedBox(height: 20),

              ProductDropdown(
                title: "Food Type",
                hint: "Select",
                value: controller.selectedFoodType,
                items: const [
                  "Veg",
                  "Non-Veg",
                ],
                onChanged: controller.setFoodType,
              ),

              const SizedBox(height: 20),

              ProductTextField(
                title: "Description",
                hint: "Enter",
                maxLines: 4,
                controller: controller.descriptionController,
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: ProductTextField(
                      title: "MRP",
                      hint: "₹0.00",
                      controller: controller.mrpController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ProductTextField(
                      title: "Discount",
                      hint: "0%",
                      controller: controller.discountController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ProductTextField(
                      title: "Sell Price",
                      hint: "₹0.00",
                      controller: controller.sellPriceController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              CustomButton(
                text: "Submit",
                onTap: controller.submit,
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      );
      }),
    );
  }
}