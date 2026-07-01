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
import 'package:justtsham/featcher/controller/AuthController/login_controller.dart';
import 'package:justtsham/featcher/controller/AuthController/signup_controller.dart';
import 'package:justtsham/featcher/view/authentication/create_account.dart';
import 'package:justtsham/featcher/view/authentication/forgot_password.dart';
import 'package:justtsham/routes/routes.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController controller = Get.put(LoginController());
  final SignUpController signUpController = Get.put(SignUpController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        title: CommonText(
          title: "Welcome Back",
          fSize: 22.sp,
          fWeight: FontWeight.w700,
          color: AppColor.primary,
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
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
                      title: "Sign in to continue your VO journey.",
                      fSize: 16.sp,
                      fWeight: FontWeight.w500,
                      color: AppColor.secondary,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  CommonText(
                    title: "Email",
                    fSize: 16,
                    fWeight: FontWeight.w700,
                    color: AppColor.primary,
                  ),
                  SizedBox(height: 6.h),
                  CommonTextField(
                    title: "Enter email",
                    controller: controller.usernameController,
                    validator: (value) => Validator.validateEmail(value),
                  ),
                  SizedBox(height: 10.h),
                  CommonText(
                    title: "Password",
                    fSize: 16,
                    fWeight: FontWeight.w700,
                    color: AppColor.primary,
                  ),
                  SizedBox(height: 6.h),
                  CommonTextField(
                    title: "Enter password",
                    controller: controller.passwordController,
                    obscureText: true,
                    validator: (value) => Validator.validatePassword(value),
                  ),
                  SizedBox(height: 10.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => ForgotPassword());
                      },
                      child: Text(
                        "Forgot Password",
                        style: TextStyle(
                          color: AppColor.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Obx(
                    () => CommonButton(
                      titleText: "Sign In",
                      isLoading: controller.isLoading.value,
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          await controller.signIn();
                        }
                      },
                    )),
                SizedBox(height: 22.h),
                Row(
                  children: [
                    Expanded(
                        child: Divider(
                            thickness: 1, color: AppColor.secondary)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: CommonText(
                        title: "or",
                        color: AppColor.secondary,
                        fSize: 14,
                        fWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(
                        child: Divider(
                            thickness: 1, color: AppColor.secondary)),
                  ],
                ),
                SizedBox(height: 22.h),
                Obx(() {
                  if (signUpController.isGoogle.value) {
                    return Center(child: CircularProgressIndicator(color: AppColor.primary));
                  }
                  return GestureDetector(
                    onTap: () async {
                      await signUpController.signInWithGoogle();
                      if (signUpController.accessToken.isNotEmpty) {
                        await signUpController.postGoogle();
                      }
                    },
                    child: Container(
                      height: 48.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 5,
                          children: [
                            Image.asset(
                              AppIcons.google,
                              height: 20,
                              width: 20,
                              fit: BoxFit.fill,
                            ),
                            CommonText(
                              title: "Sign in with Google",
                              fSize: 18.sp,
                              fWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                SizedBox(height: 10.h),
                Obx(() {
                  if (signUpController.isApple.value) {
                    return Center(child: CircularProgressIndicator(color: AppColor.primary));
                  }
                  return GestureDetector(
                    onTap: () async {
                      await signUpController.signInWithApple();
                      if (signUpController.appleToken.isNotEmpty) {
                        await signUpController.postApple();
                      }
                    },
                    child: Container(
                      height: 48.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 5,
                          children: [
                            Image.asset(
                              AppIcons.apple,
                              height: 20,
                              width: 20,
                              fit: BoxFit.fill,
                            ),
                            CommonText(
                              title: "Sign in with Apple",
                              fSize: 18.sp,
                              fWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                SizedBox(height: 50),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColor.secondary,
                      ),
                      children: [
                        TextSpan(text: "Don't have an account? "),
                        TextSpan(
                          text: "Sign Up",
                          style: TextStyle(
                            color: AppColor.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(() => CreateAccount());
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}
