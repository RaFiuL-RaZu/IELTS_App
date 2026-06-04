import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justtsham/core/constant/prefs_helper.dart';
import 'package:justtsham/core/services/api_services.dart';
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
    "Commercial",
    "Animation ",
    "Video Game ",
    "Narration ",
    "Character ",
    "E-Learning ",
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
      Map<String, String> header = {"Content-Type": "application/json"};
      Map<String, dynamic> body = {
        "email": emailController.text.trim(),
        "fullName": nameController.text.trim(),
        "password": passwordController.text.trim(),
      };
      final response = await ApiService.postApi(
        AppUrl.createAccount,
        header: header,
        body,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        accountToken = response.body['data'];
        CommonSnackBar.show(title: "Success", message: "OTP sent successfully", isSuccess: true);
        Get.to(() => VerifyEmail());
        VerifyEmailController.instance.startResendCountdown();
      } else {
        Get.snackbar(
          'Error',
          response.message,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e, s) {
      debugPrint("Error $e");
      debugPrint("Stack trace $s");
      Get.snackbar(
        'Error',
        'Something went wrong',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading(false);
    }
  }


  var accessToken="";

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Rx<GoogleSignInAccount?> googleUser = Rx<GoogleSignInAccount?>(null);

@override
  void onInit() {
    super.onInit();
    initSocialAuth();
  }
  void initSocialAuth() async {
    await _googleSignIn.initialize(
      serverClientId:
      '349261530631-b6msia8gkr3pl55gp594juvdptfqn5vg.apps.googleusercontent.com',
    );
  }

  Future<String?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.authenticate();
      final idToken = googleUser.authentication.idToken;

      debugPrint("$idToken");
      debugPrint(">>>>>>>>>>>>>>>IdToken >>>>>>>>>>>>>>>IdToken");
      accessToken=idToken!;
      debugPrint(">>>>>>>>>>>>>>>accessToken : $accessToken");
      final fullname = googleUser.displayName;
      String? first, second;
      final email = googleUser.email;
      final pic = googleUser.photoUrl;
      final splitedName = fullname?.split(" ");

      if (splitedName != null && splitedName.length > 1) {
        first = splitedName.first;
        splitedName.removeAt(0);
        second = splitedName.join(" ");
      }
    } catch (error, s) {
      debugPrint("Google Sign-In Error: $error\n$s");
      return null;
    }
    return null;
  }
  Future<void> postGoogle() async {
    try {
      final body = {
        "accessToken": accessToken,
      };

      final response = await ApiService.postApi(AppUrl.googleLogin, body);

      if (response.statusCode == 200 || response.statusCode == 201) {

        final data = response.body['data'];
        final loginModel = LoginProfileModel.fromJson(data);
        LoginController.instance.loginProfileModel = loginModel;

        final token = loginModel.accessToken;
        PrefsHelper.token = token;
        VerifyEmailController.instance.verifyToken = token;
        await initPrefsValue(userData: loginModel);

        if (LoginController.instance.isCheck.value) {
          await PrefsHelper.getAllPrefData();
        }

        final hasCompletedProfile = loginModel.user.hasCompletedProfile;

        if (hasCompletedProfile) {

          CommonSnackBar.show(
            title: "Success",
            message: "Login successfully",
            isSuccess: true,
          );

          Get.offAll(() => NavBarScreen());

        } else {

          Get.showSnackbar(
            GetSnackBar(
              title: "Message",
              message: "Account created successfully",
              snackPosition: SnackPosition.TOP,
              backgroundColor: AppColor.primary,
              margin: EdgeInsets.all(10),
              borderRadius: 8,
              duration: Duration(seconds: 2),
            ),
          );

          Get.to(() => CompleteProfile());
        }

        accessToken = '';

      } else {

        Get.showSnackbar(
          GetSnackBar(
            title: "Error",
            message: response.message,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            margin: const EdgeInsets.all(10),
            borderRadius: 8,
            duration: const Duration(seconds: 2),
          ),
        );

        accessToken = '';
      }

    } catch (e) {
      debugPrint("Error occurred: $e");
    }
  }
  Future<void> initPrefsValue({required LoginProfileModel userData}) async {
    PrefsHelper.token = userData.accessToken;
    PrefsHelper.userId = userData.user.id;
    PrefsHelper.myName = userData.user.fullName;
    PrefsHelper.myEmail = userData.user.email;
    PrefsHelper.myImage = userData.user.profileImage;
    PrefsHelper.isLogIn = true;

    if (LoginController.instance.isCheck.value) {
      await PrefsHelper.setString('token', PrefsHelper.token);
      await PrefsHelper.setString("userId", PrefsHelper.userId);
      await PrefsHelper.setString("myImage", PrefsHelper.myImage);
      await PrefsHelper.setString("myName", PrefsHelper.myName);
      await PrefsHelper.setString("myEmail", PrefsHelper.myEmail);
      await PrefsHelper.setBool("isLogIn", PrefsHelper.isLogIn);
    }
  }
}
