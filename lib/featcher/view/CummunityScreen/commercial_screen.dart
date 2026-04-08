import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:waveform_flutter/waveform_flutter.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_icons.dart';
import '../../../core/widgets/common_text.dart';
import '../../controller/CommunityController/commercial_controller.dart';

class CommercialScreen extends StatelessWidget {
  const CommercialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CommercialController());
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
                    height: 348.h,
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
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          SizedBox(height: 20.h),
                          Obx(() {
                            if (controller.isRecorded.value) {
                              return Text(
                                controller.remainingTime(),
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            } else {
                              return Text(
                                controller.formattedTime,
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          }),

                          const SizedBox(height: 20),
                          Obx(() {
                            if (controller.isRecording.value) {
                              return AudioWaveforms(
                                enableGesture: false,
                                size: Size(double.infinity, 60),
                                recorderController: controller.recorderController,
                                waveStyle: const WaveStyle(
                                  waveColor: Colors.black,
                                  showMiddleLine: false,
                                  extendWaveform: true,
                                  spacing: 4,
                                  waveThickness: 3,
                                ),
                              );
                            }

                            else if (controller.isRecorded.value) {
                              return AudioFileWaveforms(
                                backgroundColor: AppColor.primary,
                                size: Size(double.infinity, 60),
                                playerController: controller.playerController,
                                waveformType: WaveformType.fitWidth,
                               playerWaveStyle: PlayerWaveStyle(
                                 liveWaveColor: AppColor.primary
                               ),
                              );
                            }

                            else {
                              return const SizedBox();
                            }
                          }),

                          const Spacer(),
                          Obx(() {
                            if (controller.isRecorded.value) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 30,
                                children: [
                                  Container(
                                    height: 48.h,
                                    width: 48.w,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFFE2E2),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 3,
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Center(
                                        child: Image.asset(
                                          AppIcons.drive,
                                          color: Colors.red,
                                          height: 20.h,
                                          width: 20.w,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (controller.recordedPath == null)
                                        return;

                                      await controller.playPause();
                                    },
                                    child: Container(
                                      height: 95.h,
                                      width: 95.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColor.primary,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          controller.playerController.playerState == PlayerState.playing
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          color: Colors.white,
                                        )
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 48.h,
                                    width: 48.w,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFC1FFD6),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 3,
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Center(
                                        child: Image.asset(
                                          AppIcons.delete,
                                          color: Colors.green,
                                          height: 20.h,
                                          width: 20.w,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return GestureDetector(
                                onTapDown: (_) async {
                                  debugPrint("TAP DOWN");
                                  await controller.startRecording();
                                },
                                onTapUp: (_) async {
                                  debugPrint("TAP UP");
                                  await controller.stopRecording();
                                },
                                onTapCancel: () async {
                                  await controller.stopRecording();
                                },
                                child: Obx(() {
                                  return Container(
                                    height: 95.h,
                                    width: 95.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: controller.isRecording.value
                                          ? Colors.white
                                          : Colors.red,
                                      border: controller.isRecording.value
                                          ? Border.all(color: Colors.red)
                                          : Border.all(
                                              color: AppColor.background,
                                            ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(25.0),
                                      child: Image.asset(
                                        controller.isRecording.value
                                            ? AppIcons.redBox
                                            : AppIcons.music,
                                        color: controller.isRecording.value
                                            ? Colors.red
                                            : Colors.white,
                                        height: 24,
                                        width: 24,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  );
                                }),
                              );
                            }
                          }),
                          SizedBox(height: 25.h),
                        ],
                      ),
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
