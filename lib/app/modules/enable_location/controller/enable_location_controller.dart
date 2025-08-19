import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationController extends GetxController {
  // Request location permission
  Future<void> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      // Permission granted - proceed to next screen
      _navigateToNextScreen();
    } else if (status.isDenied) {
      // Permission denied - show message or try again
      Get.snackbar(
        'Permission Denied',
        'Location permission was denied',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied - show settings dialog
      _showSettingsDialog();
    }
  }

  // Skip location permission
  void skipLocationPermission() {
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    // Replace with your actual navigation
    Get.snackbar(
      'Success',
      'Proceeding to main app...',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 1),
    );
    // Example: Get.offAll(() => HomeScreen());
  }

  void _showSettingsDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Permission Required'),
        content: const Text('Please enable location permission in settings.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }
}
