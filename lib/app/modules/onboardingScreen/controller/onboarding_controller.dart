import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  var dotIndex = 0.obs;
  PageController pageController = PageController(viewportFraction: 1);

  void changePage(int index) async {
    dotIndex.value = index;
  }

  void nextPage() {
    if (dotIndex.value == 0) {
      dotIndex.value++;
      pageController.animateToPage(
        dotIndex.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }
}
