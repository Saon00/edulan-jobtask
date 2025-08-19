import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  var emailController = TextEditingController();
  var fullNameController = TextEditingController();
  var passwordController = TextEditingController();
  var isPasswordVisible = false.obs;

   // Password strength observables
  var passwordStrength = 0.obs; 
  var passwordStrengthText = ''.obs;
  var passwordRequirements =
      <String, bool>{
        'minLength': false,
        'hasLetter': false,
        'hasNumber': false,
      }.obs;

      @override
  void onInit() {
    super.onInit();
    passwordController.addListener(_checkPasswordStrength);
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  void clearFields() {
    emailController.clear();
    passwordController.clear();
  }

   void _checkPasswordStrength() {
    String password = passwordController.text;

    passwordRequirements['minLength'] = password.length >= 8;
    passwordRequirements['hasLetter'] = password.contains(RegExp(r'[a-zA-Z]'));
    passwordRequirements['hasNumber'] = password.contains(RegExp(r'[0-9]'));

    int strength = 0;
    if (passwordRequirements['minLength']!) strength++;
    if (passwordRequirements['hasLetter']!) strength++;
    if (passwordRequirements['hasNumber']!) strength++;

    // Additional checks for stronger passwords
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

    passwordStrength.value = strength;

    if (password.isEmpty) {
      passwordStrengthText.value = '';
    } else if (strength <= 2) {
      passwordStrengthText.value = 'Weak';
    } else if (strength <= 3) {
      passwordStrengthText.value = 'Medium';
    } else {
      passwordStrengthText.value = 'Strong';
    }
  }

@override
  void onClose() {
    emailController.dispose();
    fullNameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
