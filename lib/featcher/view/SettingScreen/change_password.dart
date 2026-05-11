import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:justtsham/core/utils/app_colors.dart';
import 'package:justtsham/core/widgets/common_text_field.dart';
import 'package:justtsham/core/widgets/coomon_button.dart';
import 'package:justtsham/featcher/controller/ProfileController/change_password.dart';
import 'package:justtsham/featcher/view/authentication/Login_screen.dart';
import '../../../core/widgets/common_text.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});

  final PasswordController controller = Get.put(PasswordController());

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        title: CommonText(
          title: "Change Password",
          fSize: 22.sp,
          fWeight: FontWeight.w700,
          color: AppColor.primary,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),
              SizedBox(height: 20.h),
              CommonText(
                title: "Current Password",
                fSize: 16,
                fWeight: FontWeight.w700,
                color: AppColor.primary,
              ),
              SizedBox(height: 6.h),
              Obx(()=> CommonTextField(
                title: "Password",
                controller: controller.oldPasswordController,
                obscureText: controller.isOldPassword.value,
                sIcon: GestureDetector(
                  onTap: () {
                    controller.isOldPassword.value=!controller.isOldPassword.value;
                  },
                  child: Icon(
                    controller.isOldPassword.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    size: 18,
                    color: Colors.grey.shade600,
                  ),

                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Current password is required";
                  }
                  if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),),
              SizedBox(height: 10.h),
              CommonText(
                title: "New Password",
                fSize: 16,
                fWeight: FontWeight.w700,
                color: AppColor.primary,
              ),
              SizedBox(height: 6.h),
             Obx(()=> CommonTextField(
               controller: controller.newPasswordController,
               title: "New password",
               obscureText: controller.isNewPassword.value,
               sIcon: GestureDetector(
                 onTap: () {
                   controller.isNewPassword.value=!controller.isNewPassword.value;
                 },
                 child: Icon(
                   controller.isNewPassword.value
                       ? Icons.visibility_off
                       : Icons.visibility,
                   size: 18,
                   color: Colors.grey.shade600,
                 ),

               ),

               validator: (value) {
                 if (value == null || value.trim().isEmpty) {
                   return "New password is required";
                 }

                 if (value.length < 8) {
                   return "Password must be at least 8 characters";
                 }

                 if (!RegExp(r'[A-Z]').hasMatch(value)) {
                   return "Include at least 1 uppercase letter";
                 }

                 if (!RegExp(r'[0-9]').hasMatch(value)) {
                   return "Include at least 1 number";
                 }
                 if (!RegExp(r'[!@#\$&*~%^]').hasMatch(value)) {
                   return "Include at least 1 special character";
                 }

                 return null;
               },
             ),),
              SizedBox(height: 10.h),
              CommonText(
                title: "Confirm New Password",
                fSize: 16,
                fWeight: FontWeight.w700,
                color: AppColor.primary,
              ),
              SizedBox(height: 6.h),
             Obx(()=>CommonTextField(
               controller: controller.confirmPasswordController,
               title: "Confirm password",
               obscureText: controller.isConfirmPassword.value,
               sIcon: GestureDetector(
                 onTap: () {
                   controller.isConfirmPassword.value=!controller.isConfirmPassword.value;
                 },
                 child: Icon(
                   controller.isConfirmPassword.value
                       ? Icons.visibility_off
                       : Icons.visibility,
                   size: 18,
                   color: Colors.grey.shade600,
                 ),

               ),

               validator: (value) {
                 if (value == null || value.trim().isEmpty) {
                   return "Confirm password is required";
                 }

                 if (value != controller.newPasswordController.text) {
                   return "Passwords do not match";
                 }

                 return null;
               },
             ),),
              SizedBox(height: 10.h),
              CommonText(
                title:
                    "Your password must be at least 8 characters long and contain a mix of letters, numbers, and symbols.",
                fSize: 12,
                fWeight: FontWeight.w500,
                color: AppColor.secondary,
              ),
              Spacer(),
              CommonButton(
                titleText: "Update Password",
                onTap: () {
                  if(formKey.currentState!.validate()){
                    controller.resetPassword();
                  }
                },
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
