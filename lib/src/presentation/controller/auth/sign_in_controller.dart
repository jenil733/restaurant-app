import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_app/src/core/di/service_locator.dart';
import 'package:restaurant_app/src/core/error/failure.dart';
import 'package:restaurant_app/src/core/services/api_services.dart';
import 'package:restaurant_app/src/data/models/register_model.dart';
import 'package:restaurant_app/src/data/models/restaurant_resend_otp_model.dart';
import 'package:restaurant_app/src/data/repository/otp_repository_impl.dart';
import 'package:restaurant_app/src/data/repository/register_repository_impl.dart';
import 'package:restaurant_app/src/domain/usecase/register_usecase.dart';
import 'package:restaurant_app/src/domain/usecase/resend_restaurant_otp_usecase.dart';
import 'package:restaurant_app/src/data/models/upload_document_model.dart';
import 'package:restaurant_app/src/data/repository/document_repository_impl.dart';
import 'package:restaurant_app/src/domain/usecase/upload_document_usecase.dart';
import 'package:restaurant_app/src/core/services/local_storage_services.dart';
import 'package:restaurant_app/src/core/utils/navigation/app_routes.dart';
import 'package:restaurant_app/src/presentation/controller/home_controller.dart';
import 'package:restaurant_app/src/presentation/widgets/app_notification.dart';

class SignInController extends GetxController {
  SignInController({
    RegisterUseCase? registerUseCase,
    ResendRestaurantOtpUseCase? resendRestaurantOtpUseCase,
  })  : _registerUseCase = registerUseCase ??
            (sl.isRegistered<RegisterUseCase>()
                ? sl<RegisterUseCase>()
                : RegisterUseCase(RegisterRepositoryImpl(ApiService()))),
        _resendRestaurantOtpUseCase = resendRestaurantOtpUseCase ??
            (sl.isRegistered<ResendRestaurantOtpUseCase>()
                ? sl<ResendRestaurantOtpUseCase>()
                : ResendRestaurantOtpUseCase(OtpRepositoryImpl(ApiService())));

  static const int stepCount = 4;

  static const List<String> availableRestaurantTypes = [
    'Veg',
    'Non-Veg',
    'Both',
  ];

  final RegisterUseCase _registerUseCase;
  final ResendRestaurantOtpUseCase _resendRestaurantOtpUseCase;
  final ImagePicker _picker = ImagePicker();

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
  final RxBool isLoading = false.obs;

  // File paths for upload
  final RxnString profileImagePath = RxnString();
  final RxnString fssaiFilePath = RxnString();
  final RxnString aadharFilePath = RxnString();
  final RxnString panFilePath = RxnString();
  final RxnString gstFilePath = RxnString();

  final restaurantNameController = TextEditingController();
  final ownerNameController = TextEditingController();
  final phoneController = TextEditingController();
  final restaurantTypeController = TextEditingController();
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
    restaurantTypeController,
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

  String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (value.trim().length != 10) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  String? pincodeValidator(String? value) {
    if (value != null && value.trim().isNotEmpty && value.trim().length != 6) {
      return 'Pincode must be 6 digits';
    }
    return null;
  }

