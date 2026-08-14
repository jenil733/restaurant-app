import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/presentation/controller/edit_product_controller.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';
import 'package:restaurant_app/src/presentation/view/products/widgets/product_dropdown.dart';
import 'package:restaurant_app/src/presentation/view/products/widgets/product_textfield.dart';
import 'package:restaurant_app/src/presentation/view/products/widgets/upload_image_widget.dart';
import 'package:restaurant_app/src/presentation/widgets/app_bar.dart';
import 'package:restaurant_app/src/presentation/widgets/button.dart';

class EditProductScreen extends StatelessWidget {
  const EditProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProductController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
  title: "Edit Product",
  actions: [
    Padding(
      padding: const EdgeInsets.only(right: 20),
      child: SizedBox(
        height: 30,
        child: ElevatedButton(
          onPressed: () {
             showDeleteProductDialog(context, controller);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF3B3B),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: const Text(
            "Delete Product",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    ),
  ],
),
      body: GetBuilder<EditProductController>(
        builder: (controller) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              const Text(
                "Upload Image",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppColors.textprimary,
                ),
              ),

              const SizedBox(height: 12),

              const UploadImageWidget(),

              const SizedBox(height: 8),

              GestureDetector(
                onTap: () {
                  showImageDialog(context);
                },
                child: const Text(
                  "product_image1.png",
                  style: TextStyle(
                    color: AppColors.red,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.red,
                  ),
                ),
              ),

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
              
              const SizedBox(height: 20),

              ProductDropdown(
                title: "Status",
                hint: "Select",
                value: controller.selectedStatus,
                items: const [
                  "Enable",
                  "Disable",
                ],
                onChanged: controller.setStatus,
              ),

              const SizedBox(height: 40),

              CustomButton(
                text: "Update",
                onTap: controller.updateProduct,
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      );
      }),
    );
  }
  void showDeleteProductDialog(BuildContext context, EditProductController controller) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Text(
                "Are you sure ?",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              const Divider(height: 1),

              const SizedBox(height: 16),

              const Text(
                "You want to",
                style: TextStyle(
                  color: Color(0xffA7B1C2),
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Delete this Product?",
                style: TextStyle(
                  color: Color(0xffA7B1C2),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 25),

              Row(
                children: [

                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xffD8D8D8),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Color(0xffA7B1C2),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          controller.deleteProduct();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffFF3D3D),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          "Ok, Sure",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

  void showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    product,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: -16,
                right: -16,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.cancel,
                      color: Colors.red,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 