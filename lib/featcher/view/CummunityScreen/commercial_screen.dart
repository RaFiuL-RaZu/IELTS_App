import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/widgets/coomon_button.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_icons.dart';
import '../../../core/widgets/common_text.dart';
import '../../controller/CommunityController/commercial_controller.dart';

class CommercialScreen extends StatelessWidget {
  CommercialScreen({super.key, required this.title, required this.id, required this.page});

  final String title;
  final String id;
  final String page;

  final controller = Get.put(CommercialController());

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
                color: AppColor.tealLight,
              ),
              child: const Center(
                child: CommonText(
                  title: "IELTS SPEAKING",
                  fSize: 10,
                  fWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 7.h),
            const CommonText(
              title: "Speaking Practice & Recording",
              fSize: 18,
              fWeight: FontWeight.w800,
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          SizedBox(height: 10),
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 280,
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
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              title: "Prompt Notes & Model Answer",
                              fSize: 15,
                              fWeight: FontWeight.w700,
                              color: AppColor.secondary,
                            ),
                            SizedBox(height: 5),
                            CommonText(
                              title: title,
                              fSize: 16,
                              fWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 340,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColor.background,
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
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                          Obx(() {
                            final isRecorded = controller.isRecorded.value;

                            final current = controller.currentPosition.value;
                            final total = controller.totalDuration.value;

                            if (isRecorded) {
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
                          const SizedBox(height: 5),
                          Obx(() {
                            if (controller.isRecording.value) {
                              return AudioWaveforms(
                                enableGesture: false,
                                size: Size(double.infinity, 20),
                                recorderController:
                                    controller.recorderController,
                                waveStyle: const WaveStyle(
                                  waveColor: Colors.black,
                                  showMiddleLine: false,
                                  extendWaveform: true,
                                  spacing: 4,
                                  waveThickness: 3,
                                ),
                              );
                            } else if (controller.isRecorded.value) {
                              return AudioFileWaveforms(
                                backgroundColor: AppColor.primary,
                                size: Size(double.infinity, 60),
                                playerController: controller.playerController,
                                waveformType: WaveformType.fitWidth,
                                playerWaveStyle: PlayerWaveStyle(
                                  liveWaveColor: AppColor.primary,
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          }),
                          SizedBox(height: 5),
                          Obx(() {
                            if (controller.isRecorded.value) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 30,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      controller.deleteRecording();
                                    },
                                    child: Container(
                                      height: 48.h,
                                      width: 48.w,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFE2E2),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
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
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (controller.recordedPath == null) {
                                        return;
                                      }

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
                                        padding: EdgeInsets.all(0.0),
                                        child: Center(
                                          child: Obx(
                                            () => Icon(
                                              controller.playerState.value ==
                                                      PlayerState.playing
                                                  ? Icons.pause
                                                  : Icons.play_arrow,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Obx((){
                                    if(controller.isLoading.value){
                                      return Center(child: CircularProgressIndicator(color: AppColor.primary,),);
                                    }else{
                                      return GestureDetector(
                                        onTap: () {
                                          controller.practiceScript(id: id, title: page);
                                        },
                                        child: Container(
                                          height: 48.h,
                                          width: 48.w,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFC1FFD6),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.1,
                                                ),
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
                                      );
                                    }
                                  }),
                                ],
                              );
                            } else {
                              return GestureDetector(
                                onTap: () async {
                                  if (controller.isRecording.value) {
                                    await controller.stopRecording();
                                  } else {
                                    await controller.startRecording();
                                  }
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
                            SizedBox(height: 10),
                            CommonButton(
                              onTap: (){
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      insetPadding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(20),
                                      ),
                                      child: Container(
                                      width: double.infinity,
                                      height: 460.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(20),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.only(
                                                topLeft:
                                                Radius.circular(
                                                  20,
                                                ),
                                                topRight:
                                                Radius.circular(
                                                  20,
                                                ),
                                              ),
                                              color:
                                              AppColor.background,
                                            ),
                                            child: ListTile(
                                              contentPadding:
                                              EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 10,
                                              ),
                                              leading: Container(
                                                height: 63.h,
                                                width: 63.w,
                                                decoration: BoxDecoration(
                                                  color: AppColor.tealLight,
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                    16,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                  EdgeInsets.all(
                                                    10.0,
                                                  ),
                                                  child: Center(
                                                    child: Image.asset(
                                                      AppIcons.faq,
                                                      height: 31.h,
                                                      width: 31.w,
                                                      color: AppColor
                                                          .primary,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              title: CommonText(
                                                title: "Upload Audio",
                                                fSize: 20,
                                                fWeight:
                                                FontWeight.w800,
                                                color: AppColor.primary,
                                              ),
                                              subtitle: CommonText(
                                                title:
                                                "Add your recordings to this script",
                                                fSize: 14,
                                                fWeight:
                                                FontWeight.w500,
                                                color:
                                                AppColor.secondary,
                                              ),
                                              trailing: IconButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                icon: Icon(Icons.close),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 16.h),
                                          Padding(
                                            padding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: [
                                                CommonText(
                                                  title: "From Device",
                                                  fSize: 12,
                                                  fWeight:
                                                  FontWeight.w700,
                                                  color: AppColor
                                                      .secondary,
                                                ),
                                                SizedBox(height: 10.h),
                                                ProfileBox(
                                                  onTap: (){
                                                    Get.back();
                                                    controller.pickAudioFile();
                                                  },
                                                  title: 'Browse Files',
                                                  text:
                                                  'MP3, WAV, M4A, or OGG',
                                                  icon: AppIcons.tablet,
                                                  boxColor: Color(
                                                    0xFFF3F4F6,
                                                  ),
                                                ),
                                                SizedBox(height: 23.h),
                                                CommonText(
                                                  title:
                                                  "From Cloud Storage",
                                                  fSize: 12,
                                                  fWeight:
                                                  FontWeight.w700,
                                                  color: AppColor
                                                      .secondary,
                                                ),
                                                SizedBox(height: 10.h),
                                                ProfileBox(
                                                  onTap: () {
                                                    Get.back();
                                                    controller.pickAudioFile();
                                                  },
                                                  title: 'Google Drive',
                                                  icon: AppIcons.drop,
                                                  boxColor: const Color(0xFFFFFFFF),
                                                ),
                                                SizedBox(height: 12.h),
                                                ProfileBox(
                                                  onTap: () {
                                                    Get.back();
                                                    controller.pickAudioFile();
                                                  },
                                                  title: 'Cloud Drive',
                                                  icon: AppIcons.drop,
                                                  boxColor: const Color(0xFFFFFFFF),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            titleText: "Upload Audio",
                            prefixIcon: Image.asset(
                              AppIcons.download,
                              height: 24.h,
                              width: 24.w,
                              color: AppColor.primary,
                            ),
                            titleColor: AppColor.primary,
                            backgroundColor: Color(0xFFFFFFFF),
                            useGradient: false,
                            buttonWidth: 216.w,
                            buttonHeight: 43.h,
                            titleSize: 14,
                          ),
                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                  ),
                ),)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget ProfileBox({
    required String title,
    String? text,
    required String icon,
    Color? color,
    Color? boxColor,
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
          // border: Border.all(color: Color(0xFFE5E7EB))
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Row(
                  children: [
                    Container(
                      height: 40.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 1,
                            spreadRadius: 1,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          icon,
                          height: 20.h,
                          width: 20.w,
                          color: AppColor.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 15.w),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      title: title,
                      fSize: 16,
                      fWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    if (text != null)
                      CommonText(
                        title: text,
                        fSize: 12,
                        fWeight: FontWeight.w500,
                        color: color ?? AppColor.secondary,
                      ),
                  ],
                ),
              ],
            ),
            Image.asset(
              AppIcons.download,
              height: 18,
              width: 18,
              color: AppColor.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
