import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';
import 'package:restaurant_app/src/core/utils/helper/texthelper.dart';
import 'package:restaurant_app/src/presentation/controller/auth/sign_in_controller.dart';
import 'package:restaurant_app/src/presentation/widgets/app_back_button.dart';
import 'package:restaurant_app/src/presentation/widgets/app_button.dart';
import 'package:restaurant_app/src/presentation/widgets/app_dashed_border.dart';
import 'package:restaurant_app/src/presentation/widgets/app_form_field.dart';
import 'package:restaurant_app/src/presentation/widgets/app_profile_image.dart';

class SignInScreen extends GetView<SignInController> {
  const SignInScreen({super.key});

  static const List<String> _titles = [
    'Register',
    'Document Details',
    'Bank Details',
    'Document Upload',
    'Legal Information',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
          child: Column(
            children: [
              Obx(
                () => _StepHeader(
                  title: _titles[controller.currentStep.value],
                  onBack: controller.previousStep,
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _RegisterStep(controller: controller),
                    _DocumentDetailsStep(controller: controller),
                    _BankDetailsStep(controller: controller),
                    _DocumentUploadStep(controller: controller),
                    _LegalInformationStep(controller: controller),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              AppButton(
                text: 'Continue',
                width: double.infinity,
                style: TextHelper.button,
                onPressed: controller.nextStep,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppBackButton(onPressed: onBack),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextHelper.login,
          ),
        ),
      ],
    );
  }
}

class _StepForm extends StatelessWidget {
  const _StepForm({required this.formKey, required this.children});

  final GlobalKey<FormState> formKey;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

class _RegisterStep extends StatelessWidget {
  const _RegisterStep({required this.controller});

  final SignInController controller;

