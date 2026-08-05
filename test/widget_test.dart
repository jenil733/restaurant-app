import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/main.dart';
import 'package:restaurant_app/src/core/utils/navigation/app_routes.dart';
import 'package:restaurant_app/src/presentation/controller/auth/login_controller.dart';
import 'package:restaurant_app/src/presentation/controller/auth/otp_controller.dart';
import 'package:restaurant_app/src/presentation/controller/auth/sign_in_controller.dart';
import 'package:restaurant_app/src/presentation/controller/home_controller.dart';
import 'package:restaurant_app/src/presentation/view/auth/login/login_screen.dart';
import 'package:restaurant_app/src/presentation/view/auth/login/otp_verification_screen.dart';
import 'package:restaurant_app/src/presentation/view/auth/login/verification_success_screen.dart';
import 'package:restaurant_app/src/presentation/view/auth/sign_in/sign_in_screen.dart';
import 'package:restaurant_app/src/presentation/view/home/home_screen.dart';
import 'package:restaurant_app/src/presentation/view/onboarding screen/onboarding_screen.dart';
import 'package:restaurant_app/src/presentation/view/splash screen/splash_screen.dart';
import 'package:restaurant_app/src/presentation/widgets/app_bottom_navigation_bar.dart';
import 'package:restaurant_app/src/presentation/widgets/app_notification.dart';

void main() {
  testWidgets('moves from onboarding through OTP verification', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.byType(SvgPicture), findsOneWidget);

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

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Recent Orders'), findsOneWidget);
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

    controller.currentStep.value = 3;
    controller.pageController.jumpToPage(3);
    await tester.pumpAndSettle();

    expect(find.text('Document Upload'), findsOneWidget);
    expect(find.text('Click To Upload'), findsNWidgets(4));
    expect(tester.takeException(), isNull);

    controller.currentStep.value = 4;
    controller.pageController.jumpToPage(4);
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

    expect(controller.currentStep.value, 3);
    expect(find.text('Document Upload'), findsOneWidget);
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

    await tester.pump(const Duration(seconds: 3));
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
    signInController.currentStep.value = 4;
    signInController.pageController.jumpToPage(4);
    signInController.termsController.text = 'Terms';
    signInController.privacyController.text = 'Privacy';
    signInController.acceptedTerms.value = true;
    await tester.pump();

    final registration = signInController.nextStep();
    await tester.pump();
    await registration;
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(Get.find<LoginController>(), same(originalLoginController));
    expect(
      () => originalLoginController.phoneController.text = '9876543210',
      returnsNormally,
    );
    expect(tester.takeException(), isNull);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
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
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
      Get.reset();
    });

    Get.put(HomeController());
    await tester.pumpWidget(const GetMaterialApp(home: HomeScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Recent Orders'), findsOneWidget);
    expect(find.text('Orders'), findsWidgets);
    expect(find.text('Product'), findsWidgets);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const Key('bottom-navigation-profile')));
    await tester.pump(const Duration(milliseconds: 160));
    await tester.pumpAndSettle();

    expect(find.text('Profile'), findsWidgets);
    expect(Get.find<HomeController>().currentIndex.value, 3);
    expect(tester.takeException(), isNull);
  });
}
