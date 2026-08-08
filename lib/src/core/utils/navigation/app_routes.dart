import 'package:get/get.dart';
import 'package:restaurant_app/src/presentation/controller/add_product_controller.dart';
import 'package:restaurant_app/src/presentation/controller/auth/login_controller.dart';
import 'package:restaurant_app/src/presentation/controller/auth/otp_controller.dart';
import 'package:restaurant_app/src/presentation/controller/auth/sign_in_controller.dart';
import 'package:restaurant_app/src/presentation/controller/auth/verification_success_controller.dart';
import 'package:restaurant_app/src/presentation/controller/edit_product_controller.dart';
import 'package:restaurant_app/src/presentation/controller/home_controller.dart';
import 'package:restaurant_app/src/presentation/controller/onboarding_controller.dart';
import 'package:restaurant_app/src/presentation/controller/product_controller.dart';
import 'package:restaurant_app/src/presentation/controller/splash_controller.dart';
import 'package:restaurant_app/src/presentation/view/auth/login/login_screen.dart';
import 'package:restaurant_app/src/presentation/view/auth/login/otp_verification_screen.dart';
import 'package:restaurant_app/src/presentation/view/auth/login/verification_success_screen.dart';
import 'package:restaurant_app/src/presentation/view/auth/sign_in/sign_in_screen.dart';
import 'package:restaurant_app/src/presentation/view/home/home_screen.dart';
import 'package:restaurant_app/src/presentation/view/onboarding screen/onboarding_screen.dart';
import 'package:restaurant_app/src/presentation/view/products/add_product_screen.dart';
import 'package:restaurant_app/src/presentation/view/products/edit_product_screen.dart';
import 'package:restaurant_app/src/presentation/view/products/product_screen.dart';
import 'package:restaurant_app/src/presentation/view/splash screen/splash_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String otpVerification = '/otp-verification';
  static const String verificationSuccess = '/verification-success';
  static const String signIn = '/sign-in';
  static const String home = '/home';
  static const String product = '/product';
  static const String addproduct = '/addproduct';
  static const String editproduct = '/editproduct';
  static const String orders = '/orders';


  static List<GetPage<dynamic>> get pages => [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
      binding: BindingsBuilder.put(SplashController.new),
    ),
    GetPage(
      name: onboarding,
      page: () => const OnboardingScreen(),
      binding: BindingsBuilder.put(OnboardingController.new),
    ),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      binding: BindingsBuilder.put(LoginController.new),
    ),
    GetPage(
      name: otpVerification,
      page: () => const OtpVerificationScreen(),
      binding: BindingsBuilder.put(OtpController.new),
    ),
    GetPage(
      name: verificationSuccess,
      page: () => const VerificationSuccessScreen(),
      binding: BindingsBuilder.put(VerificationSuccessController.new),
    ),
    GetPage(
      name: signIn,
      page: () => const SignInScreen(),
      binding: BindingsBuilder.put(SignInController.new),
    ),
    GetPage(
      name: home,
      page: () => HomeScreen(),
      binding: BindingsBuilder.put(HomeController.new),
    ),
    GetPage(
      name: product,
      page: () => const ProductListScreen(),
      binding: BindingsBuilder.put(ProductController.new),
    ),
    GetPage(
      name: addproduct,
      page: () => const AddProductScreen(),
      binding: BindingsBuilder.put(AddProductController.new),
    ),
    GetPage(
      name: editproduct,
      page: () => const EditProductScreen(),
      binding: BindingsBuilder.put(EditProductController.new),
    ),
    GetPage(
      name: editproduct,
      page: () => const EditProductScreen(),
      binding: BindingsBuilder.put(EditProductController.new),
    ),
  ];
}
