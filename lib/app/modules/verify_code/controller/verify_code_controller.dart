import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eduline/app/core/colors.dart';

class VerifyCodeController extends GetxController {
  // Timer related observables
  var remainingSeconds = 60.obs;
  var canResend = false.obs;
  Timer? _timer;

  // Pin input controller
  final pinController = TextEditingController();

  // Verification code
  var verificationCode = ''.obs;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    pinController.dispose();
    super.onClose();
  }

  // Start the countdown timer
  void startTimer() {
    canResend.value = false;
    remainingSeconds.value = 60;

    _timer?.cancel(); // Cancel any existing timer

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  // Format seconds to MM:SS
  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // Handle resend code
  void resendCode() {
    if (canResend.value) {
      // Add your API call logic here
      debugPrint('Resending verification code...');

      // Restart the timer
      startTimer();

      // Show confirmation
      Get.snackbar(
        'Code Sent',
        'Verification code has been sent to your email',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.skyblueColor,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
      );
    }
  }

  // Handle pin completion
  void onPinCompleted(String pin) {
    verificationCode.value = pin;
    debugPrint('Verification code entered: $pin');
  }

  // Verify the code
  void verifyCode() {
    if (verificationCode.value.length == 4) {
      // Add your verification logic here
      debugPrint('Verifying code: ${verificationCode.value}');

      // For demo purposes, assuming verification is successful
      // In real app, you'd make an API call here
    } else {
      Get.snackbar(
        'Error',
        'Please enter the complete verification code',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
      );
    }
  }

  // Reset timer (useful if needed)
  void resetTimer() {
    _timer?.cancel();
    remainingSeconds.value = 60;
    canResend.value = false;
  }
}
