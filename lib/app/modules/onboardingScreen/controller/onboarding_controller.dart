// In your OnboardingController
import 'dart:developer';

import 'package:eduline/app/data/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/signin/screen/signin_screen.dart';

class OnboardingController extends GetxController {
  final SettingsRepository _settingsRepository;
  OnboardingController(this._settingsRepository);

  final RxInt currentPageIndex = 0.obs;
  PageController pageController = PageController();

  int get totalPages => 2; // Change this to your actual number of pages

  // RENAME THIS METHOD to onPageChanged
  void onPageChanged(int index) {
    currentPageIndex.value = index;
  }

  void nextPage() {
    if (currentPageIndex.value < totalPages - 1) {
      // Fixed logic
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      // Call the method to complete onboarding and navigate
      completeOnboardingAndNavigate();
      log('complete get started cicked');
    }
  }

  // ADD THIS METHOD to handle completion
  Future<void> completeOnboardingAndNavigate() async {
    await _settingsRepository.setOnboardingComplete();
    Get.off(() => SignInScreen());
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
