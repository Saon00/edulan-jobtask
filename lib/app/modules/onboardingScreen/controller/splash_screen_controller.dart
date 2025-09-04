import 'package:eduline/app/data/repositories/settings_repository.dart';
import 'package:get/get.dart';

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
}
