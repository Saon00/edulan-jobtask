import 'package:eduline/app/modules/enable_location/controller/enable_location_controller.dart';
import 'package:eduline/app/modules/forget_password/controller/forget_password_controller.dart';
import 'package:eduline/app/modules/language/controller/language_controller.dart';
import 'package:eduline/app/modules/onboardingScreen/controller/onboarding_controller.dart';
import 'package:eduline/app/modules/onboardingScreen/controller/splash_screen_controller.dart';
import 'package:eduline/app/modules/reset_password/controller/reset_password_controller.dart';
import 'package:eduline/app/modules/signin/controller/signin_controller.dart';
import 'package:eduline/app/modules/signup/controller/signup_controller.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashScreenController());
    Get.lazyPut(() => OnboardingController());
    Get.lazyPut(() => SigninController());
    Get.lazyPut(() => SignupController());
    Get.lazyPut(() => ForgetPasswordController());
    Get.lazyPut(() => ResetPasswordController());
    Get.lazyPut(() => LocationController());
    Get.lazyPut(() => LanguageController());
  }
}
