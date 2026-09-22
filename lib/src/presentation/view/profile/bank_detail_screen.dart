import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/data/models/update_bank_details_model.dart';
import 'package:restaurant_app/src/presentation/controller/bank_details_controller.dart';
import 'package:restaurant_app/src/presentation/controller/profile_controller.dart';
import 'package:restaurant_app/src/presentation/widgets/app_bar.dart';
import 'package:restaurant_app/src/presentation/widgets/app_notification.dart';
import 'package:restaurant_app/src/presentation/widgets/button.dart';

class BankDetailsScreen extends StatefulWidget {
  const BankDetailsScreen({super.key});

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  late final BankDetailsController controller;
  late final ProfileController profileController;

  late final TextEditingController holderController;
  late final TextEditingController bankController;
  late final TextEditingController accountController;
  late final TextEditingController ifscController;
  late final TextEditingController branchController;
  late final TextEditingController upiController;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<BankDetailsController>()
        ? Get.find<BankDetailsController>()
        : Get.put(BankDetailsController());

    profileController = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());

    holderController = TextEditingController(text: profileController.accountHolder.value);
    bankController = TextEditingController(text: profileController.bankName.value);
    accountController = TextEditingController(text: profileController.accountNumber.value);
    ifscController = TextEditingController(text: profileController.ifsc.value);
    branchController = TextEditingController(text: profileController.branch.value);
    upiController = TextEditingController(text: profileController.upiId.value);
  }

  @override
  void dispose() {
    holderController.dispose();
    bankController.dispose();
    accountController.dispose();
    ifscController.dispose();
    branchController.dispose();
    upiController.dispose();
    super.dispose();
  }

  Future<void> _submitUpdate() async {
    final bankName = bankController.text.trim();
    final accountNumber = accountController.text.trim();
    final ifsc = ifscController.text.trim();
    final branch = branchController.text.trim();

    if (bankName.isEmpty) {
      AppNotification.showError(
        title: "Required Field",
        message: "Please enter Bank Name",
      );
      return;
    }

    if (accountNumber.isEmpty) {
      AppNotification.showError(
        title: "Required Field",
        message: "Please enter Account Number",
      );
      return;
    }

    if (ifsc.isEmpty) {
      AppNotification.showError(
        title: "Required Field",
        message: "Please enter IFSC Code",
      );
      return;
    }

    if (branch.isEmpty) {
      AppNotification.showError(
        title: "Required Field",
        message: "Please enter Branch Name",
      );
      return;
    }

    final request = UpdateBankDetailsRequestModel(
      accountHolder: holderController.text.trim(),
      bankName: bankName,
      accountNumber: accountNumber,
      ifsc: ifsc,
      branch: branch,
      upiId: upiController.text.trim(),
    );

    await controller.updateBankDetails(request);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
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
                        keyboardType: TextInputType.number,
                      ),
                      buildField(
                        "IFSC Code",
                        ifscController,
                        required: true,
                        textCapitalization: TextCapitalization.characters,
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
              const SizedBox(height: 16),
              Obx(
                () => CustomButton(
                  text: "Update",
                  isLoading: controller.isUpdating.value,
                  onTap: _submitUpdate,
                ),
              ),
              const SizedBox(height: 16),
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
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: title,
              style: const TextStyle(
                fontSize: 16,
              ),
              children: [
                if (required)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            readOnly: readOnly,
            keyboardType: keyboardType,
            textCapitalization: textCapitalization,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: readOnly ? const Color(0xFFF2F2F7) : Colors.white,
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