import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restaurant_app/main.dart';
import 'package:restaurant_app/src/core/services/local_storage_services.dart';
import 'package:restaurant_app/src/core/utils/navigation/app_routes.dart';
import 'package:restaurant_app/src/presentation/controller/auth/login_controller.dart';
import 'package:restaurant_app/src/presentation/controller/auth/otp_controller.dart';
import 'package:restaurant_app/src/presentation/controller/auth/sign_in_controller.dart';
import 'package:restaurant_app/src/presentation/controller/auth/confirm_location_controller.dart';
import 'package:restaurant_app/src/presentation/controller/home_controller.dart';
import 'package:restaurant_app/src/presentation/view/auth/login/location_screen.dart';
import 'package:restaurant_app/src/presentation/view/auth/login/login_screen.dart';
import 'package:restaurant_app/src/presentation/view/auth/login/otp_verification_screen.dart';
import 'package:restaurant_app/src/presentation/view/auth/login/verification_success_screen.dart';
import 'package:restaurant_app/src/presentation/view/auth/sign_in/sign_in_screen.dart';
import 'package:restaurant_app/src/presentation/view/home/home_screen.dart';
import 'package:restaurant_app/src/presentation/view/onboarding screen/onboarding_screen.dart';
import 'package:restaurant_app/src/presentation/view/splash screen/splash_screen.dart';
import 'package:restaurant_app/src/core/di/service_locator.dart';
import 'package:restaurant_app/src/data/models/send_otp_model.dart';
import 'package:restaurant_app/src/domain/repository/otp_repository.dart';
import 'package:restaurant_app/src/domain/usecase/send_otp_usecase.dart';
import 'package:restaurant_app/src/domain/usecase/verify_otp_usecase.dart';
import 'package:restaurant_app/src/domain/usecase/resend_restaurant_otp_usecase.dart';
import 'package:restaurant_app/src/presentation/widgets/app_bottom_navigation_bar.dart';
import 'package:restaurant_app/src/presentation/widgets/app_notification.dart';

import 'package:restaurant_app/src/data/models/register_model.dart';
import 'package:restaurant_app/src/domain/repository/register_repository.dart';
import 'package:restaurant_app/src/domain/usecase/register_usecase.dart';
import 'package:restaurant_app/src/data/models/restaurant_resend_otp_model.dart';
import 'package:restaurant_app/src/data/models/verify_otp_model.dart';
import 'package:restaurant_app/src/data/models/product_model.dart';
import 'package:restaurant_app/src/domain/repository/product_repository.dart';
import 'package:restaurant_app/src/domain/usecase/get_restaurant_products_usecase.dart';
import 'package:restaurant_app/src/data/models/category_model.dart';
import 'package:restaurant_app/src/domain/repository/category_repository.dart';
import 'package:restaurant_app/src/domain/usecase/get_categories_usecase.dart';

class _FakeOtpRepository implements OtpRepository {
  @override
  Future<SendOtpResponseModel> sendOtp(SendOtpRequestModel request) async {
    return SendOtpResponseModel(
      success: true,
      message: 'OTP sent successfully',
      data: {'phone': request.phone},
    );
  }

  @override
  Future<RestaurantResendOtpResponseModel> resendRestaurantOtp(
    RestaurantResendOtpRequestModel request,
  ) async {
    return RestaurantResendOtpResponseModel(
      success: true,
      message: 'OTP resent successfully',
    );
  }

  @override
  Future<VerifyOtpResponseModel> verifyOtp(VerifyOtpRequestModel request) async {
    return VerifyOtpResponseModel(
      success: true,
      message: 'OTP verified successfully',
      data: {'token': 'fake_token', 'phone': request.phone},
    );
  }
}

class _FakeRegisterRepository implements RegisterRepository {
  @override
  Future<RegisterResponseModel> register(RegisterRequestModel request) async {
    return RegisterResponseModel(
      success: true,
      message: 'Your restaurant details were submitted successfully.',
    );
  }
}

class _FakeProductRepository implements ProductRepository {
  @override
  Future<ProductResponseModel> getProducts({Map<String, dynamic>? queryParams}) async {
    return ProductResponseModel(
      success: true,
      message: 'OK',
      products: [],
    );
  }

  @override
  Future<AddProductResponseModel> addProduct(AddProductRequestModel request) async {
    return AddProductResponseModel(success: true, message: 'OK');
  }

  @override
  Future<UpdateProductResponseModel> updateProduct(dynamic id, UpdateProductRequestModel request) async {
    return UpdateProductResponseModel(success: true, message: 'OK');
  }

  @override
  Future<DeleteProductResponseModel> deleteProduct(DeleteProductRequestModel request) async {
    return DeleteProductResponseModel(success: true, message: 'OK');
  }
}

class _FakeCategoryRepository implements CategoryRepository {
  @override
  Future<CategoryResponseModel> getCategories({Map<String, dynamic>? queryParams}) async {
    return CategoryResponseModel(success: true, message: 'OK', categories: []);
  }

