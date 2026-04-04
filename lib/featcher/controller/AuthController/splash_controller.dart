import 'dart:async';
import 'package:get/get.dart';
import '../../../routes/routes.dart';

class SplashController extends GetxController{

  @override
  void onInit() {
    super.onInit();
    startSplash();
  }

  void startSplash() {
    Timer(const Duration(seconds: 5), () {
      Get.offAllNamed(AppRoutes.onboard);
    });
  }
}