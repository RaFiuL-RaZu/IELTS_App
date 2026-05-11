import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/utils/app_colors.dart';
import 'package:justtsham/core/widgets/coomon_button.dart';
import 'package:justtsham/featcher/controller/AuthController/forgot_password_controller.dart';
import 'package:justtsham/featcher/view/authentication/complete_profile.dart';
import 'package:pinput/pinput.dart';

import '../../../core/widgets/common_text.dart';

class VerifyOtp extends StatelessWidget {
 VerifyOtp({super.key});

  final ForgotPasswordController controller=Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        title: CommonText(
          title: "Verify Email",
          fSize: 22.sp,
          fWeight: FontWeight.w700,
          color: AppColor.primary,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(height: 12.h,),
            Center(
              child: CommonText(
                align: TextAlign.center,
                title:
                    "We sent a 6-digit code to your email. Enter it below to confirm your account.",
                fSize: 16.sp,
                fWeight: FontWeight.w500,
                color: AppColor.secondary,
              ),
            ),
            SizedBox(height: 40.h),
            Pinput(
              length: 6,
              controller: controller.otpController,
              defaultPinTheme: PinTheme(
                width: 54.w,
                height: 60.h,
                textStyle: TextStyle(
                  fontSize: 22,
                  color: Color.fromRGBO(30, 60, 87, 1),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                ),
              ),
            ),
            SizedBox(height: 22.h),
            Obx(() => RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColor.secondary,
                ),
                children: [
                  TextSpan(text: "Didn't receive the code?  "),
                  TextSpan(
                    text: controller.resendTimer.value > 0
                        ? "Resend in ${controller.resendTimer.value}s"
                        : "Resend",
                    style: TextStyle(
                      color: controller.resendTimer.value > 0
                          ? Colors.grey
                          : AppColor.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: controller.resendTimer.value > 0
                        ? null
                        : TapGestureRecognizer()
                      ?..onTap = () {
                        controller.resendOtp();
                      },
                  ),
                ],
              ),
            )),
            Spacer(),
            CommonButton(titleText: "Verify & Continue",onTap: (){
             controller.otpVerify();
            },),
            SizedBox(height: 50,),
          ],
        ),
      ),
    );
  }
}
