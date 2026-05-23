import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:justtsham/core/utils/app_colors.dart';
import 'package:justtsham/core/widgets/common_text_field.dart';
import 'package:justtsham/core/widgets/coomon_button.dart';
import 'package:justtsham/featcher/controller/AuthController/forgot_password_controller.dart';
import 'package:justtsham/featcher/view/authentication/verify_email.dart';
import '../../../core/widgets/common_text.dart';

class ForgotPassword extends StatelessWidget {
 ForgotPassword({super.key});

  final ForgotPasswordController controller=Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        title: CommonText(
          title: "Forget Your Password?",
          fSize: 22.sp,
          fWeight: FontWeight.w700,
          color: AppColor.primary,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h,),
              Center(
                child: CommonText(
                  align: TextAlign.center,
                  title:
                  "Enter your email address to reset your password.",
                  fSize: 16.sp,
                  fWeight: FontWeight.w500,
                  color: AppColor.secondary,
                ),
              ),
              SizedBox(height: 20.h),
              CommonText(title: "Email",fSize: 16,fWeight: FontWeight.w700,color: AppColor.primary,),
              SizedBox(height: 6.h,),
              CommonTextField(title: "Enter your email",controller: controller.emailController,),
              SizedBox(height: 80,),
              CommonButton(titleText: "Get Verification Code",onTap: (){
               controller.forgotPassword();
              },),
              SizedBox(height: 50,),
            ],
          ),
        ),
      ),
    );
  }
}
