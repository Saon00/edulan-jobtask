import 'package:eduline/app/core/conts/app_size.dart';
import '../../../core/conts/colors.dart';

import 'package:eduline/app/modules/reset_password/controller/reset_password_controller.dart';
import 'package:eduline/app/modules/verify_code/screen/verify_code_screen.dart';
import 'package:eduline/app/modules/widgets/custom_button_widget.dart';
import 'package:eduline/app/modules/widgets/text_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ResetPasswordController resetPasswordController = Get.put(
      ResetPasswordController(),
    );
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: getWidth(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: getWidth(50)),
              InkWell(
                onTap: () {
                  Get.back();
                },
                splashColor: AppColors.greyColor.withAlpha(100),
                borderRadius: BorderRadius.circular(getWidth(25)),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.textColor,
                  size: getWidth(20),
                ),
              ),

              SizedBox(height: getWidth(16)),
              // title
              Center(
                child: Text(
                  "Reset Password",
                  style: TextStyle(
                    fontSize: getWidth(32),
                    color: AppColors.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: getHeight(16)),
              // description,
              Center(
                child: Text(
                  "Your password must be at least 8 characters long and include a combination of letters, numbers",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: getWidth(15),
                    color: AppColors.descriptionTextColor,
                  ),
                ),
              ),
              SizedBox(height: getHeight(40)),

              // new password
              Obx(
                () => TextFormWidget(
                  sectionTitle: "New Password",
                  textEditingController:
                      resetPasswordController.resetNewPasswordController,
                  hintText: "enter your new password",
                  isPassword: true,
                  isPasswordVisible:
                      resetPasswordController.isnewPasswordVisible.value,
                  onTogglePasswordVisibility:
                      resetPasswordController.togglenewPasswordVisibility,
                ),
              ),
              SizedBox(height: getWidth(24)),

              // confirm new password
              Obx(
                () => TextFormWidget(
                  sectionTitle: "Confirm New Password",
                  textEditingController:
                      resetPasswordController.resetConfirmNewPasswordController,
                  hintText: "confirm your new password",
                  isPassword: true,
                  isPasswordVisible:
                      resetPasswordController.isConfirmNewPasswordVisible.value,
                  onTogglePasswordVisibility:
                      resetPasswordController
                          .toggleConfirmNewPasswordVisibility,
                ),
              ),

              SizedBox(height: getWidth(40)),
              // button
              CustomButtonWidget(
                buttonText: "Continue",
                onPressed: () {
                  Get.to(() => VerifyCodeScreen());
                },
              ),
              SizedBox(height: getWidth(16)),
            ],
          ),
        ),
      ),
    );
  }
}
