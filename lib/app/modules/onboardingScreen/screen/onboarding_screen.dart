import 'package:eduline/app/core/app_size.dart';
import 'package:eduline/app/core/colors.dart';
import 'package:eduline/app/modules/onboardingScreen/controller/onboarding_controller.dart';
import 'package:eduline/app/modules/onboardingScreen/controller/splash_screen_controller.dart';
import 'package:eduline/app/modules/onboardingScreen/model/onboarding_model.dart';
import 'package:eduline/app/modules/signin/screen/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final onboardingController = Get.put(OnboardingController());
    SplashScreenController splashScreenController =
        Get.find<SplashScreenController>();
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: getWidth(30)),
        child: Obx(() {
          return Stack(
            children: [
              PageView(
                scrollDirection: Axis.horizontal,
                onPageChanged:
                    (value) => onboardingController.changePage(value),
                controller: onboardingController.pageController,
                children: List.generate(OnboardingModel.onboardingList.length, (
                  index,
                ) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: getWidth(87)),
                      Center(
                        child: Image.asset(
                          OnboardingModel.onboardingList[index].image,
                          height: getHeight(327),
                        ),
                      ),
                      SizedBox(height: getWidth(40)),
                      // title
                      Text(
                        OnboardingModel.onboardingList[index].title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: getWidth(24),
                          color: AppColors.textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: getHeight(16)),
                      // description,
                      Text(
                        OnboardingModel.onboardingList[index].description,
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
                alignment: Alignment(0, 0.5),
                child: SmoothPageIndicator(
                  controller: onboardingController.pageController,
                  count: OnboardingModel.onboardingList.length,
                  effect: WormEffect(
                    dotHeight: getWidth(8),
                    dotWidth: getWidth(8),
                    activeDotColor: AppColors.skyblueColor,
                    dotColor: AppColors.skyblueColor.withAlpha(80),
                  ),
                ),
              ),

              // Button
              Align(
                alignment: Alignment(0, 0.8),
                child: SizedBox(
                  width: double.infinity,
                  height: getWidth(56),
                  child: ElevatedButton(
                    onPressed: () async {
                      // onboardingController.dotIndex.value == 0
                      //     ? onboardingController.nextPage()
                      //     : Get.off(() => SignInScreen()) ;
                      if (onboardingController.dotIndex.value == 0) {
                        onboardingController.nextPage();
                      } else {
                        splashScreenController.completeOnboarding();
                        Get.off(() => SignInScreen());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.skyblueColor,
                    ),
                    child: Text(
                      onboardingController.dotIndex.value == 0
                          ? "Next"
                          : "Get Started",
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
