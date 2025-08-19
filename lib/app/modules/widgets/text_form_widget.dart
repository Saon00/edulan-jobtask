import 'package:eduline/app/core/app_size.dart';
import 'package:eduline/app/core/colors.dart';
import 'package:flutter/material.dart';

class TextFormWidget extends StatelessWidget {
  const TextFormWidget({
    super.key,
    required this.sectionTitle,
    required this.textEditingController,
    this.hintText = "",
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.onTogglePasswordVisibility,
    this.keyboardType = TextInputType.text,
  });

  final String sectionTitle;
  final TextEditingController textEditingController;
  final String hintText;
  final bool isPassword;
  final bool isPasswordVisible;
  final VoidCallback? onTogglePasswordVisibility;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // title
        Text(
          sectionTitle,
          style: TextStyle(
            fontSize: getWidth(16),
            color: AppColors.textColor,
            // fontWeight: FontWeight.bold,
          ),
        ),

        // textfield for email
        SizedBox(height: getHeight(16)),
        TextField(
          obscureText: isPassword && !isPasswordVisible,
          controller: textEditingController,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            // Only show suffix if it's a password field
            suffixIcon:
                isPassword
                    ? IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_off_outlined
                            : Icons.remove_red_eye_outlined,
                      ),
                      onPressed: onTogglePasswordVisibility,
                      color: AppColors.skyblueColor.withAlpha(150),
                    )
                    : null,
            hintText: hintText,
            hintStyle: TextStyle(
              color: AppColors.descriptionTextColor,
              fontSize: getWidth(14),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(getWidth(30)),
              borderSide: BorderSide(color: Color(0xffCBD5E1), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(getWidth(30)),
              borderSide: BorderSide(color: Color(0xffCBD5E1), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(getWidth(30)),
              borderSide: BorderSide(color: Color(0xffCBD5E1), width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