  String? fssaiValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'FSSAI License number is required';
    }
    final clean = value.trim();
    if (clean.length != 14 || !RegExp(r'^[0-9]{14}$').hasMatch(clean)) {
      return 'FSSAI License number must be exactly 14 digits';
    }
    return null;
  }

  String? aadhaarValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Aadhaar number is required';
    }
    final clean = value.trim();
    if (clean.length != 12 || !RegExp(r'^[0-9]{12}$').hasMatch(clean)) {
      return 'Aadhaar number must be exactly 12 digits';
    }
    return null;
  }

  String? panValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'PAN number is required';
    }
    final clean = value.trim().toUpperCase();
    if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(clean)) {
      return 'Enter a valid 10-character PAN (e.g. ABCDE1234F)';
    }
    return null;
  }

  String? gstinValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final clean = value.trim().toUpperCase();
    if (!RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$').hasMatch(clean)) {
      return 'Enter a valid 15-character GSTIN (e.g. 22AAAAA0000A1Z5)';
    }
    return null;
  }

  String? accountHolderValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Account holder name is required';
    }
    if (value.trim().length < 2) {
      return 'Account holder name must be at least 2 characters';
    }
    return null;
  }

  String? bankNameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bank name is required';
    }
    if (value.trim().length < 2) {
      return 'Bank name must be at least 2 characters';
    }
    return null;
  }

  String? accountNumberValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Account number is required';
    }
    final clean = value.trim();
    if (clean.length < 9 || clean.length > 18 || !RegExp(r'^[0-9]+$').hasMatch(clean)) {
      return 'Account number must be between 9 and 18 digits';
    }
    return null;
  }

  String? ifscValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'IFSC code is required';
    }
    final clean = value.trim().toUpperCase();
    if (clean.length != 11 || !RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(clean)) {
      return 'Enter a valid 11-character IFSC code (e.g. SBIN0001234)';
    }
    return null;
  }

  String? branchNameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Branch name is required';
    }
    if (value.trim().length < 2) {
      return 'Branch name must be at least 2 characters';
    }
    return null;
  }

  String? upiValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final clean = value.trim();
    if (!RegExp(r'^[a-zA-Z0-9.\-_]{2,49}@[a-zA-Z0-9]{2,49}$').hasMatch(clean)) {
      return 'Please enter a valid UPI ID (e.g. user@okhdfcbank)';
    }
    return null;
  }

  void setRestaurantType(String? value) {
    restaurantType.value = value;
    if (value != null && restaurantTypeController.text != value) {
      restaurantTypeController.text = value;
    } else if (value == null && restaurantTypeController.text.isNotEmpty) {
      restaurantTypeController.clear();
    }
  }

  /// Pick profile image
  Future<void> pickProfileImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        profileImagePath.value = pickedFile.path;
        AppNotification.showSuccess(
          title: 'Profile photo selected',
          message: 'Restaurant image added successfully.',
        );
      }
    } catch (e) {
      AppNotification.showError(
        title: 'Error picking image',
        message: 'Could not access image: $e',
      );
    }
  }

  /// Pick document image/file
  Future<void> pickDocument(String documentType, ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        _assignDocumentPath(documentType, pickedFile.path);
        selectedDocuments.add(documentType);
        AppNotification.showSuccess(
          title: 'Document selected',
          message: '$documentType is ready to upload.',
        );
      }
    } catch (e) {
      AppNotification.showError(
        title: 'Error picking document',
        message: 'Could not select document: $e',
      );
    }
  }

  void _assignDocumentPath(String documentType, String path) {
    switch (documentType) {
      case 'FSSAI Certificate':
        fssaiFilePath.value = path;
        break;
      case 'Aadhaar Card':
        aadharFilePath.value = path;
        break;
      case 'PAN Card':
        panFilePath.value = path;
        break;
      case 'GST Certificate':
        gstFilePath.value = path;
        break;
    }
  }

  void selectDocument(String document) {
    selectedDocuments.add(document);
    AppNotification.showSuccess(
      title: 'Document selected',
      message: '$document is ready to upload.',
    );
  }

  Future<void> nextStep() async {
    if (_isTransitioning || isLoading.value) {
      return;
    }

    _isTransitioning = true;
    try {
      await _dismissKeyboard();

      if (currentStep.value < 3 &&
          !(formKeys[currentStep.value].currentState?.validate() ?? true)) {
        return;
      }

      if (currentStep.value == 0) {
        if (profileImagePath.value == null || profileImagePath.value!.trim().isEmpty) {
          AppNotification.showError(
            title: 'Photo required',
            message: 'Please upload restaurant profile photo to continue.',
          );
          return;
        }

        if (restaurantType.value == null || restaurantType.value!.trim().isEmpty) {
          AppNotification.showError(
            title: 'Restaurant type required',
            message: 'Select your restaurant type to continue.',
          );
          return;
        }
      }

      if (currentStep.value == 1 && selectedDocuments.length < 3) {
        AppNotification.showError(
          title: 'Documents required',
          message: 'Select at least FSSAI, Aadhaar, and PAN documents to continue.',
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

        await _submitRegistration();
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

  Future<void> _submitRegistration() async {
    isLoading.value = true;
    try {
      final request = RegisterRequestModel(
        name: restaurantNameController.text.trim(),
        ownerName: ownerNameController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        city: cityController.text.trim(),
        street: streetController.text.trim(),
        address: addressController.text.trim(),
        pincode: pincodeController.text.trim(),
        startTime: startTimeController.text.trim(),
        endTime: endTimeController.text.trim(),
        licenseNo: fssaiController.text.trim(),
        aadhar: aadhaarController.text.trim(),
        panNo: panController.text.trim(),
        gstin: gstController.text.trim(),
        accountHolder: accountHolderController.text.trim(),
        bankName: bankNameController.text.trim(),
        accountNumber: accountNumberController.text.trim(),
        ifscCode: ifscController.text.trim(),
        branchName: branchNameController.text.trim(),
        upiId: upiController.text.trim(),
        restaurantType: restaurantType.value,
        termsConditions: termsController.text.trim().isNotEmpty
            ? termsController.text.trim()
            : 'I agree to the terms',
        privacyPolicy: privacyController.text.trim().isNotEmpty
            ? privacyController.text.trim()
            : 'I agree to the privacy policy',
        imagePath: profileImagePath.value,
        fssaiFilePath: fssaiFilePath.value,
        aadharFilePath: aadharFilePath.value,
        panFilePath: panFilePath.value,
        gstFilePath: gstFilePath.value,
      );

      final response = await _registerUseCase(request);

      if (response.data is Map) {
        final resMap = response.data as Map;
        final possibleId = resMap['restaurant_id'] ??
            resMap['id'] ??
            resMap['user_id'] ??
            (resMap['restaurant'] is Map ? resMap['restaurant']['id'] : null);
        if (possibleId != null && possibleId.toString().trim().isNotEmpty) {
          await LocalStorageService().saveString('restaurant_id', possibleId.toString().trim());
        }
      }

      Get.back<void>();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppNotification.showSuccess(
          title: 'Registration complete',
          message: response.message.isNotEmpty
              ? response.message
              : 'Your restaurant details were submitted successfully.',
        );
      });
    } on Failure catch (e) {
      AppNotification.showError(
        title: 'Registration failed',
        message: e.message,
      );
    } catch (e) {
      AppNotification.showError(
        title: 'Registration error',
        message: 'Failed to submit registration: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> resendRestaurantOtp() async {
    if (isLoading.value) return false;

    final phone = phoneController.text.trim();
    if (phone.length < 10) {
      AppNotification.showError(
        title: 'Phone number required',
        message: 'Enter a valid 10-digit phone number.',
      );
      return false;
    }

    isLoading.value = true;
    try {
      final request = RestaurantResendOtpRequestModel(
        accountHolder: accountHolderController.text.trim(),
        bankName: bankNameController.text.trim(),
        accountNumber: accountNumberController.text.trim(),
        ifscCode: ifscController.text.trim(),
        branchName: branchNameController.text.trim(),
        upiId: upiController.text.trim(),
        phone: phone,
      );

      final response = await _resendRestaurantOtpUseCase(request);

      AppNotification.showSuccess(
        title: 'OTP Resent',
        message: response.message.isNotEmpty
            ? response.message
            : 'OTP sent successfully to +91 $phone',
      );
      return true;
    } on Failure catch (e) {
      AppNotification.showError(
        title: 'Failed to resend OTP',
        message: e.message,
      );
      return false;
    } catch (e) {
      AppNotification.showError(
        title: 'Error',
        message: 'Failed to resend OTP: $e',
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> previousStep() async {
    if (_isTransitioning || isLoading.value) {
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

  Future<void> submitReuploadDocuments() async {
    final hasFiles = selectedDocuments.isNotEmpty ||
        (fssaiFilePath.value != null && fssaiFilePath.value!.isNotEmpty) ||
        (gstFilePath.value != null && gstFilePath.value!.isNotEmpty) ||
        (panFilePath.value != null && panFilePath.value!.isNotEmpty) ||
        (aadharFilePath.value != null && aadharFilePath.value!.isNotEmpty);

    if (!hasFiles) {
      AppNotification.showError(
        title: 'Document Required',
        message: 'Please select a certificate/document file to upload.',
      );
      return;
    }

    isLoading.value = true;
    try {
      final uploadUseCase = sl.isRegistered<UploadDocumentUseCase>()
          ? sl<UploadDocumentUseCase>()
          : UploadDocumentUseCase(DocumentRepositoryImpl(ApiService()));

      final request = UploadDocumentRequestModel(
        fssaiFilePath: fssaiFilePath.value,
        gstFilePath: gstFilePath.value,
        panFilePath: panFilePath.value,
        aadharFilePath: aadharFilePath.value,
        fssaiNumber: fssaiController.text.trim(),
        aadhaarNumber: aadhaarController.text.trim(),
        panNumber: panController.text.trim(),
        gstNumber: gstController.text.trim(),
      );

      final response = await uploadUseCase(request);
      if (response.success) {
        if (Get.isRegistered<HomeController>()) {
          final homeCtrl = Get.find<HomeController>();
          homeCtrl.clearRejectionState();
          homeCtrl.refreshDashboard();
        } else {
          LocalStorageService().saveBool('has_reuploaded_documents', true);
        }

        Get.offAllNamed<void>(AppRoutes.home);

        AppNotification.showSuccess(
          title: 'Document Uploaded',
          message: response.message.isNotEmpty
              ? response.message
              : 'Certificate re-uploaded successfully.',
        );
      } else {
        AppNotification.showError(
          title: 'Upload Failed',
          message: response.message.isNotEmpty
              ? response.message
              : 'Could not upload document.',
        );
      }
    } catch (e) {
      debugPrint('Error uploading document: $e');
      final err = e
          .toString()
          .replaceAll('Exception:', '')
          .replaceAll('ServerFailure:', '')
          .trim();
      AppNotification.showError(
        title: 'Upload Failed',
        message: err.isNotEmpty ? err : 'Could not upload document.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.onClose();
  }
}
