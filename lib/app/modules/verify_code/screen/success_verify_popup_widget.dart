import 'package:flutter/material.dart';
import 'package:eduline/app/core/conts/app_size.dart';
import 'package:eduline/app/modules/widgets/custom_button_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../core/conts/colors.dart';
import '../../../core/conts/images.dart';

class SuccessVerifyPopup extends StatelessWidget {
  final VoidCallback onContinue;

  const SuccessVerifyPopup({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withAlpha(350),
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: getWidth(24)),
          padding: EdgeInsets.all(getWidth(24)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(getWidth(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // success image
              SvgPicture.asset(AppImages.verifySuccess, height: getWidth(150)),

              // Success title
              Text(
                "Success",
                style: TextStyle(
                  fontSize: getWidth(20),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: getWidth(12)),

              // Success description
              Text(
                "Your password is succesfully created",
                style: TextStyle(
                  fontSize: getWidth(14),
                  color: AppColors.descriptionTextColor,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: getWidth(32)),

              // Continue button
              CustomButtonWidget(buttonText: "Continue", onPressed: onContinue),
            ],
          ),
        ),
      ),
    );
  }

  // Static method to show the popup
  static void show({required VoidCallback onContinue}) {
    Get.dialog(
      SuccessVerifyPopup(onContinue: onContinue),
      barrierDismissible: false,
    );
  }
}
