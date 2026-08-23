import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:justtsham/featcher/view/authentication/Login_screen.dart';
import 'package:justtsham/featcher/view/authentication/reset_password.dart';

import '../../../core/services/api_services.dart';
import '../../../core/utils/app_urls.dart';
import '../../../core/widgets/common_snackber.dart';
import '../../view/authentication/verify_otp.dart';

class ForgotPasswordController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isPassword = true.obs;
  RxBool isConfirmPassword = true.obs;

  var forgetToken="";

  Future<void> forgotPassword() async {
    isLoading(true);
    await Future.delayed(const Duration(milliseconds: 300));
    Get.to(() => VerifyOtp());
    startResendCountdown();
    CommonSnackBar.show(
      title: "Code Sent",
      message: "Verification code sent to ${emailController.text.trim()}",
      isSuccess: true,
    );
    isLoading(false);
  }

  var verifyToken = "";
  Future<void> otpVerify() async {
    isLoading(true);
    await Future.delayed(const Duration(milliseconds: 300));
    Get.to(() => ResetPassword());
    CommonSnackBar.show(
      title: "Success",
      message: "Code verified successfully",
      isSuccess: true,
    );
    isLoading(false);
  }

  RxInt resendTimer = 120.obs;
  Timer? _timer;

  void startResendCountdown() {
    _timer?.cancel();
    resendTimer.value = 120;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer.value == 0) {
        timer.cancel();
      } else {
        resendTimer.value--;
      }
    });
  }

  RxBool isResending = false.obs;

  Future<void> resendOtp() async {
    if (isResending.value || resendTimer.value > 0) {
      return;
    }
    isResending(true);
    await Future.delayed(const Duration(milliseconds: 300));
    startResendCountdown();
    Get.snackbar('Success', 'OTP resent successfully', snackPosition: SnackPosition.TOP);
    isResending(false);
  }

  Future<void> resetPassword() async {
    isLoading(true);
    await Future.delayed(const Duration(milliseconds: 300));
    Get.offAll(() => LoginScreen());
    CommonSnackBar.show(
      title: "Success",
      message: "Password changed successfully",
      isSuccess: true,
    );
    isLoading(false);
  }
}
