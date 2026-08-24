import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:justtsham/featcher/controller/NotificationController/notification_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justtsham/core/constant/prefs_helper.dart';
import 'package:justtsham/core/services/api_services.dart';
import 'package:justtsham/core/services/ielts_local_storage_service.dart';
import 'package:justtsham/core/utils/app_colors.dart';
import 'package:justtsham/core/utils/app_urls.dart';
import 'package:justtsham/core/utils/validator.dart';
import 'package:justtsham/core/widgets/common_snackber.dart';
import 'package:justtsham/featcher/controller/AuthController/login_controller.dart';
import 'package:justtsham/featcher/controller/AuthController/verify_email_controller.dart';
import 'package:justtsham/featcher/view/authentication/verify_email.dart';

import '../../model/login_profile_model.dart';
import '../../view/authentication/complete_profile.dart';
import '../../view/authentication/navber_screen.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find<SignUpController>();
  RxList<int> selectedIndexes = <int>[].obs;
  RxList<String> selectedValues = <String>[].obs;

  RxBool isChecked = false.obs;

  void toggleItem(int index, String value) {
    if (selectedIndexes.contains(index)) {
      selectedIndexes.remove(index);
      selectedValues.remove(value);
    } else {
      selectedIndexes.add(index);
      selectedValues.add(value);
    }
  }

  final ImagePicker picker = ImagePicker();

  RxString selectedImage = "".obs;

  Future pickImageFromGallery() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage.value = image.path;
    }
  }

  List<String> items = [
    "Speaking",
    "Writing",
    "Listening",
    "Reading",
    "Cue Cards",
    "Vocabulary",
  ];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  RxBool isLoading = false.obs;

  // Form key for validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var accountToken = "";

  Future<void> createAccount() async {
    // Validate form using Validator class
    final nameError = Validator.validateName(nameController.text);
    if (nameError != null) {
      Get.snackbar(
        'Validation Error',
        nameError,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    final emailError = Validator.validateEmail(emailController.text);
    if (emailError != null) {
      Get.snackbar(
        'Validation Error',
        emailError,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    final passwordError = Validator.validatePassword(passwordController.text);
    if (passwordError != null) {
      Get.snackbar(
        'Validation Error',
        passwordError,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    final confirmError = Validator.validateConfirmPassword(
      confirmPasswordController.text,
      passwordController.text,
    );
    if (confirmError != null) {
      Get.snackbar(
        'Validation Error',
        confirmError,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    final termsError = Validator.validateTerms(isChecked.value);
    if (termsError != null) {
      Get.snackbar(
        'Validation Error',
        termsError,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    isLoading(true);

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final fullName = nameController.text.trim();
      final email = emailController.text.trim().toLowerCase();
      final password = passwordController.text.trim();

      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('registered_users_db');
      List<Map<String, dynamic>> registeredUsers = [];

      if (usersJson != null && usersJson.isNotEmpty) {
        final List decoded = jsonDecode(usersJson);
        registeredUsers = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
      }

      // Check if email already registered
      final exists = registeredUsers.any((u) => (u['email'] as String).toLowerCase() == email);
      if (exists) {
        CommonSnackBar.show(
          title: "Already Registered ⚠️",
          message: "An account with $email already exists. Please log in instead!",
          isSuccess: false,
        );
        return;
      }

      // Save new user account
      registeredUsers.add({
        "name": fullName,
        "email": email,
        "password": password,
      });
      await prefs.setString('registered_users_db', jsonEncode(registeredUsers));

      PrefsHelper.token = "ielts_master_token_${DateTime.now().millisecondsSinceEpoch}";
      PrefsHelper.userId = "user_${DateTime.now().millisecondsSinceEpoch}";
      PrefsHelper.myName = fullName;
      PrefsHelper.myEmail = email;
      PrefsHelper.myImage = selectedImage.value;
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
        title: "Account Created! 🎉",
        message: "Welcome to IELTS Master, $fullName",
        isSuccess: true,
      );

      Get.offAll(() => const NavBarScreen());
    } catch (e, s) {
      debugPrint("Signup Error: $e");
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
