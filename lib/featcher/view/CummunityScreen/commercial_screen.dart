import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:waveform_flutter/waveform_flutter.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_icons.dart';
import '../../../core/widgets/common_text.dart';
import '../../controller/CommunityController/community_controller.dart';

class CommercialScreen extends StatelessWidget {
  CommercialScreen({super.key});

  final CommunityController controller = Get.put(CommunityController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        centerTitle: true,
        toolbarHeight: 80,
        title: Column(
          children: [
            Container(
              height: 24.h,
              width: 100.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFFD2CBFA),
              ),
              child: const Center(
                child: CommonText(
                  title: "COMMERCIAL",
                  fSize: 10,
                  fWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 7.h),
            const CommonText(
              title: "Nike - Limitless",
              fSize: 18,
              fWeight: FontWeight.w800,
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          SizedBox(height: 40.h),
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
                          CommonText(
                            title: "Narrator",
                            fSize: 15,
                            fWeight: FontWeight.w700,
                            color: AppColor.secondary,
                          ),
                          SizedBox(height: 5),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Color(0xFFE5E2FD),
                      borderRadius: BorderRadius.only(
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
                        SizedBox(height: 40.h),
                        Obx(
                          () => CommonText(
                            title: controller.formattedTime,
                            fSize: 40.h,
                            fWeight: FontWeight.w700,
                          ),
                        ),

                        SizedBox(height: 20.h),

                        Obx(() {
                          return Wave(
                            stream: controller.isRecording.value
                                ? controller.micStream
                                : Stream.empty(),
                          );
                        }),

                        SizedBox(height: 40.h),

                        Obx(
                          () => GestureDetector(
                            onTap: controller.toggleRecording,
                            child: Container(
                              height: 95.h,
                              width: 95.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: controller.isRecording.value
                                    ? Colors.white
                                    : const Color(0xFFFB2C36),
                                border: Border.all(
                                  color: controller.isRecording.value
                                      ? Colors.red.shade200
                                      : Colors.white,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x4DFB2C36),
                                    offset: Offset(0, 15),
                                    blurRadius: 12.8,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: controller.isRecording.value
                                    ? Image.asset(AppIcons.redBox)
                                    : Image.asset(AppIcons.music),
                              ),
                            ),
                          ),
                        ),
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

class Wave extends StatelessWidget {
  final Stream<Amplitude> stream;

  const Wave({super.key, required this.stream});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.find<CommunityController>();

      return SizedBox(
        height: 20,
        width: 240.w,
        child: AnimatedWaveList(
          stream: controller.isRecording.value
              ? stream
              : createRandomAmplitudeStream(),
          barBuilder: (animation, amplitude) => WaveFormBar(
            animation: animation,
            amplitude: amplitude,
            color: Colors.black,
          ),
        ),
      );
    });
  }
}
