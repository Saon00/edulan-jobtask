import 'package:eduline/app/core/conts/colors.dart';
import 'package:eduline/app/core/services/auth_services.dart';
import 'package:eduline/app/modules/enable_location/screen/enable_location_screen.dart';
import 'package:eduline/app/modules/staggered_screen/screen/staggered_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isPasswordVisible = false.obs;
  var isRemember = false.obs;
  var isLoading = false.obs;

  final AuthService _authService = AuthService();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe() {
    isRemember.value = !isRemember.value;
  }

  Future<void> loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error",
        "Email and password can't be empty",
        backgroundColor: AppColors.redColor,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );

      if (response['success'] == true && response['data'] != null) {
        Get.offAll(() => StaggeredScreen());
        Get.snackbar("Success", response['message'] ?? "Login successful");
        clearFields();
      } else {
        Get.snackbar("Login Failed", response['message'] ?? "Unknown error");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }


  void clearFields() {
    emailController.clear();
    passwordController.clear();
  }
}
