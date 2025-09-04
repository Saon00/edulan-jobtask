import 'package:eduline/app/data/repositories/settings_repository.dart';
import 'package:get/get.dart';
<<<<<<< HEAD
=======
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
>>>>>>> eb82957025e4174332b9226eca9373375a3852e9

class SplashScreenController extends GetxController {
  final SettingsRepository _settingsRepository;
  SplashScreenController(this._settingsRepository);

  var isFirstTime = true.obs;

  Future<void> checkFirstTime() async {
<<<<<<< HEAD
    isFirstTime.value = await _settingsRepository.isFirstTime();
=======
    final storage = GetStorage();
    isFirstTime.value = storage.read('isFirstTime') ?? true;
>>>>>>> eb82957025e4174332b9226eca9373375a3852e9
  }
  Future<void> completeOnboarding() async {
<<<<<<< HEAD
    await _settingsRepository.setOnboardingComplete();
=======
    final storage = GetStorage();
    await storage.write('isFirstTime', false);
>>>>>>> eb82957025e4174332b9226eca9373375a3852e9
    isFirstTime.value = false;
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
