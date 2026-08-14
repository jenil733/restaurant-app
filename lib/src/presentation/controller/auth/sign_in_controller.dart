import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/presentation/widgets/app_notification.dart';

class SignInController extends GetxController {
  static const int stepCount = 5;

  bool _isTransitioning = false;

  final PageController pageController = PageController();
  final List<GlobalKey<FormState>> formKeys = List.generate(
    stepCount,
    (_) => GlobalKey<FormState>(),
  );
  final RxInt currentStep = 0.obs;
  final RxnString restaurantType = RxnString();
  final RxSet<String> selectedDocuments = <String>{}.obs;
  final RxBool acceptedTerms = false.obs;

  final restaurantNameController = TextEditingController();
  final ownerNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final cityController = TextEditingController();
  final streetController = TextEditingController();
  final addressController = TextEditingController();
  final pincodeController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final fssaiController = TextEditingController();
  final aadhaarController = TextEditingController();
  final panController = TextEditingController();
  final gstController = TextEditingController();
  final accountHolderController = TextEditingController();
  final bankNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final ifscController = TextEditingController();
  final branchNameController = TextEditingController();
  final upiController = TextEditingController();
  final termsController = TextEditingController();
  final privacyController = TextEditingController();

  List<TextEditingController> get _controllers => [
    restaurantNameController,
    ownerNameController,
    phoneController,
    emailController,
    cityController,
    streetController,
    addressController,
    pincodeController,
    startTimeController,
    endTimeController,
    fssaiController,
    aadhaarController,
    panController,
    gstController,
    accountHolderController,
    bankNameController,
    accountNumberController,
    ifscController,
    branchNameController,
    upiController,
    termsController,
    privacyController,
  ];

  String? requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  void setRestaurantType(String? value) {
    restaurantType.value = value;
  }

  void selectDocument(String document) {
    selectedDocuments.add(document);
    AppNotification.showSuccess(
      title: 'Document selected',
      message: '$document is ready to upload.',
    );
  }

  Future<void> nextStep() async {
    if (_isTransitioning) {
      return;
    }

    _isTransitioning = true;
    try {
      await _dismissKeyboard();

      if (currentStep.value != 3 &&
          !(formKeys[currentStep.value].currentState?.validate() ?? true)) {
        return;
      }

      if (currentStep.value == 0 && restaurantType.value == null) {
        AppNotification.showError(
          title: 'Restaurant type required',
          message: 'Select your restaurant type to continue.',
        );
        return;
      }

      if (currentStep.value == 3 && selectedDocuments.length < 4) {
        AppNotification.showError(
          title: 'Documents required',
          message: 'Select all four required documents to continue.',
        );
        return;
      }

      if (currentStep.value == stepCount - 1) {
        if (!acceptedTerms.value) {
          AppNotification.showError(
            title: 'Acceptance required',
            message: 'Accept the Terms of Service and Privacy Policy.',
          );
          return;
        }

        Get.back<void>();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AppNotification.showSuccess(
            title: 'Registration complete',
            message: 'Your restaurant details were submitted successfully.',
          );
        });
        return;
      }

      if (!pageController.hasClients) {
        return;
      }

      currentStep.value++;
      await pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } finally {
      _isTransitioning = false;
    }
  }

  Future<void> previousStep() async {
    if (_isTransitioning) {
      return;
    }

    _isTransitioning = true;
    try {
      await _dismissKeyboard();

      if (currentStep.value == 0) {
        Get.back<void>();
        return;
      }

      if (!pageController.hasClients) {
        return;
      }

      currentStep.value--;
      await pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } finally {
      _isTransitioning = false;
    }
  }

  Future<void> _dismissKeyboard() async {
    final focus = FocusManager.instance.primaryFocus;
    if (focus == null || !focus.hasFocus) {
      return;
    }

    focus.unfocus();
    await WidgetsBinding.instance.endOfFrame;
  }

  @override
  void onClose() {
    final cachedPageController = pageController;
    final cachedControllers = List<TextEditingController>.from(_controllers);
    
    Future.delayed(const Duration(milliseconds: 500), () {
      cachedPageController.dispose();
      for (final controller in cachedControllers) {
        controller.dispose();
      }
    });
    
    super.onClose();
  }
}
