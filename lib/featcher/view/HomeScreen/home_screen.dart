import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:justtsham/core/utils/app_colors.dart';
import 'package:justtsham/core/utils/app_icons.dart';
import 'package:justtsham/core/utils/app_image.dart';
import 'package:justtsham/core/widgets/commom_image.dart';
import 'package:justtsham/core/widgets/common_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60.h),
            CommonText(
              title: "Community",
              fSize: 22,
              fWeight: FontWeight.w800,
              color: AppColor.primary,
            ),
            SizedBox(height: 12.h),
            Container(
              height: 248.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [Color(0xFF180E27), Color(0xFF56397C)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),

                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF6C4DFF).withOpacity(0.20),
                    offset: Offset(0, 20),
                    blurRadius: 25,
                    spreadRadius: -5,
                  ),
                  BoxShadow(
                    color: Color(0xFF6C4DFF).withOpacity(0.20),
                    offset: Offset(0, 8),
                    blurRadius: 10,
                    spreadRadius: -6,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 5,
                      children: [
                        Image.asset(AppIcons.trophy, height: 15.h, width: 15.h),
                        CommonText(
                          title: "Weekly Challenge",
                          fSize: 12,
                          fWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    SizedBox(height: 9.h,),
                    CommonText(title: "Superhero Movie Trailer",fSize: 22,fWeight: FontWeight.w700,color: Colors.white,),
                    SizedBox(height: 10.h,),
                    CommonText(title: "Record your best epic movie trailer voice. Think dramatic, powerful, and heroic.",fSize: 16,fWeight: FontWeight.w400,color: Colors.white,),
                    SizedBox(height: 10.h,),
                    CommonText(title: "3 days, 14:22:08 remaining",fSize: 12,fWeight: FontWeight.w400,color: Colors.white,),
                    SizedBox(height: 10.h,),
                    Container(
                      height: 48.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Color(0xFF7741C1)
                      ),child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 5,
                        children: [
                          CommonText(title: "Submit Your Take",fSize: 20.sp,fWeight: FontWeight.w500,color: Colors.white,),
                        ],
                      ),
                    ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 248.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF6C4DFF).withOpacity(0.20),
                    offset: Offset(0, 20),
                    blurRadius: 25,
                    spreadRadius: -5,
                  ),
                  BoxShadow(
                    color: Color(0xFF6C4DFF).withOpacity(0.20),
                    offset: Offset(0, 8),
                    blurRadius: 10,
                    spreadRadius: -6,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading:ClipOval(
                          child: CommonImage(imageSrc: AppImage.person,imageType: ImageType.png,height: 50.h,width: 50.h,fill: BoxFit.cover,)),
                      title: CommonText(title: "Alex Mercer",fSize: 14,fWeight: FontWeight.w700,color: AppColor.primary,),
                      subtitle:CommonText(title: "2 hours",fSize: 12,fWeight: FontWeight.w500,color: AppColor.primary,),
                    trailing: Container(
                      height: 24.h,
                      width: 93.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFFE5E2FD),
                      ),child: Center(child: CommonText(title: "Commercial",fSize: 12,fWeight: FontWeight.w500,color: AppColor.primary,)),
                    ),),
                    SizedBox(height: 10.h,),
                    CommonText(title: "Nissan - Epic Journey (Spec)",fSize: 14,fWeight: FontWeight.w600,color: AppColor.primary,),
                    SizedBox(height: 10.h,),
                    Container(
                      height: 48.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            offset: Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                        border: Border.all(
                          color: const Color(0xFFF3F4F6).withOpacity(0.5),
                          width: 1.224,
                        ),
                      ),
                      child: Row(
                        children: [

                        ],
                      )
                    ),
                    SizedBox(height: 10.h,),
                    CommonText(title: "3 days, 14:22:08 remaining",fSize: 12,fWeight: FontWeight.w400,color: Colors.white,),
                    SizedBox(height: 10.h,),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
