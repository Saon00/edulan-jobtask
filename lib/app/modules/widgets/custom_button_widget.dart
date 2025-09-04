import 'package:eduline/app/core/conts/app_size.dart';

import 'package:flutter/material.dart';

import '../../core/conts/colors.dart';

class CustomButtonWidget extends StatelessWidget {
  const CustomButtonWidget({super.key, required this.buttonText, required this.onPressed});

  final String buttonText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getWidth(56),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.skyBlueColor,
        ),
        child: Text(
          buttonText,
          style: TextStyle(color: AppColors.whiteColor),
        ),
      ),
    );
  }
}
