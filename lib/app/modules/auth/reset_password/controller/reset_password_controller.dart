import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/conts/colors.dart';
import '../../../../core/services/auth_services.dart';
import '../../signin/screen/signin_screen.dart';

class ResetPasswordController extends GetxController {
  // Text controllers
  var resetNewPasswordController = TextEditingController();
  var resetConfirmNewPasswordController = TextEditingController();

  // Observable password values for reactive UI
  var newPassword = ''.obs;
  var confirmPassword = ''.obs;

  // Visibility toggles
  var isnewPasswordVisible = false.obs;
  var isConfirmNewPasswordVisible = false.obs;

  // Loading and validation states
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Data from previous screens
  var email = ''.obs;
  var token = ''.obs;

  // Auth service
  final AuthService _authService = AuthService();

  @override
  void onInit() {
    super.onInit();
    // Get email and token from arguments passed from OTP verification screen
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    email.value = args['email'] ?? '';
    // token.value = args['token'] ?? '';

    // Listen to text controller changes for reactive UI
    resetNewPasswordController.addListener(_onNewPasswordChanged);
    resetConfirmNewPasswordController.addListener(_onConfirmPasswordChanged);
  }

  // Add these listener methods
  void _onNewPasswordChanged() {
    newPassword.value = resetNewPasswordController.text;
    // Clear error when user starts typing
    if (errorMessage.value.isNotEmpty) {
      clearError();
    }
  }

  void _onConfirmPasswordChanged() {
    confirmPassword.value = resetConfirmNewPasswordController.text;
    // Clear error when user starts typing
    if (errorMessage.value.isNotEmpty) {
      clearError();
    }
  }

  @override
  void onClose() {
    // Remove listeners before disposing
    resetNewPasswordController.removeListener(_onNewPasswordChanged);
    resetConfirmNewPasswordController.removeListener(_onConfirmPasswordChanged);

    // resetNewPasswordController.dispose();
    // resetConfirmNewPasswordController.dispose();
    super.onClose();
  }

  // Toggle password visibility
  void togglenewPasswordVisibility() {
    isnewPasswordVisible.value = !isnewPasswordVisible.value;
  }

  void toggleConfirmNewPasswordVisibility() {
    isConfirmNewPasswordVisible.value = !isConfirmNewPasswordVisible.value;
  }

  // Clear error message
  void clearError() {
    errorMessage.value = '';
  }

  // Clear input fields
  void clearFields() {
    resetNewPasswordController.clear();
    resetConfirmNewPasswordController.clear();
    newPassword.value = '';
    confirmPassword.value = '';
  }

  // Password validation
  bool _isValidPassword(String password) {
    // Minimum 8 characters, at least one letter and one number
    return password.length >= 8 &&
        password.contains(RegExp(r'[a-zA-Z]')) &&
        password.contains(RegExp(r'[0-9]'));
  }

  // Validate inputs
  String? _validateInputs() {
    final newPasswordText = resetNewPasswordController.text.trim();
    final confirmPasswordText = resetConfirmNewPasswordController.text.trim();

    if (newPasswordText.isEmpty) {
      return "New password can't be empty";
    }

    if (confirmPasswordText.isEmpty) {
      return "Please confirm your password";
    }

    if (!_isValidPassword(newPasswordText)) {
      return "Password must be at least 8 characters with letters and numbers";
    }

    if (newPasswordText != confirmPasswordText) {
      return "Passwords don't match";
    }

    // if (email.value.isEmpty || token.value.isEmpty) {
    //   return "Invalid reset session. Please start over.";
    // }

    return null; // No errors
  }

  // Reset password
  Future<void> resetPassword() async {
    // Clear previous errors
    clearError();

    // Validate inputs
    final validationError = _validateInputs();
    if (validationError != null) {
      errorMessage.value = validationError;
      Get.snackbar(
        "Validation Error",
        validationError,
        backgroundColor: AppColors.redColor,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.all(16),
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await _authService.resetPassword(
        // token: token.value,
        newPassword: resetNewPasswordController.text.trim(),
        confirmPassword: resetConfirmNewPasswordController.text.trim(),
        email: email.value,
      );

      if (response['success']) {
        // Password reset successful
        Get.snackbar(
          "Success",
          response['message'] ?? "Password reset successful!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.all(16),
        );

        // Clear fields
        clearFields();

        // Show success dialog and navigate to login
        _showSuccessDialog();
        Get.to(() => SignInScreen());
      } else {
        // Password reset failed
        errorMessage.value = response['message'] ?? "Password reset failed";
        Get.snackbar(
          "Reset Failed",
          response['message'] ?? "Password reset failed",
          backgroundColor: AppColors.redColor,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.all(16),
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
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Show success dialog
  void _showSuccessDialog() {
    Future.delayed(Duration(seconds: 2)).then((_) => Get.offAll(SignInScreen()));
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "Password Reset",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Your password has been reset successfully!",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "You can now login with your new password.",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.back(); // Close dialog
                // Navigate to login screen and clear all previous screens
                Get.offAll(() => SignInScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.skyBlueColor,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Go to Login",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // Go back to previous screen
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

  // Password strength indicator
  String getPasswordStrength(String password) {
    if (password.isEmpty) return '';

    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[a-z]'))) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

    switch (strength) {
      case 0:
      case 1:
        return 'Very Weak';
      case 2:
        return 'Weak';
      case 3:
        return 'Fair';
      case 4:
        return 'Good';
      case 5:
        return 'Strong';
      default:
        return '';
    }
  }

  // Password strength color
  Color getPasswordStrengthColor(String password) {
    final strength = getPasswordStrength(password);
    switch (strength) {
      case 'Very Weak':
      case 'Weak':
        return Colors.red;
      case 'Fair':
        return Colors.orange;
      case 'Good':
        return Colors.blue;
      case 'Strong':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Get password strength value for progress indicator
  double getPasswordStrengthValue(String password) {
    final strength = getPasswordStrength(password);
    switch (strength) {
      case 'Very Weak':
        return 0.2;
      case 'Weak':
        return 0.4;
      case 'Fair':
        return 0.6;
      case 'Good':
        return 0.8;
      case 'Strong':
        return 1.0;
      default:
        return 0.0;
    }
  }

  // Check if passwords match (for reactive UI)
  bool get passwordsMatch {
    if (confirmPassword.value.isEmpty) return true;
    return newPassword.value == confirmPassword.value;
  }

  // Get password match color
  Color get passwordMatchColor {
    if (confirmPassword.value.isEmpty) return Colors.grey;
    return passwordsMatch ? Colors.green : Colors.red;
  }

  // Get password match text
  String get passwordMatchText {
    if (confirmPassword.value.isEmpty) return '';
    return passwordsMatch ? 'Passwords match' : 'Passwords don\'t match';
  }

  // Check if form is valid (for button state)
  bool get isFormValid {
    return newPassword.value.isNotEmpty &&
        confirmPassword.value.isNotEmpty &&
        _isValidPassword(newPassword.value) &&
        passwordsMatch &&
        email.value.isNotEmpty;
    // && token.value.isNotEmpty;
  }
}
