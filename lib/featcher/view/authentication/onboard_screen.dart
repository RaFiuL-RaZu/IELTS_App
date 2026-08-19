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
  final List<Map<String, String>> pages = [
    {
      "image": AppImage.banner1,
      "icon": AppIcons.icon3,
      "title": "Practice Speaking Cue Cards",
      "desc": "Record your responses, review sample Band 8+ answers, and get real-time audio waveform feedback.",
    },
    {
      "image": AppImage.banner3,
      "icon": AppIcons.icon2,
      "title": "Track Mock Tests & Bands",
      "desc": "Monitor your band score progress, manage upcoming test dates, and evaluate your preparation.",
    },
    {
      "image": AppImage.banner2,
      "icon": AppIcons.icon1,
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
      Get.toNamed(AppRoutes.login);
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
            title: pages[index]["title"]!,
            desc: pages[index]["desc"]!, image:pages[index]["image"]!, icon: pages[index]["icon"]!,
          );
        },
      ),
    );
  }

  Widget buildPage({required String title, required String desc,required String image, required String icon}) {
    return Stack(
      children: [
        SizedBox(
          height:580.h,
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
            height: 360.h,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColor.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 20.h,),
                Image.asset(icon,height: 100.w,width: 100.w,fit: BoxFit.cover,),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColor.secondary,
                    fontWeight: FontWeight.w500
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
                 titleText:
                   currentIndex == pages.length - 1
                       ? "Get Started"
                       : "Continue",
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
      width: currentIndex == index ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color:
        currentIndex == index ? const Color(0xFF3B2A5A) : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}