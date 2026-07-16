import 'dart:async';
import 'package:get/get.dart';
import '../../../core/constant/prefs_helper.dart';
import '../../../routes/routes.dart';

class  SplashController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    startSplash();
  }

  void startSplash() {
    Timer(const Duration(seconds: 3), () {
      if (PrefsHelper.isLogIn && PrefsHelper.token.isNotEmpty) {
        Get.offAllNamed(AppRoutes.navBer);
      } else if (PrefsHelper.hasSeenOnboard){
        Get.offAllNamed(AppRoutes.login);
      } else {
        Get.offAllNamed(AppRoutes.onboard);
      }
    });
  }
}