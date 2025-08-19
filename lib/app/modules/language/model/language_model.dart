class LanguageModel {
  final String name;
  final String flag;

  LanguageModel(this.name, this.flag);

  static List<LanguageModel> languages = [
    LanguageModel("English (US)", "🇺🇸"),
    LanguageModel("Indonesia", "🇮🇩"),
    LanguageModel("Afghanistan", "🇦🇫"),
    LanguageModel("Algeria", "🇩🇿"),
    LanguageModel("Malaysia", "🇲🇾"),
    LanguageModel("Saudi Arabia", "🇸🇦"),
    LanguageModel("Bangladesh", "🇧🇩"),
  ];
}
