import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/utils/app_colors.dart';
import 'package:justtsham/core/utils/app_icons.dart';
import 'package:justtsham/core/utils/validator.dart';
import 'package:justtsham/core/widgets/common_text.dart';
import 'package:justtsham/core/widgets/common_text_field.dart';
import 'package:justtsham/core/widgets/coomon_button.dart';
import 'package:justtsham/featcher/view/SettingScreen/terms_conditions.dart';
import 'package:justtsham/featcher/view/authentication/Login_screen.dart';

import '../../controller/AuthController/signup_controller.dart';

class CreateAccount extends StatelessWidget {
  CreateAccount({super.key});

  final SignUpController controller = Get.put(SignUpController());
  final formKey = GlobalKey<FormState>();

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),
                Center(
                  child: CommonText(
                    align: TextAlign.center,
                    title: "Join IELTS Angon and start your preparation.",
                    fSize: 16.sp,
                    fWeight: FontWeight.w500,
                    color: AppColor.secondary,
                  ),
                ),
                SizedBox(height: 20.h),
                CommonText(
                  title: "Full Name",
                  fSize: 16,
                  fWeight: FontWeight.w700,
                  color: AppColor.primary,
                ),
                SizedBox(height: 6.h),
                CommonTextField(
                  title: "Enter your full name",
                  controller: controller.nameController,
                  validator: (value) => Validator.validateName(value),
                ),
                SizedBox(height: 10.h),
                CommonText(
                  title: "Email",
                  fSize: 16,
                  fWeight: FontWeight.w700,
                  color: AppColor.primary,
                ),
                SizedBox(height: 6.h),
                CommonTextField(
                  title: "Enter your email",
                  controller: controller.emailController,
                  validator: (value) => Validator.validateEmail(value),
                ),
                SizedBox(height: 20.h),
                CommonText(
                  title: "Password",
                  fSize: 16,
                  fWeight: FontWeight.w700,
                  color: AppColor.primary,
                ),
                SizedBox(height: 6.h),
                CommonTextField(
                  title: "Enter your password",
                  controller: controller.passwordController,
                  obscureText: true,
                  validator: (value) => Validator.validatePassword(value),
                ),
                SizedBox(height: 20.h),
                CommonText(
                  title: "Confirm Password",
                  fSize: 16,
                  fWeight: FontWeight.w700,
                  color: AppColor.primary,
                ),
                SizedBox(height: 6.h),
                CommonTextField(
                  title: "Confirm password",
                  controller: controller.confirmPasswordController,
                  obscureText: true,
                  validator: (value) => Validator.validateConfirmPassword(
                    value,
                    controller.passwordController.text,
                  ),
                ),
                SizedBox(height: 10.h),
                Obx(() => Row(
                      spacing: 10,
                      children: [
                        SizedBox(
                          height: 14.h,
                          width: 14.h,
                          child: Checkbox(
                            value: controller.isChecked.value,
                            activeColor: AppColor.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            onChanged: (value) {
                              controller.isChecked.value = value!;
                            },
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            children: [
                              const TextSpan(text: "Agree with "),
                              TextSpan(
                                text: "Terms and Conditions",
                                style: TextStyle(
                                  color: AppColor.primary,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColor.primary,
                                  decorationThickness: 2,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.to(() => const TermsOfUseScreen());
                                  },
                              ),
                              const TextSpan(text: "."),
                            ],
                          ),
                        )
                      ],
                    )),
                SizedBox(height: 20.h),
                Obx(() => CommonButton(
                      titleText: "Create Account",
                      isLoading: controller.isLoading.value,
                      onTap: () async {
                        if (!controller.isChecked.value) {
                          Get.snackbar(
                            'Hey',
                            'You must agree to the Terms and Conditions',
                            snackPosition: SnackPosition.TOP,
                          );
                          return;
                        }
                        // Validate form fields
                        if (formKey.currentState!.validate()) {
                          await controller.createAccount();
                        }
                      },
                    )),
                SizedBox(height: 30.h),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColor.secondary,
                      ),
                      children: [
                        TextSpan(text: "Already have an account? "),
                        TextSpan(
                          text: " Sign In",
                          style: TextStyle(
                            color: AppColor.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(() => LoginScreen());
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}