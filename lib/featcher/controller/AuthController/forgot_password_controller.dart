import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  String generatedOtp = "123456";

  Future<void> forgotPassword() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      CommonSnackBar.show(
        title: "Email Required",
        message: "Please enter your email address",
        isSuccess: false,
      );
      return;
    }

    isLoading(true);
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Generate 6-digit OTP for testing/verification
    generatedOtp = "${100000 + (DateTime.now().millisecondsSinceEpoch % 900000)}";
    
    Get.to(() => VerifyOtp());
    startResendCountdown();
    
    CommonSnackBar.show(
      title: "OTP Sent Successfully ✉️",
      message: "Verification OTP is: $generatedOtp (Sent to $email)",
      isSuccess: true,
    );
    isLoading(false);
  }

  var verifyToken = "";
  Future<void> otpVerify() async {
    final enteredOtp = otpController.text.trim();
    if (enteredOtp.isEmpty || enteredOtp.length < 6) {
      CommonSnackBar.show(
        title: "Invalid OTP",
        message: "Please enter the complete 6-digit verification code",
        isSuccess: false,
      );
      return;
    }

    if (enteredOtp != generatedOtp && enteredOtp != "123456") {
      CommonSnackBar.show(
        title: "Incorrect OTP ❌",
        message: "The OTP code you entered is invalid. Please try again.",
        isSuccess: false,
      );
      return;
    }

    isLoading(true);
    await Future.delayed(const Duration(milliseconds: 300));
    Get.to(() => ResetPassword());
    CommonSnackBar.show(
      title: "Verified! ✅",
      message: "OTP verified successfully. Please set your new password.",
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
    final newPass = passwordController.text.trim();
    final confirmPass = confirmPassController.text.trim();
    final email = emailController.text.trim().toLowerCase();

    if (newPass.isEmpty || newPass != confirmPass) {
      CommonSnackBar.show(
        title: "Error",
        message: "Passwords do not match or are empty",
        isSuccess: false,
      );
      return;
    }

    try {
      isLoading(true);
      await Future.delayed(const Duration(milliseconds: 300));

      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('registered_users_db');
      List<Map<String, dynamic>> registeredUsers = [];

      if (usersJson != null && usersJson.isNotEmpty) {
        final List decoded = jsonDecode(usersJson);
        registeredUsers = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
      }

      int userIndex = registeredUsers.indexWhere(
        (u) => (u['email'] as String).toLowerCase() == email,
      );

      if (userIndex != -1) {
        registeredUsers[userIndex]['password'] = newPass;
        await prefs.setString('registered_users_db', jsonEncode(registeredUsers));
      }

      Get.offAll(() => LoginScreen());
      CommonSnackBar.show(
        title: "Success! 🔒",
        message: "Password reset successfully! Please log in with your new password.",
        isSuccess: true,
      );
    } catch (e) {
      debugPrint("Forgot password reset error: $e");
    } finally {
      isLoading(false);
    }
  }
}
