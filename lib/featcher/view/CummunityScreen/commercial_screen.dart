import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/common_text.dart';

class CommercialScreen extends StatelessWidget {
  const CommercialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        centerTitle: true,
        toolbarHeight: 80,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 24.h,
              width: 100.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFFD2CBFA),
              ),
              child: Center(
                child: CommonText(
                  title: "COMMERCIAL",
                  fSize: 10,
                  fWeight: FontWeight.w600,
                  color: AppColor.primary,
                ),
              ),
            ),
            SizedBox(height: 7.h,),
            CommonText(
              title: "Nike - Limitless",
              fSize: 18,
              fWeight: FontWeight.w800,
              color: AppColor.primary,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 40),
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16),
                    height: 315.h,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(title: "Narrator",fSize: 15,fWeight: FontWeight.w700,color: AppColor.secondary,),
                          SizedBox(height: 5,),
                          CommonText(
                            title:
                            "Some people say the sky is the limit. But what if you don't even believe in the sky?\nWhat if every time they told you to slow down, you just found a new gear?\nIntroducing the all-new experience. Designed for those who don't just follow the path... they create it.\nGet yours today.",
                            fSize: 16,
                            fWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 328.h,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Color(0xFFE5E2FD),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          offset: Offset(0, -1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
