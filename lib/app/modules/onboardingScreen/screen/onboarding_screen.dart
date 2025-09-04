import 'package:eduline/app/core/conts/app_size.dart';
import '../../../core/conts/colors.dart';
import 'package:eduline/app/modules/onboardingScreen/controller/onboarding_controller.dart';
import 'package:eduline/app/modules/onboardingScreen/model/onboarding_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the controller that should already be registered in AppBindings
    final OnboardingController onboardingController =
        Get.find<OnboardingController>();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: getWidth(30)),
        child: Obx(() {
          return Stack(
            children: [
              PageView(
                scrollDirection: Axis.horizontal,
                onPageChanged:
                    onboardingController
                        .onPageChanged, // Use the new method name
                controller: onboardingController.pageController,
                children: List.generate(OnboardingModel.onboardingList.length, (
                  index,
                ) {
                  final item = OnboardingModel.onboardingList[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: getWidth(87)),
                      Center(
                        child: Image.asset(item.image, height: getHeight(327)),
                      ),
                      SizedBox(height: getWidth(40)),
                      // title
                      Text(
                        item.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: getWidth(24),
                          color: AppColors.textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: getHeight(16)),
                      // description
                      Text(
                        item.description,
                        style: TextStyle(
                          fontSize: getWidth(14),
                          color: AppColors.descriptionTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                }),
              ),

              // indicator
              Align(
                alignment: const Alignment(0, 0.5),
                child: SmoothPageIndicator(
                  controller: onboardingController.pageController,
                  count: OnboardingModel.onboardingList.length,
                  effect: WormEffect(
                    dotHeight: getWidth(8),
                    dotWidth: getWidth(8),
                    activeDotColor: AppColors.skyBlueColor,
                    dotColor: AppColors.skyBlueColor.withAlpha(80),
                  ),
                ),
              ),

              // Button - Simplified!
              Align(
                alignment: const Alignment(0, 0.8),
                child: SizedBox(
                  width: double.infinity,
                  height: getWidth(56),
                  child: ElevatedButton(
                    onPressed:
                        onboardingController.nextPage, // Just call nextPage!
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.skyBlueColor,
                    ),
                    child: Text(
                      // Check if it's the last page for button text
                      onboardingController.currentPageIndex.value ==
                              OnboardingModel.onboardingList.length - 1
                          ? "Get Started"
                          : "Next",
                      style: TextStyle(color: AppColors.whiteColor),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
