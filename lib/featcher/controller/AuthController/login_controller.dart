import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/services/api_services.dart';
import 'package:justtsham/core/utils/app_urls.dart';

import '../../../core/constant/prefs_helper.dart';
import '../../../core/widgets/common_snackber.dart';
import '../../model/login_profile_model.dart';
import '../../view/authentication/navber_screen.dart';
import '../NotificationController/notification_controller.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find<LoginController>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isCheck=false.obs;

  LoginProfileModel loginProfileModel = LoginProfileModel.fromJson({});

  Future<void> signIn() async {
    try {
      isLoading(true);

      Map<String, String> body = {
        "email": usernameController.text.trim(),
        "password": passwordController.text.trim(),
      };

      final response = await ApiService.postApi(AppUrl.login, body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("response${response.body}");
        final data = response.body['data'];
        loginProfileModel = LoginProfileModel.fromJson(data);
        await initPrefsValue(userData: loginProfileModel);

        debugPrint("loginToken:${PrefsHelper.token}");
        if (PrefsHelper.token.isNotEmpty) {
          await Get.find<NotificationController>().addToken();
        }
        CommonSnackBar.show(
          title: "Success",
          message: "Login successfully",
          isSuccess: true,
        );
        Get.offAll(() => NavBarScreen());
      } else {
        CommonSnackBar.show(
          title: "Error",
          message: response.message,
          isSuccess: false,
        );
      }
    } catch (e, s) {
      debugPrint("Error: $e");
      debugPrint("Stack: $s");
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