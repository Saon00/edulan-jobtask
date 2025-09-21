import 'package:eduline/app/bindings/app_bindings.dart';
import 'package:eduline/app/core/conts/app_size.dart';
import 'package:eduline/app/core/conts/colors.dart';
import 'package:eduline/app/modules/onboardingScreen/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  configEasyLoading();
  await SharedPreferences.getInstance();
  runApp(const MainApp());
}

void configEasyLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = AppColors.greyColor
    ..textColor = Colors.white
    ..indicatorColor = Colors.white
    ..maskColor = Colors.green
    ..userInteractions = false
    ..dismissOnTap = false;
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
    return ScreenUtilInit(
      designSize: Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
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
      },
    );
   
  }
}
