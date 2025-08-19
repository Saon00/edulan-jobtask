import 'package:eduline/app/core/app_size.dart';
import 'package:eduline/app/core/colors.dart';
import 'package:flutter/material.dart';

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
          backgroundColor: AppColors.skyblueColor,
        ),
        child: Text(
          buttonText,
          style: TextStyle(color: AppColors.whiteColor),
        ),
      ),
    );
  }
}
