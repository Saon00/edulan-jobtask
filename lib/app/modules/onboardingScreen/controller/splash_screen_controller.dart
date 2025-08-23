import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenController extends GetxController {
  var isFirstTime = true.obs;

  Future<void> checkFirstTime() async {
    final storage = GetStorage();
    isFirstTime.value = storage.read('isFirstTime') ?? true;
  }
  Future<void> completeOnboarding() async {
    final storage = GetStorage();
    await storage.write('isFirstTime', false);
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