  @override
  Future<AddCategoryResponseModel> addCategory(AddCategoryRequestModel request) async {
    return AddCategoryResponseModel(success: true, message: 'OK');
  }

  @override
  Future<DeleteCategoryResponseModel> deleteCategory(DeleteCategoryRequestModel request) async {
    return DeleteCategoryResponseModel(success: true, message: 'OK');
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    if (!sl.isRegistered<RegisterRepository>()) {
      sl.registerSingleton<RegisterRepository>(_FakeRegisterRepository());
    } else {
      sl.unregister<RegisterRepository>();
      sl.registerSingleton<RegisterRepository>(_FakeRegisterRepository());
    }
    if (!sl.isRegistered<RegisterUseCase>()) {
      sl.registerSingleton<RegisterUseCase>(RegisterUseCase(sl<RegisterRepository>()));
    } else {
      sl.unregister<RegisterUseCase>();
      sl.registerSingleton<RegisterUseCase>(RegisterUseCase(sl<RegisterRepository>()));
    }
    if (!sl.isRegistered<OtpRepository>()) {
      sl.registerSingleton<OtpRepository>(_FakeOtpRepository());
    } else {
      sl.unregister<OtpRepository>();
      sl.registerSingleton<OtpRepository>(_FakeOtpRepository());
    }
    if (!sl.isRegistered<SendOtpUseCase>()) {
      sl.registerSingleton<SendOtpUseCase>(SendOtpUseCase(sl<OtpRepository>()));
    } else {
      sl.unregister<SendOtpUseCase>();
      sl.registerSingleton<SendOtpUseCase>(SendOtpUseCase(sl<OtpRepository>()));
    }
    if (!sl.isRegistered<VerifyOtpUseCase>()) {
      sl.registerSingleton<VerifyOtpUseCase>(VerifyOtpUseCase(sl<OtpRepository>()));
    } else {
      sl.unregister<VerifyOtpUseCase>();
      sl.registerSingleton<VerifyOtpUseCase>(VerifyOtpUseCase(sl<OtpRepository>()));
    }
    if (!sl.isRegistered<ResendRestaurantOtpUseCase>()) {
      sl.registerSingleton<ResendRestaurantOtpUseCase>(ResendRestaurantOtpUseCase(sl<OtpRepository>()));
    } else {
      sl.unregister<ResendRestaurantOtpUseCase>();
      sl.registerSingleton<ResendRestaurantOtpUseCase>(ResendRestaurantOtpUseCase(sl<OtpRepository>()));
    }
    if (!sl.isRegistered<ProductRepository>()) {
      sl.registerSingleton<ProductRepository>(_FakeProductRepository());
    } else {
      sl.unregister<ProductRepository>();
      sl.registerSingleton<ProductRepository>(_FakeProductRepository());
    }
    if (!sl.isRegistered<GetRestaurantProductsUseCase>()) {
      sl.registerSingleton<GetRestaurantProductsUseCase>(GetRestaurantProductsUseCase(sl<ProductRepository>()));
    } else {
      sl.unregister<GetRestaurantProductsUseCase>();
      sl.registerSingleton<GetRestaurantProductsUseCase>(GetRestaurantProductsUseCase(sl<ProductRepository>()));
    }
    if (!sl.isRegistered<CategoryRepository>()) {
      sl.registerSingleton<CategoryRepository>(_FakeCategoryRepository());
    } else {
      sl.unregister<CategoryRepository>();
      sl.registerSingleton<CategoryRepository>(_FakeCategoryRepository());
    }
    if (!sl.isRegistered<GetCategoriesUseCase>()) {
      sl.registerSingleton<GetCategoriesUseCase>(GetCategoriesUseCase(sl<CategoryRepository>()));
    } else {
      sl.unregister<GetCategoriesUseCase>();
      sl.registerSingleton<GetCategoriesUseCase>(GetCategoriesUseCase(sl<CategoryRepository>()));
    }
  });

  testWidgets('moves from onboarding through OTP verification', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.byType(RepaintBoundary), findsWidgets);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.text('Manage Every Order in One Place'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Update Your Menu Anytime'), findsOneWidget);
    expect(find.text('Back'), findsOneWidget);

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);

    await tester.tap(find.byKey(const Key('sign-up-link')));
    await tester.pumpAndSettle();
    expect(find.byType(SignInScreen), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);

    await tester.enterText(find.byType(TextField), '9876543210');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.byType(OtpVerificationScreen), findsOneWidget);
    expect(find.byKey(const Key('edit-phone-button')), findsOneWidget);

    final otpField = find.byType(TextField);
    final otpController = Get.find<OtpController>();

    await tester.enterText(otpField, '1234');
    otpController.selectDigit(1);
    await tester.pump();

    expect(
      otpController.otpController.selection,
      const TextSelection(baseOffset: 1, extentOffset: 2),
    );

    tester.testTextInput.updateEditingValue(
      const TextEditingValue(
        text: '134',
        selection: TextSelection.collapsed(offset: 1),
      ),
    );
    await tester.pump();
    expect(otpController.otpController.text, '134');

    await tester.enterText(otpField, '1234');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Continue'));
    await tester.pumpAndSettle();

    expect(find.byType(VerificationSuccessScreen), findsOneWidget);
    expect(find.text('OTP Verified\nSuccessfully'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.byType(LocationScreen), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });

  testWidgets('document upload and legal steps fit a phone screen', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(375, 812));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
      Get.reset();
    });

    final controller = Get.put(SignInController());
    await tester.pumpWidget(const GetMaterialApp(home: SignInScreen()));

    controller.currentStep.value = 1;
    controller.pageController.jumpToPage(1);
    await tester.pumpAndSettle();

    expect(find.text('Document Details'), findsOneWidget);
    expect(find.text('Click To Upload'), findsNWidgets(4));
    expect(tester.takeException(), isNull);

    controller.currentStep.value = 3;
    controller.pageController.jumpToPage(3);
    await tester.pumpAndSettle();

    expect(find.text('Legal Information'), findsOneWidget);
    expect(find.text('Terms & condition'), findsOneWidget);
    expect(find.text('Privacy & Policy'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.showKeyboard(find.byType(TextFormField).first);
    final firstBack = controller.previousStep();
    final repeatedBack = controller.previousStep();
    await tester.pumpAndSettle();
    await Future.wait([firstBack, repeatedBack]);

    expect(controller.currentStep.value, 2);
    expect(find.text('Bank Details'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('login fits with keyboard and top notification', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(375, 640));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
      Get.reset();
    });

    Get.put(LoginController());
    await tester.pumpWidget(const GetMaterialApp(home: LoginScreen()));

    AppNotification.showSuccess(
      title: 'Registration complete',
      message: 'Your restaurant details were submitted successfully.',
    );
    await tester.pump();
    await tester.showKeyboard(find.byType(TextField));
    await tester.pumpAndSettle();

    expect(find.text('Registration complete'), findsOneWidget);
    expect(find.text('Login'), findsNWidgets(2));
    expect(tester.takeException(), isNull);

    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });

  testWidgets('registration returns to the existing login controller', (
    WidgetTester tester,
  ) async {
    addTearDown(Get.reset);

    await tester.pumpWidget(
      GetMaterialApp(initialRoute: AppRoutes.login, getPages: AppRoutes.pages),
    );
    final originalLoginController = Get.find<LoginController>();

    await tester.tap(find.byKey(const Key('sign-up-link')));
    await tester.pumpAndSettle();

    final signInController = Get.find<SignInController>();
    signInController.currentStep.value = 3;
    signInController.pageController.jumpToPage(3);
    signInController.termsController.text = 'Terms';
    signInController.privacyController.text = 'Privacy';
    signInController.acceptedTerms.value = true;
    await tester.pump();

    final registration = signInController.nextStep();
    await tester.pump();
    await registration;
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(Get.find<LoginController>(), same(originalLoginController));
    expect(
      () => originalLoginController.phoneController.text = '9876543210',
      returnsNormally,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'bottom navigation renders every selected state and handles taps',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(375, 812));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      var tappedIndex = -1;
      const labels = ['Home', 'Orders', 'Add', 'Profile'];

      for (var index = 0; index < labels.length; index++) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              bottomNavigationBar: AppBottomNavigationBar(
                currentIndex: index,
                onTap: (value) => tappedIndex = value,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text(labels[index]), findsOneWidget);
        expect(tester.takeException(), isNull);
      }

      await tester.tap(find.byKey(const Key('bottom-navigation-add')));
      expect(tappedIndex, 2);
    },
  );

  testWidgets('home dashboard fits a phone and animates between tabs', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
      Get.reset();
    });

    Get.put(HomeController());
    await tester.pumpWidget(GetMaterialApp(home: HomeScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Recent Orders'), findsOneWidget);
    expect(find.text('Orders'), findsWidgets);
    expect(find.text('Product'), findsWidgets);

    await tester.tap(find.byKey(const Key('bottom-navigation-profile')));
    await tester.pump(const Duration(milliseconds: 160));
    await tester.pumpAndSettle();

    expect(find.text('Profile'), findsWidgets);
    expect(Get.find<HomeController>().currentIndex.value, 3);

    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });

  testWidgets('confirm location navigates directly to home screen', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(375, 812));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
      Get.reset();
    });

    Get.put(LocationConfirmController());
    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: AppRoutes.confirmlocation,
        getPages: AppRoutes.pages,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Current Location Found'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Confirm Location'), findsOneWidget);

    // Tap Confirm Location -> should go directly to HomeScreen
    await tester.tap(find.widgetWithText(ElevatedButton, 'Confirm Location'));
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });

  testWidgets('splash screen navigates directly to home screen when already logged in', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(375, 812));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
      Get.reset();
    });

    SharedPreferences.setMockInitialValues({'is_logged_in': true, 'auth_token': 'dummy_token'});
    await LocalStorageService().init();

    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: AppRoutes.splash,
        getPages: AppRoutes.pages,
      ),
    );

    expect(find.byType(SplashScreen), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });
}
