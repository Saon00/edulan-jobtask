import 'package:eduline/app/core/conts/app_size.dart';
import 'package:eduline/app/modules/auth/verify_code/screen/success_verify_popup_widget.dart';
import '../../../../core/conts/colors.dart';
import 'package:eduline/app/modules/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:get/get.dart';

import '../../forget_password/controller/forget_password_controller.dart';
import '../controller/verify_code_controller.dart';

class VerifyCodeScreen extends StatelessWidget {
  const VerifyCodeScreen({super.key});

  void _showSuccessPopup() {
    SuccessVerifyPopup.show(
      onContinue: () {
        Get.back();
        // Get.off(() => SignInScreen()); // Navigate to SignInScreen
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Initialize controllers
    final ForgetPasswordController forgetPasswordController =
        Get.find<ForgetPasswordController>();
    final VerifyCodeController verifyCodeController = Get.put(
      VerifyCodeController(),
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

              // Back button
              InkWell(
                onTap: () => Get.back(),
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

              SizedBox(height: getWidth(16)),

              // Title
              Center(
                child: Text(
                  "Verify Code",
                  style: TextStyle(
                    fontSize: getWidth(32),
                    color: AppColors.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: getHeight(16)),

              // Description with email
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Please enter the code we just sent to email ',
                        style: TextStyle(
                          fontSize: getWidth(15),
                          color: AppColors.descriptionTextColor,
                        ),
                      ),
                      TextSpan(
                        text:
                            verifyCodeController.getMaskedEmail(),
                        style: TextStyle(
                          fontSize: getWidth(15),
                          color: AppColors.textColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: getWidth(30)),

              // PIN Input
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getWidth(20)),
                child: Center(
                  child: Pinput(
                    length: 6,
                    showCursor: true,
                    controller: verifyCodeController.pinController,
                    onCompleted: verifyCodeController.onPinCompleted,
                    obscureText: true,
                    defaultPinTheme: PinTheme(
                      width: getWidth(56),
                      height: getWidth(56),
                      textStyle: TextStyle(
                        fontSize: getWidth(20),
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.greyColor.withAlpha(100),
                        ),
                        borderRadius: BorderRadius.circular(getWidth(20)),
                      ),
                    ),
                    // focusedPinTheme: PinTheme(
                    //   width: getWidth(56),
                    //   height: getWidth(56),
                    //   textStyle: TextStyle(
                    //     fontSize: getWidth(20),
                    //     color: AppColors.textColor,
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    //   decoration: BoxDecoration(
                    //     border: Border.all(
                    //       color: AppColors.skyblueColor,
                    //       width: 2,
                    //     ),
                    //     borderRadius: BorderRadius.circular(getWidth(20)),
                    //   ),
                    // ),
                  ),
                ),
              ),

              SizedBox(height: getWidth(40)),

              // Resend code section
              Center(
                child: Obx(() {
                  return GestureDetector(
                    onTap: verifyCodeController.resendCode,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Resend code in ',
                            style: TextStyle(
                              fontSize: getWidth(14),
                              color: AppColors.descriptionTextColor,
                            ),
                          ),
                          TextSpan(
                            text:
                                verifyCodeController.canResend.value
                                    ? 'Now'
                                    : verifyCodeController.formatTime(
                                      verifyCodeController
                                          .remainingSeconds
                                          .value,
                                    ),
                            style: TextStyle(
                              fontSize: getWidth(14),
                              color:
                                  verifyCodeController.canResend.value
                                      ? AppColors.skyBlueColor
                                      : AppColors.descriptionTextColor,
                              fontWeight:
                                  verifyCodeController.canResend.value
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                              decoration:
                                  verifyCodeController.canResend.value
                                      ? TextDecoration.underline
                                      : TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),

              SizedBox(height: getWidth(40)),

              // Verify button
              CustomButtonWidget(
                buttonText: "Verify",
                onPressed: () {
                  verifyCodeController.verifyCode();
                  _showSuccessPopup();
                },
              ),

              SizedBox(height: getWidth(20)), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }
}
