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
    "Commercial",
    "Animation ",
    "Video Game ",
    "Narration ",
    "Character ",
    "E-Learning ",
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

    try {
      Map<String, String> header = {
        "token":SignUpController.instance.accountToken
      };
      Map<String, dynamic> body = {
        "otp": otp,
      };

      final response = await ApiService.postApi(AppUrl.verifyEmail,
        header: header,
        body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        verifyToken=response.body['data']['accessToken'];
        Get.snackbar('Success', response.message,
            snackPosition: SnackPosition.TOP);
        Get.to(() => CompleteProfile());
      } else {
        Get.snackbar('Error', response.message,
            backgroundColor: AppColor.primary,
            snackPosition: SnackPosition.TOP);
      }
    } catch (e, s) {
      debugPrint("Verify OTP Error: $e");
      debugPrint("Stack trace: $s");
      Get.snackbar('Error', 'Something went wrong',snackPosition: SnackPosition.TOP);
    }finally {
      isLoading(false);
    }
  }

  Future<void> resendOtp() async {
    if (isResending.value || resendTimer.value > 0) {
      return;
    }


    isResending(true);

    try {
      Map<String, String> header = {
        'token':SignUpController.instance.accountToken
      };
      Map<String, dynamic> body = {
        "email": SignUpController.instance.emailController.text.trim(),
      };

      final response = await ApiService.patchApi(AppUrl.resentOtp,
        header: header,
        body:body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'OTP resent successfully',
            snackPosition: SnackPosition.TOP);
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


RxBool isComplete=false.obs;
  Future<void> completeProfile() async {
     isComplete(true);
    try {
    

      debugPrint("COMPLETE PROFILE API");

      var body = {
        "data": jsonEncode({
          "about": bioController.text.trim(),
          "voiceSpecialties": selectedValues
              .map((e) => e.toString().trim())
              .toList(),
        })
      };

      final header = {
        "token": verifyToken,
        'Content-Type': 'application/json',
      };

      debugPrint("BODY: $body");
      debugPrint("IMAGE: ${selectedImage.value}");

      final response = await ApiService.multipartRequest(
        url: AppUrl.completeProfile,
        body: body,
        header: header,
        method: "POST",
        imageName: "image",
        imagePaths: selectedImage.value,
      );

      debugPrint("STATUS: ${response.statusCode}");
      debugPrint("RESPONSE: ${response.body}");
      debugPrint("bodyImage: $selectedImage");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body['data'];
        final email = data['email'] ?? '';
        final apiFullName = (data['fullName'] as String?)?.trim() ?? '';
        final fullName = apiFullName.isNotEmpty
            ? apiFullName
            : PrefsHelper.myName.isNotEmpty
                ? PrefsHelper.myName
                : SignUpController.instance.nameController.text.trim();

        final userId = data['_id'] ?? '';

        PrefsHelper.token = verifyToken;
        PrefsHelper.myEmail = email;
        PrefsHelper.myName = fullName;
        PrefsHelper.userId = userId;
        PrefsHelper.isLogIn = true;

        await PrefsHelper.setString("token", verifyToken);
        await PrefsHelper.setString("myEmail", email);
        await PrefsHelper.setString("myName", fullName);
        await PrefsHelper.setString("userId", userId);
        await PrefsHelper.setBool("isLogIn", true);

        CommonSnackBar.show(
          title: "Success",
          message: "Profile completed successfully",
          isSuccess: true,
        );
        // Subscription page hidden from flow — go straight to home after profile completion.
        // Get.to(()=>Subscription());
        Get.offAll(() => NavBarScreen());
      } else {
        debugPrint("API ERROR: ${response.message}");
        CommonSnackBar.show(
          title: "Error",
          message: response.message,
          isSuccess: false,
        );
      }
    } catch (e, s) {
      debugPrint("ERROR: $e");
      debugPrint("STACK: $s");

      CommonSnackBar.show(
        title: "Error",
        message: "Something went wrong",
        isSuccess: false,
      );
    } finally {
       isComplete(false);
    }
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