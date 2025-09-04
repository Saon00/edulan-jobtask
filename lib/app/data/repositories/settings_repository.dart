abstract class SettingsRepository {
  Future<bool> isFirstTime();
  Future<void> setOnboardingComplete();
  // Future<bool> setOnboardingComplete();
}
