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

  void startSplash() async {
    final hasSetup = await PrefsHelper.getBool("hasSetupCandidate") ?? false;
    final hasSeenOnboard = await PrefsHelper.getBool("hasSeenOnboard") ?? false;

    Timer(const Duration(seconds: 2), () {
      if (hasSetup) {
        Get.offAllNamed(AppRoutes.navBer);
      } else if (hasSeenOnboard) {
        Get.offAllNamed(AppRoutes.candidateSetup);
      } else {
        Get.offAllNamed(AppRoutes.onboard);
      }
    });
  }
}