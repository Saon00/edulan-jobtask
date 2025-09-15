import 'package:eduline/app/core/conts/app_size.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../core/conts/colors.dart';
import '../../../core/conts/images.dart';
import 'package:eduline/app/modules/forget_password/screen/forget_password_screen.dart';
import 'package:eduline/app/modules/signin/controller/signin_controller.dart';
import 'package:eduline/app/modules/signup/screen/signup_screen.dart';
import 'package:eduline/app/modules/widgets/custom_button_widget.dart';
import 'package:eduline/app/modules/widgets/text_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SignInController signinController = Get.put(SignInController());
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: getWidth(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: getWidth(87)),
              Center(
                child: SvgPicture.asset(AppImages.bulb, height: getWidth(80)),
              ),
              SizedBox(height: getWidth(16)),
              // title
              Center(
                child: Text(
                  "Welcome Back!",
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
                  "Please login first to start your Theory Test.",
                  style: TextStyle(
                    fontSize: getWidth(14),
                    color: AppColors.descriptionTextColor,
                  ),
                ),
              ),
              SizedBox(height: getHeight(40)),
              // email
              TextFormWidget(
                sectionTitle: "Email Address",
                textEditingController: signinController.emailController,
                hintText: "enter your email",
              ),
              SizedBox(height: getHeight(24)),
              // password
              Obx(
                () => TextFormWidget(
                  sectionTitle: "Password",
                  textEditingController: signinController.passwordController,
                  hintText: "enter your password",
                  isPassword: true,
                  isPasswordVisible: signinController.isPasswordVisible.value,
                  onTogglePasswordVisibility:
                      signinController.togglePasswordVisibility,
                ),
              ),
              // remember me and forgot-password
              SizedBox(height: getWidth(16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Obx(
                        () => Checkbox(
                          activeColor: AppColors.skyBlueColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(getWidth(6)),
                          ),
                          value: signinController.isRemember.value,
                          onChanged: (value) {
                            signinController.toggleRememberMe();
                          },
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      Text(
                        "Remember me",
                        style: TextStyle(
                          fontSize: getWidth(14),
                          color: AppColors.descriptionTextColor,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(() => ForgetPasswordScreen());
                    },
                    child: Text(
                      "Forgot Password",
                      style: TextStyle(
                        fontSize: getWidth(14),
                        color: AppColors.descriptionTextColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: getWidth(24)),
              // button
              Obx(() {
                return signinController.isLoading.value
                    ? Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: AppColors.skyBlueColor,
                        size: getWidth(50),
                      ),
                    )
                    : CustomButtonWidget(
                      buttonText: "Sign In",
                      onPressed: () {
                        signinController.loginUser();
                      },
                    );
              }),

              SizedBox(height: getWidth(16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "New to Theory Test?",
                    style: TextStyle(
                      fontSize: getWidth(14),
                      color: AppColors.descriptionTextColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(() => SignupScreen());
                      signinController.clearFields();
                    },
                    child: Text(
                      " Create Account",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: getWidth(14),
                        color: AppColors.skyBlueColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
