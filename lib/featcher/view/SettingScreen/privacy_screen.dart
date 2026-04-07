import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:justtsham/core/utils/app_colors.dart';
import 'package:justtsham/featcher/view/SettingScreen/change_password.dart';
import '../../../core/widgets/common_text.dart';
import 'delete_account.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        title: CommonText(
          title: "Privacy & Security",
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
              SizedBox(height: 20.h),
              Container(
                margin: EdgeInsets.only(bottom: 16),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Get.to(()=>ChangePassword());
                        },
                        child: ProfileBox(
                          title: 'Change Password',
                          icon: Icons.lock,
                        ),
                      ),
                      Divider(color: Colors.grey.shade200,),
                      GestureDetector(
                        onTap: (){
                          Get.to(()=>DeleteAccount());
                        },
                        child: ProfileBox(
                          title: 'Delete Account',
                          icon: Icons.delete,
                          color: Colors.red,
                        ),
                      ),

                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Row ProfileBox({
    required String title,

   required IconData icon,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 40.h,
              width: 40.w,
              decoration: BoxDecoration(
                color: AppColor.background,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(icon, size: 24,color: color,),
              ),
            ),
            SizedBox(width: 15.w),
            CommonText(
              title: title,
              fSize: 14,
              fWeight: FontWeight.w700,
              color: color ?? Colors.black,
            ),
          ],
        ),
        Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColor.secondary,
        ),
      ],
    );
  }
}
