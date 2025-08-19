import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  var resetNewPasswordController = TextEditingController();
  var resetConfirmNewPasswordController = TextEditingController();
  var isnewPasswordVisible = false.obs;
  var isConfirmNewPasswordVisible = false.obs;
  var isRemember = false.obs;

  void togglenewPasswordVisibility() {
    isnewPasswordVisible.value = !isnewPasswordVisible.value;
  }

  void toggleConfirmNewPasswordVisibility() {
    isConfirmNewPasswordVisible.value = !isConfirmNewPasswordVisible.value;
  }

  
  void clearFields() {
    resetNewPasswordController.clear();
    resetConfirmNewPasswordController.clear();
  }
}
