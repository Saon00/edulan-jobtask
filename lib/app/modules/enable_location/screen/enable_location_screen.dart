import 'package:eduline/app/core/conts/app_size.dart';
import 'package:eduline/app/modules/enable_location/controller/enable_location_controller.dart';
import 'package:eduline/app/modules/language/screen/language_screen.dart';
import 'package:eduline/app/modules/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/conts/colors.dart';
import '../../../core/conts/images.dart';

class EnableLocationScreen extends StatelessWidget {
  const EnableLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LocationController locationController = Get.put(LocationController());
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: getWidth(24)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Image.asset(AppImages.map)),
              SizedBox(height: getHeight(20)),

              // Title
              Center(
                child: Text(
                  "Enable Location",
                  style: TextStyle(
                    fontSize: getWidth(24),
                    color: AppColors.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: getHeight(16)),

              // description
              Center(
                child: Text(
                  "Kindly allow us to access your location to provide you with suggestions for nearby salons",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: getWidth(14),
                    color: AppColors.descriptionTextColor,
                  ),
                ),
              ),

              SizedBox(height: getHeight(28)),
              CustomButtonWidget(
                buttonText: "Enable",
                onPressed: () {
                  locationController.requestLocationPermission();
                  Get.to(() => LanguageSelectionScreen());
                },
              ),
              SizedBox(height: getHeight(28)),
              // skip button
              Center(
                child: InkWell(
                  onTap: () => locationController.skipLocationPermission(),
                  borderRadius: BorderRadius.circular(getWidth(10)),
                  child: Text(
                    "Skip, Not Now",
                    style: TextStyle(
                      fontSize: getWidth(20),
                      color: AppColors.textColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
