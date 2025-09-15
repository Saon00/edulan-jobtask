import 'package:eduline/app/bindings/app_bindings.dart';
import 'package:eduline/app/core/conts/app_size.dart';
import 'package:eduline/app/core/conts/colors.dart';
import 'package:eduline/app/modules/onboardingScreen/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  runApp(const MainApp());
}

// void main() {
//   runApp(const MainApp());
// }

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // riverpod
  // @override
  // Widget build(BuildContext context) {
  //   AppSizes().init(context);
  //   return MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen());
  // }

  //  getx way
  @override
  Widget build(BuildContext context) {
    AppSizes().init(context);
    return GetMaterialApp(
      //   defaultTransition: Transition.fadeIn,
      //   transitionDuration: Duration(seconds: 2),
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.whiteColor,
        fontFamily: 'Poppins',
      ),
      initialBinding: AppBindings(),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
