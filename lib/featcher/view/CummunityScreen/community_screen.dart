import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/featcher/controller/CommunityController/community_controller.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_icons.dart';
import '../../../core/utils/app_image.dart';
import '../../../core/widgets/commom_image.dart';
import '../../../core/widgets/common_text.dart';
import 'commercial_screen.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CommunityController());
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SingleChildScrollView(
        child: Padding(
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
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 5,
                        children: [
                          Image.asset(
                            AppIcons.trophy,
                            height: 15.h,
                            width: 15.h,
                          ),
                          CommonText(
                            title: "Weekly Challenge",
                            fSize: 12,
                            fWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      SizedBox(height: 9.h),
                      CommonText(
                        title: "Superhero Movie Trailer",
                        fSize: 22,
                        fWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      SizedBox(height: 10.h),
                      CommonText(
                        title:
                            "Record your best epic movie trailer voice. Think dramatic, powerful, and heroic.",
                        fSize: 16,
                        fWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                      SizedBox(height: 10.h),
                      CommonText(
                        title: "3 days, 14:22:08 remaining",
                        fSize: 12,
                        fWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        height: 48.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Color(0xFF7741C1),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 5,
                            children: [
                              CommonText(
                                title: "Submit Your Take",
                                fSize: 20.sp,
                                fWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              ListView.builder(
                itemCount: 3,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => CommercialScreen());
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 16),
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
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: ClipOval(
                                child: CommonImage(
                                  imageSrc: AppImage.person,
                                  imageType: ImageType.png,
                                  height: 50.h,
                                  width: 50.h,
                                  fill: BoxFit.cover,
                                ),
                              ),
                              title: CommonText(
                                title: "Alex Mercer",
                                fSize: 14,
                                fWeight: FontWeight.w700,
                                color: AppColor.primary,
                              ),
                              subtitle: CommonText(
                                title: "2 hours",
                                fSize: 12,
                                fWeight: FontWeight.w500,
                                color: AppColor.primary,
                              ),
                              trailing: Container(
                                height: 24.h,
                                width: 93.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(0xFFE5E2FD),
                                ),
                                child: Center(
                                  child: CommonText(
                                    title: "Commercial",
                                    fSize: 12,
                                    fWeight: FontWeight.w500,
                                    color: AppColor.primary,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            CommonText(
                              title: "Nissan - Epic Journey (Spec)",
                              fSize: 14,
                              fWeight: FontWeight.w600,
                              color: AppColor.primary,
                            ),
                            SizedBox(height: 10.h),
                            Container(
                              height: 66.h,
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFFF3F4F6),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  ValueListenableBuilder<bool>(
                                    valueListenable: controller.isPlaying,
                                    builder: (context, isPlaying, _) {
                                      return GestureDetector(
                                        onTap: controller.togglePlay,
                                        child: Container(
                                          height: 39.h,
                                          width: 39.h,
                                          decoration: const BoxDecoration(
                                            color: Color(0xff3C2A5D),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            isPlaying
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(width: 15.w),
                                  Expanded(
                                    child: SizedBox(
                                      height: 48.h,
                                      child: CustomPaint(
                                        painter: CleanWavePainter(),
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 15.w),

                                  CommonText(
                                    title: "1:24",
                                    fSize: 12,
                                    fWeight: FontWeight.w700,
                                    color: AppColor.secondary,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 14.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  spacing: 20,
                                  children: [
                                    Row(
                                      spacing: 5,
                                      children: [
                                        Image.asset(
                                          AppIcons.love,
                                          height: 20.h,
                                          width: 20.w,
                                          fit: BoxFit.cover,
                                        ),
                                        CommonText(
                                          title: "234",
                                          color: AppColor.secondary,
                                          fSize: 12,
                                          fWeight: FontWeight.w700,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      spacing: 5,
                                      children: [
                                        Image.asset(
                                          AppIcons.message,
                                          height: 20.h,
                                          width: 20.w,
                                          fit: BoxFit.cover,
                                        ),
                                        CommonText(
                                          title: "12",
                                          color: AppColor.secondary,
                                          fSize: 12,
                                          fWeight: FontWeight.w700,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Image.asset(
                                  AppIcons.fav,
                                  height: 20.h,
                                  width: 20.w,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CleanWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD6CFF5)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final centerY = size.height / 2;

    final List<double> pattern = [
      4,
      6,
      8,
      12,
      16,
      12,
      8,
      6,
      4,
      6,
      10,
      14,
      18,
      14,
      10,
      6,
    ];

    double x = 0;

    for (int i = 0; x < size.width; i++) {
      final height = pattern[i % pattern.length];

      canvas.drawLine(
        Offset(x, centerY - height / 2),
        Offset(x, centerY + height / 2),
        paint,
      );

      x += 4;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
