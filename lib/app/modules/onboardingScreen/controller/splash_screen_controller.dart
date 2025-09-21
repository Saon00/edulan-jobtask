import 'package:eduline/app/data/repositories/settings_repository.dart';
import 'package:eduline/app/modules/onboardingScreen/screen/onboarding_screen.dart';

import 'package:get/get.dart';

import '../../auth/signin/screen/signin_screen.dart';

class SplashScreenController extends GetxController {
  final SettingsRepository _settingsRepository;
  SplashScreenController(this._settingsRepository);

  var isFirstTime = true.obs;

  Future<void> checkFirstTime() async {
    isFirstTime.value = await _settingsRepository.isFirstTime();
  }

  Future<void> completeOnboarding() async {
    await _settingsRepository.setOnboardingComplete();
    isFirstTime.value = false;
  }

  void navigateToAppropriateScreen() {
    if (isFirstTime.value) {
      Get.off(() => OnboardingScreen());
    } else {
      Get.off(() => SignInScreen());
    }
  }

  // Future<void> checkFirstTime() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   isFirstTime.value = prefs.getBool('isFirstTime') ?? true;
  // }

  // Future<void> completeOnboarding() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('isFirstTime', false);
  //   isFirstTime.value = false;
  // }
}