  @override
  Widget build(BuildContext context) {
    return _StepForm(
      formKey: controller.formKeys[0],
      children: [
        Center(
          child: Semantics(
            button: true,
            label: 'Add restaurant profile photo',
            child: SizedBox(
              width: 110,
              height: 110,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  const AppProfileImage(size: 110),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.12),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.textprimary.withValues(
                              alpha: 0.08,
                            ),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: SvgPicture.asset(camera, width: 30, height: 30),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        AppFormField(
          label: 'Restaurant Name',
          controller: controller.restaurantNameController,
          validator: controller.requiredValidator,
        ),
        const SizedBox(height: 12),
        AppFormField(
          label: 'Owner Name',
          controller: controller.ownerNameController,
          validator: controller.requiredValidator,
        ),
        const SizedBox(height: 12),
        AppFormField(
          label: 'Phone No',
          controller: controller.phoneController,
          keyboardType: TextInputType.phone,
          prefixText: '+91  ',
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validator: controller.requiredValidator,
        ),
        const SizedBox(height: 12),
        AppFormField(
          label: 'Email',
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          validator: controller.requiredValidator,
        ),
        const SizedBox(height: 12),
        AppFormField(label: 'City', controller: controller.cityController),
        const SizedBox(height: 12),
        AppFormField(label: 'State', controller: controller.stateController),
        const SizedBox(height: 12),
        _RestaurantTypeField(controller: controller),
        const SizedBox(height: 12),
        AppFormField(
          label: 'Pincode',
          controller: controller.pincodeController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
        ),
      ],
    );
  }
}

class _RestaurantTypeField extends StatelessWidget {
  const _RestaurantTypeField({required this.controller});

  final SignInController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Restaurant Type', style: TextHelper.heading2),
        const SizedBox(height: 6),
        Obx(
          () => DropdownButtonFormField<String>(
            initialValue: controller.restaurantType.value,
            hint: Text(
              'Select',
              style: TextHelper.heading2.copyWith(
                color: AppColors.textprimary.withValues(alpha: 0.3),
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'Vegetarian', child: Text('Vegetarian')),
              DropdownMenuItem(
                value: 'Non-Vegetarian',
                child: Text('Non-Vegetarian'),
              ),
              DropdownMenuItem(value: 'Both', child: Text('Both')),
            ],
            onChanged: controller.setRestaurantType,
            style: TextHelper.heading2.copyWith(fontSize: 12),
            isDense: true,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              enabledBorder: _fieldBorder(
                AppColors.primary.withValues(alpha: 0.2),
              ),
              focusedBorder: _fieldBorder(AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

class _DocumentDetailsStep extends StatelessWidget {
  const _DocumentDetailsStep({required this.controller});

  final SignInController controller;

  @override
  Widget build(BuildContext context) {
    return _StepForm(
      formKey: controller.formKeys[1],
      children: [
        AppFormField(
          label: 'FSSAI License Number',
          isRequired: true,
          controller: controller.fssaiController,
          validator: controller.requiredValidator,
        ),
        const SizedBox(height: 16),
        AppFormField(
          label: 'Aadhaar Number',
          isRequired: true,
          controller: controller.aadhaarController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(12),
          ],
          validator: controller.requiredValidator,
        ),
        const SizedBox(height: 16),
        AppFormField(
          label: 'PAN Number',
          isRequired: true,
          controller: controller.panController,
          validator: controller.requiredValidator,
        ),
        const SizedBox(height: 16),
        AppFormField(
          label: 'GSTIN (Optional)',
          controller: controller.gstController,
        ),
      ],
    );
  }
}

class _BankDetailsStep extends StatelessWidget {
  const _BankDetailsStep({required this.controller});

  final SignInController controller;

  @override
  Widget build(BuildContext context) {
    return _StepForm(
      formKey: controller.formKeys[2],
      children: [
        AppFormField(
          label: 'Account Holder Name',
          isRequired: true,
          controller: controller.accountHolderController,
          validator: controller.requiredValidator,
        ),
        const SizedBox(height: 16),
        AppFormField(
          label: 'Bank Name',
          isRequired: true,
          controller: controller.bankNameController,
          validator: controller.requiredValidator,
        ),
        const SizedBox(height: 16),
        AppFormField(
          label: 'Account Number',
          isRequired: true,
          controller: controller.accountNumberController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: controller.requiredValidator,
        ),
        const SizedBox(height: 16),
        AppFormField(
          label: 'IFSC Code',
          isRequired: true,
          controller: controller.ifscController,
          validator: controller.requiredValidator,
        ),
        const SizedBox(height: 16),
        AppFormField(
          label: 'Branch Name',
          isRequired: true,
          controller: controller.branchNameController,
          validator: controller.requiredValidator,
        ),
        const SizedBox(height: 16),
        AppFormField(
          label: 'UPI ID (Optional)',
          controller: controller.upiController,
        ),
      ],
    );
  }
}

class _DocumentUploadStep extends StatelessWidget {
  const _DocumentUploadStep({required this.controller});

  final SignInController controller;

  static const List<String> documents = [
    'FSSAI Certificate',
    'Aadhaar Card',
    'PAN Card',
    'GST Certificate',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        children: [
          for (final document in documents) ...[
            _DocumentUploadTile(label: document, controller: controller),
            const SizedBox(height: 11),
          ],
        ],
      ),
    );
  }
}

class _DocumentUploadTile extends StatelessWidget {
  const _DocumentUploadTile({required this.label, required this.controller});

  final String label;
  final SignInController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: 'Upload $label',
            style: TextHelper.heading2,
            children: [
              TextSpan(
                text: ' *',
                style: TextHelper.heading2.copyWith(
                  color: AppColors.red,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 7),
        Obx(() {
          final isSelected = controller.selectedDocuments.contains(label);

          return InkWell(
            onTap: () => controller.selectDocument(label),
            borderRadius: BorderRadius.circular(6),
            child: AppDashedBorder(
              color: isSelected
                  ? AppColors.green
                  : AppColors.red.withValues(alpha: 0.24),
              borderRadius: 6,
              child: SizedBox(
                width: double.infinity,
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isSelected
                        ? const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.green,
                            size: 20,
                          )
                        : SvgPicture.asset(uploadIcon, width: 18, height: 21),
                    const SizedBox(height: 4),
                    Text(
                      isSelected ? 'Selected' : 'Click To Upload',
                      style: TextHelper.heading2.copyWith(
                        color: isSelected
                            ? AppColors.green
                            : AppColors.textprimary,
                        fontSize: 9,
                      ),
                    ),
                    if (!isSelected)
                      Text(
                        '(Max file size: 5 MB, jpg only)',
                        style: TextHelper.heading2.copyWith(
                          color: AppColors.textprimary.withValues(alpha: 0.35),
                          fontSize: 7,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _LegalInformationStep extends StatelessWidget {
  const _LegalInformationStep({required this.controller});

  final SignInController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKeys[4],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LegalTextArea(
            label: 'Terms & condition',
            controller: controller.termsController,
            validator: controller.requiredValidator,
          ),
          const SizedBox(height: 10),
          _LegalTextArea(
            label: 'Privacy & Policy',
            controller: controller.privacyController,
            validator: controller.requiredValidator,
          ),
          const Spacer(),
          _AcceptanceRow(controller: controller),
          const SizedBox(height: 2),
        ],
      ),
    );
  }
}

class _LegalTextArea extends StatelessWidget {
  const _LegalTextArea({
    required this.label,
    required this.controller,
    required this.validator,
  });

  final String label;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextHelper.heading2),
        const SizedBox(height: 7),
        AppDashedBorder(
          color: AppColors.red.withValues(alpha: 0.22),
          borderRadius: 5,
          child: SizedBox(
            height: 100,
            child: TextFormField(
              controller: controller,
              validator: validator,
              expands: true,
              maxLines: null,
              minLines: null,
              textAlignVertical: TextAlignVertical.top,
              style: TextHelper.heading2.copyWith(fontSize: 10),
              decoration: InputDecoration(
                hintText: 'Enter',
                hintStyle: TextHelper.heading2.copyWith(
                  color: AppColors.textprimary.withValues(alpha: 0.25),
                ),
                contentPadding: const EdgeInsets.fromLTRB(11, 9, 11, 7),
                border: InputBorder.none,
                errorStyle: const TextStyle(height: 0, fontSize: 0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AcceptanceRow extends StatelessWidget {
  const _AcceptanceRow({required this.controller});

  final SignInController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            checked: controller.acceptedTerms.value,
            label: 'Accept Terms of Service and Privacy Policy',
            child: InkWell(
              onTap: controller.acceptedTerms.toggle,
              borderRadius: BorderRadius.circular(2),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 15,
                height: 15,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: controller.acceptedTerms.value
                      ? AppColors.primary
                      : Colors.transparent,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.8),
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: controller.acceptedTerms.value
                    ? const Icon(
                        Icons.check_rounded,
                        color: AppColors.white,
                        size: 11,
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: 'Registration implies acceptance of the ',
                style: TextHelper.heading2.copyWith(
                  color: AppColors.textprimary.withValues(alpha: 0.55),
                  fontSize: 10,
                ),
                children: [
                  TextSpan(
                    text: 'Terms of Service',
                    style: TextHelper.heading2.copyWith(
                      color: AppColors.primary,
                      fontSize: 8,
                    ),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy.',
                    style: TextHelper.heading2.copyWith(
                      color: AppColors.primary,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

OutlineInputBorder _fieldBorder(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(7),
    borderSide: BorderSide(color: color),
  );
}
