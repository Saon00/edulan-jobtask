import 'package:eduline/app/core/conts/app_size.dart';
import '../../../core/conts/colors.dart';
import '../../../core/conts/images.dart';
import 'package:eduline/app/modules/onboardingScreen/controller/splash_screen_controller.dart';
import 'package:eduline/app/modules/onboardingScreen/screen/onboarding_screen.dart';
import 'package:eduline/app/modules/signin/screen/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashScreenController splashScreenController =
      Get.find<SplashScreenController>();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () async {
      await splashScreenController.checkFirstTime();
      if (splashScreenController.isFirstTime.value) {
        Get.to(() => OnboardingScreen());
      } else {
        Get.to(() => SignInScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: getWidth(32)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: getWidth(185)),
            // Image
            SvgPicture.asset(
              AppImages.car,
              colorFilter: ColorFilter.mode(
                AppColors.skyBlueColor,
                BlendMode.srcIn,
              ),
            ),

            SizedBox(height: getHeight(16)),

            // title
            Text(
              "Theory test in my language",
              style: TextStyle(
                fontSize: getWidth(24),
                color: AppColors.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: getHeight(16)),

            // description,
            Text(
              "I must write the real test will be in English language and this app just helps you to understand the materials in your\n language",
              style: TextStyle(
                fontSize: getWidth(14),
                color: AppColors.descriptionTextColor,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: getWidth(350)),

            SpinKitCircle(color: Color(0xff1B6EF7), size: getWidth(60)),
          ],
        ),
      ),
    );
  }
}
