import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/routes/routes.dart';

import 'core/constant/prefs_helper.dart';

void main() {
  action();
  runApp(const MyApp());
}
action()async{
  WidgetsFlutterBinding.ensureInitialized();
  await PrefsHelper.getAllPrefData();

}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      ensureScreenSize: true,
      designSize: Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context,child){
        return GetMaterialApp(
          locale: const Locale('en', 'US'),
          fallbackLocale: const Locale('en', 'US'),
          transitionDuration: Duration(milliseconds: 300),
          debugShowCheckedModeBanner: false,
          initialRoute: PrefsHelper.token.isNotEmpty
              ? AppRoutes.navBer
              : AppRoutes.splash,
          getPages: AppRoutes.routes,
          builder: (context,child){
            return child!;
          },
        );
      },
    );
  }
}


