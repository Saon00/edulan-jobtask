import 'package:eduline/app/core/conts/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isPasswordVisible = false.obs;
  var isRemember = false.obs;
  var isLoading = false.obs;

  // final AuthService _authService = AuthService();

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

    // try {
    //   final response = await _authService.login(email, password);

    //   if (response.success && response.data != null) {
    //     Get.offAll(() => EnableLocationScreen());
    //     Get.snackbar("Success", response.message);

    //     clearFields();
    //   } else {
    //     Get.snackbar("Login Failed", response.message);
    //   }
    // } catch (e) {
    //   Get.snackbar("Error", e.toString());
    // } finally {
    //   isLoading.value = false;
    // }
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
  }
}
