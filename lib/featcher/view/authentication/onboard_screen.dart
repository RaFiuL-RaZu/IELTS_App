import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/constant/prefs_helper.dart';
import 'package:justtsham/core/utils/app_icons.dart';
import 'package:justtsham/core/widgets/coomon_button.dart';
import 'package:justtsham/routes/routes.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_image.dart';

class OnboardingScreen extends StatefulWidget{
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {


  final PageController _controller = PageController();
  int currentIndex = 0;
  final List<Map<String, dynamic>> pages = [
    {
      "image": AppImage.banner1,
      "iconData": Icons.record_voice_over_rounded,
      "title": "Practice Speaking Cue Cards",
      "desc": "Record your responses, review sample Band 8+ answers, and get real-time audio waveform feedback.",
    },
    {
      "image": AppImage.banner3,
      "iconData": Icons.insights_rounded,
      "title": "Track Mock Tests & Bands",
      "desc": "Monitor your band score progress, manage upcoming test dates, and evaluate your preparation.",
    },
    {
      "image": AppImage.banner2,
      "iconData": Icons.groups_rounded,
      "title": "IELTS Study Community",
      "desc": "Share speaking recordings and essays to get peer feedback and expert band ratings.",
    },
  ];

  void nextPage() async {
    if (currentIndex < pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      PrefsHelper.hasSeenOnboard = true;
      await PrefsHelper.setBool("hasSeenOnboard", true);
      Get.offAllNamed(AppRoutes.candidateSetup);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        itemCount: pages.length,
        onPageChanged: (index) {
          setState(() => currentIndex = index);
        },
        itemBuilder: (context, index) {
          return buildPage(
            title: pages[index]["title"] as String,
            desc: pages[index]["desc"] as String,
            image: pages[index]["image"] as String,
            iconData: pages[index]["iconData"] as IconData,
          );
        },
      ),
    );
  }

  Widget buildPage({
    required String title,
    required String desc,
    required String image,
    required IconData iconData,
  }) {
    return Stack(
      children: [
        SizedBox(
          height: 580.h,
          width: 392.w,
          child: Image.asset(
            image,
            fit: BoxFit.cover,
            height: 512.h,
          ),
        ),

        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 375.h,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: AppColor.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 22.h),

                // Center Themed Soft Teal Icon
                Container(
                  height: 64.h,
                  width: 64.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFF0FDFA),
                    border: Border.all(color: const Color(0xFFCCFBF1), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00695C).withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      iconData,
                      color: const Color(0xFF00695C),
                      size: 30.sp,
                    ),
                  ),
                ),

                SizedBox(height: 14.h),

                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.5.sp,
                    color: AppColor.secondary,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),

                SizedBox(height: 20.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    pages.length,
                    (index) => buildIndicator(index),
                  ),
                ),

                SizedBox(height: 20.h),

                CommonButton(
                  onTap: nextPage,
                  titleText: currentIndex == pages.length - 1 ? "Get Started" : "Continue",
                  buttonRadius: 16,
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildIndicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: currentIndex == index ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: currentIndex == index
            ? AppColor.primary
            : AppColor.primary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}