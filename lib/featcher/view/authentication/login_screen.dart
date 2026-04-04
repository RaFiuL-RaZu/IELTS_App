import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:justtsham/core/utils/app_colors.dart';
import 'package:justtsham/core/widgets/common_text.dart';
import 'package:justtsham/core/widgets/common_text_field.dart';
import 'package:justtsham/core/widgets/coomon_button.dart';
import 'package:justtsham/featcher/controller/AuthController/login_controller.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({super.key});

  final LoginController controller=Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        title: CommonText(
          title: "Create Account",
          fSize: 22.sp,
          fWeight: FontWeight.w700,
          color: AppColor.primary,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CommonText(
                align: TextAlign.center,
                title: "Join VO Vault and start your journey.",
                fSize: 16.sp,
                fWeight: FontWeight.w500,
                color: AppColor.secondary,
              ),
            ),
            SizedBox(height: 20.h,),
            CommonText(title: "Full  Name",fSize: 16,fWeight: FontWeight.w700,color: AppColor.primary,),
            SizedBox(height: 6.h,),
            CommonTextField(title: "Enter your full name"),
            SizedBox(height: 10.h,),
            CommonText(title: "Email",fSize: 16,fWeight: FontWeight.w700,color: AppColor.primary,),
            SizedBox(height: 6.h,),
            CommonTextField(title: "Enter your email"),
            SizedBox(height: 20.h,),
            CommonText(title: "Password",fSize: 16,fWeight: FontWeight.w700,color: AppColor.primary,),
            SizedBox(height: 6.h,),
            CommonTextField(title: "Enter your password"),
            SizedBox(height: 20.h,),
            CommonText(title: "Confirm Password",fSize: 16,fWeight: FontWeight.w700,color: AppColor.primary,),
            SizedBox(height: 6.h,),
            CommonTextField(title: "Confirm password"),
            SizedBox(height: 10.h,),
            Obx(() => Row(
              spacing: 10,
              children: [
                SizedBox(
                  height: 14.h,
                  width: 14.h,
                  child: Checkbox(
                    value: controller.isChecked.value,
                    activeColor:  AppColor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),

                    onChanged: (value) {
                      controller.isChecked.value = value!;
                    },
                  ),
                ),
                const Text("Agree with Terms and Conditions."),
              ],
            )),
            SizedBox(height: 20.h,),
            CommonButton(titleText: "Create Account"),
          ],
        ),
      ),
    );
  }
}
