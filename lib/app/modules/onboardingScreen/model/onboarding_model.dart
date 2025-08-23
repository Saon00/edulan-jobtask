import '../../../core/conts/images.dart';

class OnboardingModel {
  final String title;
  final String description;
  final String image;

  OnboardingModel({
    required this.title,
    required this.description,
    required this.image,
  });

  static List<OnboardingModel> onboardingList = [
    OnboardingModel(
      title: "Best online courses in the world",
      description:
          "Now you can learn anywhere, anytime, even if there is no internet access!",
      image: AppImages.onboarding1,
    ),

    OnboardingModel(
      title: "Explore your new skill today",
      description:
          "Our platform is designed to help you explore new skills. Let's learn & grow with Eduline!",
      image: AppImages.onboarding2,
    ),
  ];
}
