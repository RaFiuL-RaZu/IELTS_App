import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:justtsham/core/utils/app_colors.dart';
import 'package:justtsham/core/utils/app_icons.dart';
import 'package:justtsham/featcher/controller/ProfileController/subscription_contoller.dart';
import '../../../core/widgets/common_text.dart';
import '../../../core/widgets/coomon_button.dart';

class SubscriptionPage extends StatelessWidget {
  SubscriptionPage({super.key});

  final SubscriptionController controller = Get.put(SubscriptionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        title: CommonText(
          title: "Subscription",
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Free Plan",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        CommonText(
                          title: "Perfect for getting started.",
                          fSize: 14,
                          fWeight: FontWeight.w500,
                          color: AppColor.secondary,
                        ),

                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            CommonText(
                              title: "\$0",
                              fSize: 30,
                              fWeight: FontWeight.w800,
                            ),
                            CommonText(
                              title: "/month",
                              fSize: 16,
                              fWeight: FontWeight.w500,
                              color: Color(0xFF717182),
                            ),
                          ],
                        ),
                        SizedBox(height: 30.h),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.planList.length,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                spacing: 5,
                                children: [
                                  Container(
                                    height: 20.h,
                                    width: 20.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColor.background,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Image.asset(
                                        AppIcons.flag,
                                        height: 14,
                                        width: 14,
                                        fit: BoxFit.fill,
                                        color: Color(0xFF717182),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: CommonText(
                                      title: controller.planList[i],
                                      fSize: 14,
                                      fWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 24.h),
                        CommonButton(
                          titleText: "Current Plan",
                          // buttonWidth: 209.w,
                          buttonHeight: 50.h,
                          backgroundColor: Colors.white,
                          borderColor: AppColor.secondary,
                          titleColor: AppColor.secondary,
                          useGradient: false,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColor.primary,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Pro Plan",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            CommonText(
                              title:
                                  "For active voice actors who want more control and tools.",
                              fSize: 14,
                              fWeight: FontWeight.w500,
                              color: Color(0XCCFFFFFF),
                            ),

                            SizedBox(height: 12.h),
                            Row(
                              children: [
                                CommonText(
                                  title: "\$9",
                                  fSize: 30,
                                  fWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                                CommonText(
                                  title: "/month",
                                  fSize: 16,
                                  fWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            SizedBox(height: 30.h),
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.proList.length,
                              itemBuilder: (context, i) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    spacing: 5,
                                    children: [
                                      Container(
                                        height: 20.h,
                                        width: 20.w,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0x33FFFFFF),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Icon(
                                            Icons.check,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: CommonText(
                                          title: controller.proList[i],
                                          fSize: 14,
                                          color: Colors.white,
                                          fWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 24.h),
                            CommonButton(
                              titleText: "Upgrade to Pro",
                              // buttonWidth: 209.w,
                              buttonHeight: 50.h,
                              backgroundColor: Colors.white,
                              borderColor: AppColor.secondary,
                              titleColor: AppColor.primary,
                              useGradient: false,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      height: 26.h,
                      width: 118.w,
                      decoration: BoxDecoration(
                        color: Color(0xFFFDC700),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),child:Center(child: CommonText(title: "Most Popular",fSize: 10,fWeight: FontWeight.w800,color: Colors.black,)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFF000000),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Premium Plan",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        CommonText(
                          title: "For professionals looking to grow faster.",
                          fSize: 14,
                          fWeight: FontWeight.w500,
                          color: Color(0XCCFFFFFF),
                        ),

                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            CommonText(
                              title: "\$19",
                              fSize: 30,
                              fWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                            CommonText(
                              title: "/month",
                              fSize: 16,
                              fWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        SizedBox(height: 30.h),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.premiumList.length,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                spacing: 5,
                                children: [
                                  Container(
                                    height: 20.h,
                                    width: 20.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0x33FFFFFF),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Image.asset(
                                        AppIcons.crown,
                                        height: 14,
                                        width: 14,
                                        fit: BoxFit.fill,
                                        color: Colors.orangeAccent,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: CommonText(
                                      title: controller.premiumList[i],
                                      fSize: 14,
                                      color: Colors.white,
                                      fWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 24.h),
                        CommonButton(
                          titleText: "Upgrade to Premium",
                          buttonHeight: 50.h,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFDC700), Color(0xFFFE9A00)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderColor: AppColor.secondary,
                          titleColor: Color(0xFF733E0A),
                          useGradient: true,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50.h),
            ],
          ),
        ),
      ),
    );
  }
}
