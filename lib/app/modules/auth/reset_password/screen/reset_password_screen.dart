import 'package:eduline/app/core/conts/app_size.dart';
import '../../../../core/conts/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/reset_password_controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  final ResetPasswordController controller = Get.put(ResetPasswordController());

  ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Added for better UX on small screens
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Better alignment
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
            // title
            Center(
              child: Text(
                "Reset Password",
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
                "Your password must be at least 8 characters long and include a combination of letters, numbers",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: getWidth(15),
                  color: AppColors.descriptionTextColor,
                ),
              ),
            ),
            SizedBox(height: getHeight(40)),

            // New Password Field
            Text(
              'New Password',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Obx(() => TextFormField(
              controller: controller.resetNewPasswordController,
              obscureText: !controller.isnewPasswordVisible.value,
              decoration: InputDecoration(
                hintText: 'Enter new password',
                prefixIcon: Icon(Icons.lock_outlined, color: AppColors.skyBlueColor),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isnewPasswordVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: AppColors.skyBlueColor,
                  ),
                  onPressed: controller.togglenewPasswordVisibility,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.skyBlueColor, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              onChanged: (value) {
                // Trigger rebuild for password strength
                controller.resetNewPasswordController.notifyListeners();
              },
            )),

            // Password Strength Indicator (Fixed)
            Obx(() {
              final password = controller.newPassword.value; // Use observable instead
              final strength = controller.getPasswordStrength(password);
              final color = controller.getPasswordStrengthColor(password);

              return password.isNotEmpty
                  ? Container(
                margin: EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Text('Strength: ', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    Text(
                      strength,
                      style: TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    // Visual strength indicator
                    Expanded(
                      child: LinearProgressIndicator(
                        value: _getStrengthValue(strength),
                        backgroundColor: AppColors.redColor,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        minHeight: 4,
                      ),
                    ),
                  ],
                ),
              )
                  : SizedBox(height: 24); // Maintain spacing when empty
            }),

            SizedBox(height: 20),



            // Confirm Password Field
            Text(
              'Confirm Password',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Obx(() => TextFormField(
              controller: controller.resetConfirmNewPasswordController,
              obscureText: !controller.isConfirmNewPasswordVisible.value,
              decoration: InputDecoration(
                hintText: 'Confirm new password',
                prefixIcon: Icon(Icons.lock_outline, color: AppColors.skyBlueColor),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isConfirmNewPasswordVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: AppColors.skyBlueColor,
                  ),
                  onPressed: controller.toggleConfirmNewPasswordVisibility,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.skyBlueColor, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              onChanged: (value) {
                // Clear error when user starts typing
                if (controller.errorMessage.value.isNotEmpty) {
                  controller.clearError();
                }
              },
            )),


            // Password match indicator (Also fixed)
            Obx(() {
              final newPasswordText = controller.newPassword.value;
              final confirmPasswordText = controller.confirmPassword.value;

              if (confirmPasswordText.isNotEmpty) {
                final isMatch = newPasswordText == confirmPasswordText;
                return Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Icon(
                        isMatch ? Icons.check_circle : Icons.error,
                        size: 16,
                        color: isMatch ? Colors.green : Colors.red,
                      ),
                      SizedBox(width: 4),
                      Text(
                        isMatch ? 'Passwords match' : 'Passwords don\'t match',
                        style: TextStyle(
                          fontSize: 12,
                          color: isMatch ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return SizedBox(height: 24); // Maintain spacing
            }),

            SizedBox(height: 32),

            // Reset Password Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.skyBlueColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: controller.isLoading.value
                    ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : Text(
                  'Reset Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )),
            ),

            SizedBox(height: 20),

            // Error Message
            Obx(() => controller.errorMessage.value.isNotEmpty
                ? Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      controller.errorMessage.value,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, size: 20),
                    onPressed: controller.clearError,
                    color: Colors.red.shade700,
                  ),
                ],
              ),
            )
                : SizedBox.shrink()),

            SizedBox(height: 20),

            // Password requirements
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Password Requirements',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  _buildRequirement('At least 8 characters'),
                  _buildRequirement('Contains letters and numbers'),
                  _buildRequirement('Upper and lowercase letters (recommended)'),
                  _buildRequirement('Special characters (recommended)'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method for password strength value
  double _getStrengthValue(String strength) {
    switch (strength) {
      case 'Very Weak':
        return 0.2;
      case 'Weak':
        return 0.4;
      case 'Fair':
        return 0.6;
      case 'Good':
        return 0.8;
      case 'Strong':
        return 1.0;
      default:
        return 0.0;
    }
  }

  // Helper method for password requirements
  Widget _buildRequirement(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, size: 16, color: Colors.blue.shade600),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(fontSize: 12, color: Colors.blue.shade700),
          ),
        ],
      ),
    );
  }
}