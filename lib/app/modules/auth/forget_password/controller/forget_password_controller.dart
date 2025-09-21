import 'package:eduline/app/core/conts/colors.dart';
import 'package:eduline/app/core/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../verify_code/screen/verify_code_screen.dart';

class ForgetPasswordController extends GetxController {
  var forgetPasswordEmailController = TextEditingController();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  final AuthService _authService = AuthService();

  @override
  void onClose() {
    forgetPasswordEmailController.dispose();
    super.onClose();
  }

  // Clear error message
  void clearError() {
    errorMessage.value = '';
  }

  // Email validation
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> sendEmail() async {
    final email = forgetPasswordEmailController.text.trim();

    // Clear previous error
    clearError();

    // Validate email
    if (email.isEmpty) {
      errorMessage.value = "Email can't be empty";
      Get.snackbar(
        "Error",
        "Email can't be empty",
        backgroundColor: AppColors.redColor,
        colorText: Colors.white,
      );
      return;
    }

    if (!_isValidEmail(email)) {
      errorMessage.value = "Please enter a valid email address";
      Get.snackbar(
        "Error",
        "Please enter a valid email address",
        backgroundColor: AppColors.redColor,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await _authService.forgotPassword(email: email);

      if (response['success']) {
        // Success - email sent
        Get.snackbar(
          "Success",
          response['message'] ?? "Password reset email sent successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );

        // Clear the email field
        forgetPasswordEmailController.clear();

         Get.to(() => VerifyCodeScreen(), arguments: {'email': email}); 
         
      } else {
        // Failed - show error
        errorMessage.value =
            response['message'] ?? "Failed to send reset email";
        Get.snackbar(
          "Error",
          response['message'] ?? "Failed to send reset email",
          backgroundColor: AppColors.redColor,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      }
    } catch (e) {
      errorMessage.value = "An unexpected error occurred";
      Get.snackbar(
        "Error",
        "An unexpected error occurred: ${e.toString()}",
        backgroundColor: AppColors.redColor,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }
/*
  // Show success dialog with instructions
  void _showSuccessDialog(String email) {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 10),
            Text("Email Sent"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("We've sent a password reset link to:"),
            SizedBox(height: 8),
            Text(
              email,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            SizedBox(height: 16),
            Text(
              "Please check your email and follow the instructions to reset your password.",
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              "Don't forget to check your spam folder!",
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.to(() => VerifyCodeScreen()); // Go back to login screen
            },
            child: Text("OK"),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              // Clear and focus email field for resending
              forgetPasswordEmailController.text = email;
            },
            child: Text("Send Again"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }*/

  // Resend email (if user wants to send again)
  Future<void> resendEmail() async {
    await sendEmail();
  }

  // Go back to login
  void goBackToLogin() {
    Get.back();
  }
}
