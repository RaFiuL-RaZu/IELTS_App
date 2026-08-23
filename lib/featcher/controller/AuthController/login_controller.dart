import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:justtsham/core/services/ielts_local_storage_service.dart';
import '../../../core/constant/prefs_helper.dart';
import '../../../core/widgets/common_snackber.dart';
import '../../model/login_profile_model.dart';
import '../../view/authentication/navber_screen.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find<LoginController>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isCheck = false.obs;

  LoginProfileModel loginProfileModel = LoginProfileModel.fromJson({});

  Future<void> signIn() async {
    final email = usernameController.text.trim().toLowerCase();
    final password = passwordController.text.trim();

    if (email.isEmpty) {
      CommonSnackBar.show(
        title: "Email Required",
        message: "Please enter your email address",
        isSuccess: false,
      );
      return;
    }

    if (password.isEmpty) {
      CommonSnackBar.show(
        title: "Password Required",
        message: "Please enter your password",
        isSuccess: false,
      );
      return;
    }

    try {
      isLoading(true);
      await Future.delayed(const Duration(milliseconds: 400));

      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('registered_users_db');
      List<Map<String, dynamic>> registeredUsers = [];

      if (usersJson != null && usersJson.isNotEmpty) {
        final List decoded = jsonDecode(usersJson);
        registeredUsers = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
      }

      // Check if user account exists
      final existingUser = registeredUsers.firstWhereOrNull(
        (u) => (u['email'] as String).toLowerCase() == email,
      );

      if (existingUser == null) {
        CommonSnackBar.show(
          title: "Account Not Found ❌",
          message: "No registered account found with $email. Please sign up first!",
          isSuccess: false,
        );
        return;
      }

      // Verify Password
      if (existingUser['password'] != password) {
        CommonSnackBar.show(
          title: "Incorrect Password ❌",
          message: "The password you entered is incorrect. Please try again.",
          isSuccess: false,
        );
        return;
      }

      // Login Successful with registered name
      final fullName = existingUser['name'] ?? "IELTS Candidate";

      PrefsHelper.token = "ielts_token_${DateTime.now().millisecondsSinceEpoch}";
      PrefsHelper.userId = "user_${DateTime.now().millisecondsSinceEpoch}";
      PrefsHelper.myName = fullName;
      PrefsHelper.myEmail = email;
      PrefsHelper.isLogIn = true;

      await PrefsHelper.setString('token', PrefsHelper.token);
      await PrefsHelper.setString("userId", PrefsHelper.userId);
      await PrefsHelper.setString("myName", PrefsHelper.myName);
      await PrefsHelper.setString("myEmail", PrefsHelper.myEmail);
      await PrefsHelper.setBool("isLogIn", true);

      if (Get.isRegistered<IeltsProgressController>()) {
        await IeltsProgressController.to.updateCandidateName(fullName);
      }

      CommonSnackBar.show(
        title: "Welcome Back! 🎯",
        message: "Logged in successfully as $fullName",
        isSuccess: true,
      );

      Get.offAll(() => const NavBarScreen());
    } catch (e) {
      debugPrint("Login Error: $e");
      CommonSnackBar.show(
        title: "Login Error",
        message: "Something went wrong. Please try again.",
        isSuccess: false,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> initPrefsValue({required LoginProfileModel userData}) async {
    PrefsHelper.token = userData.accessToken;
    PrefsHelper.userId = userData.user.id;
    PrefsHelper.myName = userData.user.fullName;
    PrefsHelper.myEmail = userData.user.email;
    PrefsHelper.myImage = userData.user.profileImage;
    PrefsHelper.isLogIn = true;

    await PrefsHelper.setString('token', PrefsHelper.token);
    await PrefsHelper.setString("userId", PrefsHelper.userId);
    await PrefsHelper.setString("myImage", PrefsHelper.myImage);
    await PrefsHelper.setString("myName", PrefsHelper.myName);
    await PrefsHelper.setString("myEmail", PrefsHelper.myEmail);
    await PrefsHelper.setBool("isLogIn", PrefsHelper.isLogIn);
  }
}