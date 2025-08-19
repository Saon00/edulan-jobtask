import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SigninController extends GetxController {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isPasswordVisible = false.obs;
  var isRemember = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe() {
    isRemember.value = !isRemember.value;
  }
  
  void clearFields() {
    emailController.clear();
    passwordController.clear();
  }
}
