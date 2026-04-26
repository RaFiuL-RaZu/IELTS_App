import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/services/api_services.dart';
import 'package:justtsham/core/utils/app_urls.dart';
import 'package:justtsham/core/utils/validator.dart';

class LoginController extends GetxController {
  RxBool isChecked = false.obs;
  RxBool isLoading = false.obs;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Form key for validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> login() async {
    // Validate form using Validator class
    final emailError = Validator.validateEmail(emailController.text);
    if (emailError != null) {
      Get.snackbar('Validation Error', emailError,
          snackPosition: SnackPosition.TOP);
      return;
    }

    final passwordError = Validator.validatePassword(passwordController.text);
    if (passwordError != null) {
      Get.snackbar('Validation Error', passwordError,
          snackPosition: SnackPosition.TOP);
      return;
    }

    isLoading(true);

    try {
      Map<String, String> header = {};
      Map<String, dynamic> body = {
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
      };
      
      final response =
          await ApiService.postApi('${AppUrl.baseUrl}/login', header: header, body);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', response.message,
            snackPosition: SnackPosition.TOP);
        // Handle successful login - save token, navigate to home, etc.
        // Get.offAll(() => NavBarScreen());
      } else {
        Get.snackbar('Error', response.message,
            snackPosition: SnackPosition.TOP);
      }
    } catch (e, s) {
      debugPrint("Login Error: $e");
      debugPrint("Stack trace: $s");
      Get.snackbar('Error', 'Something went wrong',
          snackPosition: SnackPosition.TOP);
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}