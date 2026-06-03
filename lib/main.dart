import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/routes/routes.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'core/constant/prefs_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await action();
  runApp(const MyApp());
}

Future<void> action() async {
  try {
    WebViewPlatform.instance;
  } catch (e) {
    debugPrint("WebView init error: $e");
  }
  await PrefsHelper.getAllPrefData();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      ensureScreenSize: true,
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          locale: const Locale('en', 'US'),
          fallbackLocale: const Locale('en', 'US'),
          transitionDuration: const Duration(milliseconds: 300),
          debugShowCheckedModeBanner: false,
          initialRoute: (PrefsHelper.token ?? '').isNotEmpty
              ? AppRoutes.navBer
              : AppRoutes.splash,
          getPages: AppRoutes.routes,
          builder: (context, child) {
            return child ?? const SizedBox();
          },
        );
      },
    );
  }
}