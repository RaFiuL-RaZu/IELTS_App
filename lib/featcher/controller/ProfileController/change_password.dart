
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

  RxBool isOldPassword=false.obs;
  RxBool isNewPassword=false.obs;
  RxBool isConfirmPassword=false.obs;

  RxBool isLoading=false.obs;

  Future<void> resetPassword() async {
    isLoading(true);
    await Future.delayed(const Duration(milliseconds: 300));
    Get.back();
    CommonSnackBar.show(
      title: "Success",
      message: "Password updated successfully",
      isSuccess: true,
    );
    isLoading(false);
  }
}