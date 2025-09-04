abstract class SettingsRepository {
  Future<bool> isFirstTime();
  Future<bool> setOnboardingComplete();
}
