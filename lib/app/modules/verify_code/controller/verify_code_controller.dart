import 'dart:async';
import 'package:eduline/app/modules/reset_password/screen/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/conts/colors.dart';
import '../../../core/services/auth_services.dart';

class VerifyCodeController extends GetxController {
  // Timer related observables
  var remainingSeconds = 60.obs;
  var canResend = false.obs;
  Timer? _timer;

  // Pin input controller
  final pinController = TextEditingController();

  // Verification code and email
  var verificationCode = ''.obs;
  var email = ''.obs;
  var isLoading = false.obs;
  var isVerifying = false.obs;

  // Auth service
  final AuthService _authService = AuthService();

  @override
  void onInit() {
    super.onInit();
    // Get email from arguments passed from previous screen
    email.value = Get.arguments['email'] ?? '';
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
  Future<void> resendCode() async {
    if (canResend.value && email.value.isNotEmpty) {
      isLoading.value = true;

      try {
        // Call forgot password API again to resend OTP
        final response = await _authService.forgotPassword(email: email.value);

        if (response['success']) {
          // Restart the timer
          startTimer();

          // Show success message
          Get.snackbar(
            'Code Sent',
            response['message'] ??
                'Verification code has been sent to your email',
            snackPosition: SnackPosition.TOP,
            backgroundColor: AppColors.skyBlueColor,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
            margin: const EdgeInsets.all(16),
          );
        } else {
          // Show error message
          Get.snackbar(
            'Error',
            response['message'] ?? 'Failed to resend verification code',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
            margin: const EdgeInsets.all(16),
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'An unexpected error occurred while resending code',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  // Handle pin completion
  void onPinCompleted(String pin) {
    verificationCode.value = pin;
    debugPrint('Verification code entered: $pin');

    // Auto-verify when pin is complete
    if (pin.length == 6) {
      // Assuming 6-digit OTP
      verifyCode();
    }
  }

  // Verify the code
  Future<void> verifyCode() async {
    if (verificationCode.value.length < 4) {
      // Adjust length based on your OTP
      Get.snackbar(
        'Error',
        'Please enter the complete verification code',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    if (email.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Email is missing. Please go back and try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    isVerifying.value = true;

    try {
      // Call verify OTP API
      final response = await _authService.verifyOTP(
        email: email.value,
        otp: verificationCode.value,
      );

      if (response['success']) {
        // OTP verified successfully
        Get.snackbar(
          'Success',
          response['message'] ?? 'Verification successful!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
        );

        // Navigate to reset password screen with email and token
        Get.off(
          ResetPasswordScreen(),
          arguments: {
            'email': email.value,
            'token': response['data']?['token'] ?? verificationCode.value,
            // Some APIs return a token after OTP verification
          },
        );
      } else {
        // OTP verification failed
        Get.snackbar(
          'Verification Failed',
          response['message'] ?? 'Invalid verification code',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
        );

        // Clear the pin field for retry
        pinController.clear();
        verificationCode.value = '';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred during verification',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
      );

      // Clear the pin field for retry
      pinController.clear();
      verificationCode.value = '';
    } finally {
      isVerifying.value = false;
    }
  }

  // Manual verify button press
  void onVerifyButtonPressed() {
    if (verificationCode.value.isEmpty) {
      verificationCode.value = pinController.text;
    }
    verifyCode();
  }

  // Reset timer (useful if needed)
  void resetTimer() {
    _timer?.cancel();
    remainingSeconds.value = 60;
    canResend.value = false;
  }

  // Go back to forgot password screen
  void goBack() {
    Get.back();
  }

  // Get masked email for display
  String getMaskedEmail() {
    if (email.value.isEmpty) return '';

    final emailParts = email.value.split('@');
    if (emailParts.length != 2) return email.value;

    final username = emailParts[0];
    final domain = emailParts[1];

    if (username.length <= 2) return email.value;

    final maskedUsername =
        username[0] +
        '*' * (username.length - 2) +
        username[username.length - 1];

    return '$maskedUsername@$domain';
  }
}
