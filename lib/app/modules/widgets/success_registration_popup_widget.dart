import 'package:flutter/material.dart';
import 'package:eduline/app/core/conts/app_size.dart';

import 'package:eduline/app/modules/widgets/custom_button_widget.dart';
import 'package:get/get.dart';

import '../../core/conts/colors.dart';

class SuccessRegistrationPopup extends StatelessWidget {
  final VoidCallback onContinue;

  const SuccessRegistrationPopup({super.key, required this.onContinue});

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
              // Close button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    // onTap: () => Get.back(),
                    onTap: () => onContinue(),
                    child: Icon(
                      Icons.close,
                      color: Colors.grey,
                      size: getWidth(24),
                    ),
                  ),
                ],
              ),

              SizedBox(height: getWidth(20)),

              // Success animation circles and checkmark
              Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: getHeight(10),
                    left: getWidth(20),
                    child: Icon(
                      Icons.star,
                      color: AppColors.skyBlueColor,
                      size: getWidth(12),
                    ),
                  ),
                  Positioned(
                    top: getHeight(30),
                    right: getWidth(15),
                    child: Icon(
                      Icons.star,
                      color: AppColors.skyBlueColor,
                      size: getWidth(12),
                    ),
                  ),
                  Positioned(
                    bottom: getHeight(20),
                    left: getWidth(10),
                    child: Icon(
                      Icons.star,
                      color: AppColors.skyBlueColor,
                      size: getWidth(20),
                    ),
                  ),
                  Positioned(
                    bottom: getHeight(5),
                    right: getWidth(10),
                    child: Icon(
                      Icons.star,
                      color: AppColors.skyBlueColor,
                      size: getWidth(14),
                    ),
                    // child: Container(
                    //   width: getWidth(4),
                    //   height: getWidth(4),
                    //   decoration: BoxDecoration(
                    //     color: AppColors.skyblueColor,
                    //     shape: BoxShape.circle,
                    //   ),
                    // ),
                  ),

                  // Concentric circles
                  Container(
                    width: getWidth(190),
                    height: getWidth(190),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.skyBlueColor.withOpacity(0.1),
                    ),
                  ),
                  Container(
                    width: getWidth(140),
                    height: getWidth(140),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.whiteColor,
                    ),
                  ),

                  // Center checkmark circle
                  Container(
                    width: getWidth(60),
                    height: getWidth(60),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.skyBlueColor,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: getWidth(30),
                    ),
                  ),
                ],
              ),

              SizedBox(height: getWidth(40)),

              // Success title
              Text(
                "Successfully Registered",
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
                "Your account has been registered successfully, now let's enjoy our features!",
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
      SuccessRegistrationPopup(onContinue: onContinue),
      barrierDismissible: false,
    );
  }
}
