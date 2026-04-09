import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:justtsham/core/utils/app_colors.dart';
import 'package:justtsham/core/widgets/common_text_field.dart';
import 'package:justtsham/core/widgets/coomon_button.dart';
import 'package:justtsham/featcher/view/authentication/Login_screen.dart';
import '../../../core/widgets/common_text.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12.h,),
            SizedBox(height: 20.h),
            CommonText(title: "Current Password",fSize: 16,fWeight: FontWeight.w700,color: AppColor.primary,),
            SizedBox(height: 6.h,),
            CommonTextField(title: "Password",sIcon: Icon(Icons.visibility_off,color: AppColor.secondary,),),
            SizedBox(height: 10.h,),
            CommonText(title: "New Password",fSize: 16,fWeight: FontWeight.w700,color: AppColor.primary,),
            SizedBox(height: 6.h,),
            CommonTextField(title: "New password",sIcon: Icon(Icons.visibility_off,color: AppColor.secondary,),),
            SizedBox(height: 10.h,),
            CommonText(title: "Confirm New Password",fSize: 16,fWeight: FontWeight.w700,color: AppColor.primary,),
            SizedBox(height: 6.h,),
            CommonTextField(title: "Confirm password",sIcon: Icon(Icons.visibility_off,color: AppColor.secondary,),),
            SizedBox(height: 10.h,),
            CommonText(title: "Your password must be at least 8 characters long and contain a mix of letters, numbers, and symbols.",fSize: 12,fWeight: FontWeight.w500,color: AppColor.secondary,),
            Spacer(),
            CommonButton(titleText: "Update Password",onTap: (){
              Get.offAll(()=>LoginScreen());
            },),
            SizedBox(height: 50,),
          ],
        ),
      ),
    );
  }
}
