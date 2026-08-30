import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:justtsham/core/utils/app_colors.dart';
import 'package:justtsham/core/utils/app_image.dart';
import 'package:justtsham/core/widgets/common_text.dart';
import 'package:justtsham/featcher/controller/AuthController/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final SplashController controller=Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: 852.h,
        width: 393.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImage.splashImage,height: 156.h,width: 160.w,fit: BoxFit.fill,),
              SizedBox(height: 15.h,),
              CommonText(title: "IELTS Angon",fSize: 30.sp,fWeight: FontWeight.w800,color: AppColor.primary,),
              SizedBox(height: 15.h,),
              CommonText(title: "Ace Your IELTS Preparation",fSize: 16.sp,fWeight: FontWeight.w500,color: AppColor.secondary,),
              SizedBox(height: 50.h,),
              Image.asset(AppImage.gif,color: AppColor.primary,width: 202,height: 30,fit: BoxFit.cover,),

        ]),
      ),
    );
  }
}
