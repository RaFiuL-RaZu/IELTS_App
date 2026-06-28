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

    try {
      Map<String, String> header = {};

      Map<String, dynamic> body = {"email": emailController.text.trim()};

      final response = await ApiService.postApi(AppUrl.forgotPassword, body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        forgetToken=response.body['data']['forgetToken'];
        Get.to(()=>VerifyOtp());
        startResendCountdown();
        CommonSnackBar.show(
          title: "Success",
          message: "Otp sent successfully",
          isSuccess: true,
        );
      }
    } catch (e, s) {
      debugPrint("Error $e");
      debugPrint("Error $s");
    } finally {
      isLoading(false);
    }
  }


var verifyToken="";
  Future<void> otpVerify() async {
    isLoading(true);

    try {

      debugPrint("token : $forgetToken");
      Map<String, String> header = {
        'token':forgetToken
      };

      Map<String, dynamic> body = {"otp": otpController.text.trim()};

      final response = await ApiService.patchApi(AppUrl.verifyOtp,header: header, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        verifyToken=response.body['data'];
        Get.to(()=>ResetPassword());
        CommonSnackBar.show(
          title: "Success",
          message: "Otp verify successfully",
          isSuccess: true,
        );
      }
    } catch (e, s) {
      debugPrint("Error $e");
      debugPrint("Error $s");
    } finally {
      isLoading(false);
    }
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

  RxBool isResending=false.obs;

  Future<void> resendOtp() async {
    if (isResending.value || resendTimer.value > 0) {
      return;
    }


    isResending(true);

    try {
      Map<String, String> header = {
        'token':forgetToken
      };
      Map<String, dynamic> body = {
        "email": emailController.text.trim(),
      };

      final response = await ApiService.patchApi(
        '${AppUrl.baseUrl}/otp/resend-email-otp',
        header: header,
        body:body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'OTP resent successfully',
            snackPosition: SnackPosition.TOP);
        // Start countdown timer
        startResendCountdown();
      } else {
        Get.snackbar('Error', response.message,
            snackPosition: SnackPosition.TOP);
      }
    } catch (e, s) {
      debugPrint("Resend OTP Error: $e");
      debugPrint("Stack trace: $s");
      Get.snackbar('Error', 'Something went wrong',
          snackPosition: SnackPosition.TOP);
    } finally {
      isResending(false);
    }
  }

  Future<void> resetPassword() async {
    isLoading(true);

    try {

      debugPrint("token : $forgetToken");
      Map<String, String> header = {
        'token':verifyToken
      };

      Map<String, dynamic> body = {
        "newPassword": passwordController.text.trim(),
        "confirmPassword": confirmPassController.text.trim()
      };

      final response = await ApiService.patchApi(AppUrl.resetPassword,header: header, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.offAll(()=>LoginScreen());
        CommonSnackBar.show(
          title: "Success",
          message: "Password change successfully",
          isSuccess: true,
        );
      }
    } catch (e, s) {
      debugPrint("Error $e");
      debugPrint("Error $s");
    } finally {
      isLoading(false);
    }
  }
}
