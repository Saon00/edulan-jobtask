import 'package:eduline/app/core/conts/app_size.dart';
import '../../../core/conts/colors.dart';

import 'package:eduline/app/modules/forget_password/controller/forget_password_controller.dart';
import 'package:eduline/app/modules/reset_password/screen/reset_password_screen.dart';
import 'package:eduline/app/modules/widgets/custom_button_widget.dart';
import 'package:eduline/app/modules/widgets/text_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ForgetPasswordController forgetPasswordController = Get.put(
      ForgetPasswordController(),
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
                  "Forgot Password",
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
                  "Enter your email, we will send a verification code to email",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: getWidth(18),
                    color: AppColors.descriptionTextColor,
                  ),
                ),
              ),
              SizedBox(height: getHeight(40)),
              // email
              TextFormWidget(
                keyboardType: TextInputType.emailAddress,
                sectionTitle: "Email Address",
                textEditingController:
                    forgetPasswordController.forgetPasswordEmailController,
                hintText: "enter your email",
              ),

              SizedBox(height: getWidth(40)),
              // button
              CustomButtonWidget(
                buttonText: "Continue",
                onPressed: () {
                  Get.to(() => ResetPasswordScreen());
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
