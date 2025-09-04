import 'package:eduline/app/data/repositories/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepositoryImplement implements SettingsRepository {
  static const _keyIsFirstTime = 'isFirstTime';

  @override
  Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsFirstTime) ?? true;
    // throw UnimplementedError();
  }

  @override
  Future<bool> setOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_keyIsFirstTime, false);
    // throw UnimplementedError();
  }
}
