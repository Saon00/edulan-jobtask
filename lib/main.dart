import 'package:eduline/app/bindings/app_bindings.dart';
import 'package:eduline/app/core/conts/app_size.dart';
import 'package:eduline/app/modules/onboardingScreen/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/core/conts/colors.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   runApp(const MainApp());
// }

Future<void> main() async{
  await GetStorage.init(); // Initialize local storage
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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
