import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:justtsham/core/utils/app_colors.dart';
import 'package:justtsham/core/utils/app_icons.dart';
import 'package:justtsham/featcher/controller/ProfileController/help_controller.dart';
import '../../../core/widgets/common_text.dart';

class HelpScreen extends StatefulWidget {
 HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final HelpController controller=Get.put(HelpController());

  @override
  void initState() {
    controller.getHelp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        title: CommonText(
          title: "Help Center",
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
                      Center(
                        child: Container(
                          height: 63.h,
                          width: 63.w,
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
                            child: Center(
                              child: Image.asset(
                                AppIcons.faq,
                                height: 31.h,
                                width: 31.w,
                                color: AppColor.primary,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Center(
                        child: CommonText(
                          align: TextAlign.center,
                          title:
                              "We're here to help! Reach out to us through any of the channels below.",
                          fSize: 14,
                          fWeight: FontWeight.w500,
                          color: AppColor.secondary,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Obx(()=>ProfileBox(
                        title: 'Email',
                        text: controller.helpModel.value.email.toString(),
                        icon: Icons.lock,
                      )),
                     Obx(()=> ProfileBox(
                       title: 'Phone',
                       text: controller.helpModel.value.phone.toString(),
                       icon: Icons.delete,
                     ),),
                     Obx(()=> ProfileBox(
                       title: 'Location',
                       text: controller.helpModel.value.location.toString(),
                       icon: Icons.delete,
                     ),)
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
          color: Color(0xFFF9FAFB),
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
