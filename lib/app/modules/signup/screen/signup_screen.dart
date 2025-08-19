import 'package:eduline/app/core/app_size.dart';
import 'package:eduline/app/core/colors.dart';
import 'package:eduline/app/modules/signin/screen/signin_screen.dart';
import 'package:eduline/app/modules/signup/controller/signup_controller.dart';
import 'package:eduline/app/modules/widgets/custom_button_widget.dart';
import 'package:eduline/app/modules/widgets/pass_strength_widget.dart';
import 'package:eduline/app/modules/widgets/success_registration_popup_widget.dart';
import 'package:eduline/app/modules/widgets/text_form_widget.dart'; // Add this import
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});
  void _showSuccessPopup() {
    SuccessRegistrationPopup.show(
      onContinue: () {
        // Get.back();
        // Get.back();
        Get.off(() => SignInScreen()); // Navigate to SignInScreen
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SignupController signupController = Get.put(SignupController());
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
                child: Container(
                  width: getWidth(45),
                  height: getWidth(45),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.greyColor.withAlpha(100),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColors.textColor,
                    size: getWidth(20),
                  ),
                ),
              ),
              SizedBox(height: getWidth(30)),
              // title
              Text(
                "Welcome to Eduline",
                style: TextStyle(
                  fontSize: getWidth(24),
                  color: AppColors.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: getHeight(16)),
              // description,
              Text(
                "Let's join to Eduline learning ecosystem & meet our professional mentor. It's Free!",
                style: TextStyle(
                  fontSize: getWidth(14),
                  color: AppColors.descriptionTextColor,
                ),
              ),
              SizedBox(height: getHeight(30)),
              // email address
              TextFormWidget(
                sectionTitle: "Email Address",
                textEditingController: signupController.emailController,
                hintText: "enter your email",
              ),
              SizedBox(height: getHeight(24)),
              // full name
              TextFormWidget(
                sectionTitle: "Full Name",
                textEditingController: signupController.fullNameController,
                hintText: "enter your full name",
              ),
              SizedBox(height: getHeight(24)),
              // password with strength indicator
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => TextFormWidget(
                      sectionTitle: "Password",
                      textEditingController:
                          signupController
                              .passwordController, // Use the controller from signup controller
                      hintText: "enter your password",
                      isPassword: true,
                      isPasswordVisible:
                          signupController.isPasswordVisible.value,
                      onTogglePasswordVisibility:
                          signupController.togglePasswordVisibility,
                    ),
                  ),
                  // Password strength indicator
                  Obx(
                    () => PasswordStrengthWidget(
                      strength: signupController.passwordStrength.value,
                      strengthText: signupController.passwordStrengthText.value,
                      requirements: signupController.passwordRequirements,
                      password: signupController.passwordController.text,
                    ),
                  ),
                ],
              ),

              SizedBox(height: getWidth(70)),
              // button
              CustomButtonWidget(
                buttonText: "Sign Up",
                onPressed: () {
                  _showSuccessPopup();
                  signupController.clearFields();
                },
              ),
              SizedBox(height: getWidth(16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      fontSize: getWidth(14),
                      color: AppColors.descriptionTextColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back();
                      signupController.clearFields();
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: getWidth(14),
                        color: AppColors.skyblueColor,
                      ),
                    ),
                  ),
                ],
              ),
              // SizedBox(height: getWidth(20)),
            ],
          ),
        ),
      ),
    );
  }
}
