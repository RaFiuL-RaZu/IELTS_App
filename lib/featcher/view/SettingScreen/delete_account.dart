import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:justtsham/core/utils/app_colors.dart';
import 'package:justtsham/core/utils/app_icons.dart';
import 'package:justtsham/core/widgets/common_text_field.dart';
import '../../../core/widgets/common_text.dart';

class DeleteAccount extends StatelessWidget {
  const DeleteAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        title: CommonText(
          title: "Delete Account",
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
            SizedBox(height: 20.h),
            Container(
              margin: EdgeInsets.only(bottom: 16),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFFFEF2F2),
                border: Border.all(color: Color(0xFFFFE2E2)),
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
                    CommonText(
                      align: TextAlign.center,
                      title: "Are you absolutely sure?",
                      fSize: 18,
                      fWeight: FontWeight.w800,
                      color: Color(0xFFC10007),
                    ),
                    SizedBox(height: 10.h),
                    CommonText(
                      title:
                          "This action cannot be undone. This will permanently delete your account and remove your profile, demos, scripts, and all audition data from our servers.",
                      fSize: 14,
                      fWeight: FontWeight.w500,
                      color: Color(0xFFE7000B),
                    ),
                    CommonText(
                      title:
                          "If you have an active Pro or Premium subscription, it will be cancelled immediately.",
                      fSize: 14,
                      fWeight: FontWeight.w500,
                      color: Color(0xFFE7000B),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              margin: EdgeInsets.only(bottom: 16),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                border: Border.all(color: Color(0xFFFFE2E2)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      align: TextAlign.center,
                      title: "Confirm Password",
                      fSize: 16,
                      fWeight: FontWeight.w700,
                      color: Colors.black,
                    ),

                    CommonTextField(
                      title: "Enter your password to confirm",
                      sIcon: Icon(
                        Icons.visibility_off,
                        color: AppColor.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Container(
              height: 48.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFFCE0000),
              ),
              child: Center(child: CommonText(title: "Yes, Delete My Account",fSize: 18,fWeight: FontWeight.w600,color: Colors.white,)),
            ),
            SizedBox(height: 20,),
            Center(child: CommonText(title: "Cancel",fSize: 18,fWeight: FontWeight.w600,color: AppColor.primary,)),
            SizedBox(height: 50.h,),
          ],
        ),
      ),
    );
  }

  Widget ProfileBox({
    required String title,
    required String text,
    required IconData icon,
    Color? color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 76.h,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 40.h,
              width: 40.w,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Icon(icon, size: 22, color: color ?? AppColor.primary),
            ),
            SizedBox(width: 15.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  title: title,
                  fSize: 12,
                  fWeight: FontWeight.w700,
                  color: AppColor.secondary,
                ),
                CommonText(
                  title: text,
                  fSize: 16,
                  fWeight: FontWeight.w700,
                  color: color ?? Colors.black,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
