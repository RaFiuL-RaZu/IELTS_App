
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/constant/prefs_helper.dart';

import '../../../core/services/api_services.dart';
import '../../../core/utils/app_urls.dart';
import '../../../core/widgets/common_snackber.dart';

class PasswordController extends GetxController{

  TextEditingController oldPasswordController=TextEditingController();
  TextEditingController newPasswordController=TextEditingController();
  TextEditingController confirmPasswordController=TextEditingController();

  RxBool isLoading=false.obs;

  Future<void> resetPassword() async {
    isLoading(true);

    try {
      Map<String, String> header = {
        "token": PrefsHelper.token,
      };

      Map<String, dynamic> body = {
        "newPassword": newPasswordController.text.trim(),
        "oldPassword": oldPasswordController.text.trim()
      };

      final response = await ApiService.patchApi(
        AppUrl.changePassword,
        header: header,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
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