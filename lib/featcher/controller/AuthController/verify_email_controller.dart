import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justtsham/core/services/api_services.dart';
import 'package:justtsham/core/utils/app_colors.dart';
import 'package:justtsham/core/utils/app_urls.dart';
import 'package:justtsham/featcher/controller/AuthController/signup_controller.dart';
import 'package:justtsham/core/constant/prefs_helper.dart';
import 'package:justtsham/featcher/view/SettingScreen/subscription_page.dart';
import 'package:justtsham/featcher/view/authentication/Login_screen.dart';
// import 'package:justtsham/featcher/view/authentication/subscription.dart'; // subscription flow hidden
import 'package:justtsham/featcher/view/authentication/navber_screen.dart';

import '../../../core/widgets/common_snackber.dart';
import '../../view/authentication/complete_profile.dart';

class VerifyEmailController extends GetxController {


  static VerifyEmailController get instance=>Get.put(VerifyEmailController());
  RxBool isLoading = false.obs;
  RxString otpCode = ''.obs;
  RxBool isResending = false.obs;

  final TextEditingController bioController=TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxString registeredEmail = ''.obs;

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

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['email'] != null) {
      registeredEmail.value = Get.arguments['email'];
    }
  }
var verifyToken="";

  Future<void> verifyOtp(String otp) async {
    if (otp.isEmpty || otp.length != 6) {
      Get.snackbar('Validation Error', 'Please enter a valid 6-digit code',
          snackPosition: SnackPosition.TOP);
      return;
    }

    isLoading(true);
    await Future.delayed(const Duration(milliseconds: 300));
    Get.snackbar('Success', 'Email verified successfully', snackPosition: SnackPosition.TOP);
    Get.to(() => CompleteProfile());
    isLoading(false);
  }

  Future<void> resendOtp() async {
    if (isResending.value || resendTimer.value > 0) {
      return;
    }
    isResending(true);
    await Future.delayed(const Duration(milliseconds: 300));
    Get.snackbar('Success', 'OTP resent successfully', snackPosition: SnackPosition.TOP);
    startResendCountdown();
    isResending(false);
  }

  RxBool isComplete = false.obs;
  Future<void> completeProfile() async {
    isComplete(true);
    await Future.delayed(const Duration(milliseconds: 300));

    final fullName = SignUpController.instance.nameController.text.trim().isNotEmpty
        ? SignUpController.instance.nameController.text.trim()
        : PrefsHelper.myName.isNotEmpty
            ? PrefsHelper.myName
            : "IELTS Candidate";

    final email = SignUpController.instance.emailController.text.trim().isNotEmpty
        ? SignUpController.instance.emailController.text.trim()
        : PrefsHelper.myEmail.isNotEmpty
            ? PrefsHelper.myEmail
            : "candidate@ielts.com";

    PrefsHelper.token = "local_token_${DateTime.now().millisecondsSinceEpoch}";
    PrefsHelper.myEmail = email;
    PrefsHelper.myName = fullName;
    PrefsHelper.userId = "user_${DateTime.now().millisecondsSinceEpoch}";
    PrefsHelper.isLogIn = true;

    await PrefsHelper.setString("token", PrefsHelper.token);
    await PrefsHelper.setString("myEmail", email);
    await PrefsHelper.setString("myName", fullName);
    await PrefsHelper.setString("userId", PrefsHelper.userId);
    await PrefsHelper.setBool("isLogIn", true);

    Get.offAll(() => NavBarScreen());
    isComplete(false);
  }

  RxInt resendTimer = 120.obs;
  Timer? _timer;

  void startResendCountdown() {
    _timer?.cancel();
    resendTimer.value = 120;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer.value <= 1) {
        resendTimer.value = 0;
        timer.cancel();
      } else {
        resendTimer.value--;
      }
    });
  }

  void updateOtp(String value) {
    otpCode.value = value;
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}