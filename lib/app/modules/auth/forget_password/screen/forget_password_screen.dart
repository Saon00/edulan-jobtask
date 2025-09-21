import 'package:eduline/app/core/conts/app_size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../core/conts/colors.dart';
import 'package:eduline/app/modules/widgets/custom_button_widget.dart';
import 'package:eduline/app/modules/widgets/text_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/forget_password_controller.dart';

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
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              InkWell(
                onTap: () => Get.back(),
                splashColor: AppColors.greyColor.withAlpha(100),
                borderRadius: BorderRadius.circular(20.r),
                child: Container(
                  width: 30.h,
                  height: 30.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.greyColor.withAlpha(100),
                      width: 1.w,
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColors.textColor,
                    size: 15.h,
                  ),
                ),
              ),

              SizedBox(height: 15.h),
              // title
              Center(
                child: Text(
                  "Forgot Password",
                  style: TextStyle(
                    fontSize: 25.sp,
                    color: AppColors.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              // description,
              Center(
                child: Text(
                  "Enter your email, we will send a verification code to email",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: AppColors.descriptionTextColor,
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              // email
              TextFormWidget(
                keyboardType: TextInputType.emailAddress,
                sectionTitle: "Email Address",
                textEditingController:
                    forgetPasswordController.forgetPasswordEmailController,
                hintText: "enter your email",
              ),

              SizedBox(height: 25.h),
              // button
              Obx(() {
                return forgetPasswordController.isLoading.value
                    ? Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: AppColors.skyBlueColor,
                        size: 35.h,
                      ),
                    )
                    : CustomButtonWidget(
                      buttonText: "Continue",
                      onPressed: forgetPasswordController.sendEmail,
                    );
              }),
              // Obx( () {
              //     return CustomButtonWidget(
              //       buttonText: "Continue",
              //       onPressed: forgetPasswordController.isLoading.value ? null : forgetPasswordController.sendEmail,
              //     );
              //   }
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
