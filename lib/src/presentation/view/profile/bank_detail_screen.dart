import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/presentation/widgets/app_bar.dart';
import 'package:restaurant_app/src/presentation/widgets/button.dart';

class BankDetailsScreen extends StatelessWidget {
  BankDetailsScreen({super.key});

  final holderController =
      TextEditingController(text: "John Miller");

  final bankController =
      TextEditingController(text: "State Bank of India");

  final accountController =
      TextEditingController(text: "XXXX XXXX 5678");

  final ifscController =
      TextEditingController(text: "SBIN0001234");

  final branchController =
      TextEditingController(text: "Nagercoil");

  final upiController =
      TextEditingController(text: "foodcorner@ybl");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: CustomAppBar(
        title: 'Bank Details',
        
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      buildField(
                        "Account Holder Name",
                        holderController,
                        required: true,
                      ),

                      buildField(
                        "Bank Name",
                        bankController,
                        required: true,
                      ),

                      buildField(
                        "Account Number",
                        accountController,
                        required: true,
                      ),

                      buildField(
                        "IFSC Code",
                        ifscController,
                        required: true,
                      ),

                      buildField(
                        "Branch Name",
                        branchController,
                        required: true,
                      ),

                      buildField(
                        "UPI ID (Optional)",
                        upiController,
                      ),
                    ],
                  ),
                ),
              ),
               const SizedBox(height: 20),  
               CustomButton(
  text: "Update",
  onTap: () {
    Get.snackbar(
                      "Success",
                      "Bank Details Updated",
                      snackPosition: SnackPosition.BOTTOM,
                    );
  },
),
      const SizedBox(height: 20),        
            ],
          ),
        ),
      ),
    );
  }

  Widget buildField(
  String title,
  TextEditingController controller, {
  bool required = false,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            filled: true,

            // Different background colors
            fillColor: required
                ? const Color(0xFFF2F2F7)
                : Colors.white,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 16,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.textBackground,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.textBackground,
              ),
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    ),
  );
}
}