
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:justtsham/core/constant/prefs_helper.dart';
import '../../../core/widgets/common_snackber.dart';

class PasswordController extends GetxController {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  RxBool isOldPassword = true.obs;
  RxBool isNewPassword = true.obs;
  RxBool isConfirmPassword = true.obs;

  RxBool isLoading = false.obs;

  Future<void> resetPassword() async {
    final oldPass = oldPasswordController.text.trim();
    final newPass = newPasswordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    if (oldPass.isEmpty) {
      CommonSnackBar.show(
        title: "Required",
        message: "Please enter your current password",
        isSuccess: false,
      );
      return;
    }

    if (newPass.isEmpty) {
      CommonSnackBar.show(
        title: "Required",
        message: "Please enter a new password",
        isSuccess: false,
      );
      return;
    }

    if (newPass != confirmPass) {
      CommonSnackBar.show(
        title: "Mismatch",
        message: "New password and confirmation do not match",
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

      final currentEmail = PrefsHelper.myEmail.trim().toLowerCase();

      // Find current user in database
      int userIndex = registeredUsers.indexWhere(
        (u) => (u['email'] as String).toLowerCase() == currentEmail,
      );

      if (userIndex != -1) {
        // Verify current password
        if (registeredUsers[userIndex]['password'] != oldPass) {
          CommonSnackBar.show(
            title: "Incorrect Password ❌",
            message: "Current password does not match your registered password",
            isSuccess: false,
          );
          return;
        }

        // Update password
        registeredUsers[userIndex]['password'] = newPass;
        await prefs.setString('registered_users_db', jsonEncode(registeredUsers));
      } else {
        // If not found, add/save as active user entry
        registeredUsers.add({
          'name': PrefsHelper.myName.isNotEmpty ? PrefsHelper.myName : 'IELTS Candidate',
          'email': currentEmail.isNotEmpty ? currentEmail : 'candidate@ielts.com',
          'password': newPass,
          'phone': PrefsHelper.phone,
          'createdAt': DateTime.now().toIso8601String(),
        });
        await prefs.setString('registered_users_db', jsonEncode(registeredUsers));
      }

      oldPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();

      Get.back();
      CommonSnackBar.show(
        title: "Success! 🔒",
        message: "Password updated successfully! Use your new password to log in next time.",
        isSuccess: true,
      );
    } catch (e) {
      debugPrint("Change password error: $e");
      CommonSnackBar.show(
        title: "Error",
        message: "Failed to update password. Please try again.",
        isSuccess: false,
      );
    } finally {
      isLoading(false);
    }
  }
}