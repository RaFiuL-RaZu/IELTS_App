import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/constant/other_helper.dart';
import 'package:justtsham/featcher/controller/CommunityController/community_controller.dart';
import 'package:justtsham/featcher/controller/HomeController/home_controller.dart';
import 'package:justtsham/featcher/model/CommunityModel/weekly_model.dart';
import 'package:justtsham/featcher/model/ProfileModel/favourite_model.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_icons.dart';
import '../../../core/utils/app_image.dart';
import '../../../core/utils/app_urls.dart';
import '../../../core/widgets/commom_image.dart';
import '../../../core/widgets/common_text.dart';
import '../../controller/CommunityController/box_controller.dart';
import '../../controller/ProfileController/save_audition_controller.dart';
import '../../controller/ProfileController/save_controller.dart';
import '../../model/HomeModel/audition_model.dart';
import '../HomeScreen/waveForme.dart';

class SaveAudition extends StatefulWidget {
  const SaveAudition({super.key});

  @override
  State<SaveAudition> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<SaveAudition> {
  final controller = Get.put(SaveAuditionController());
  final SaveController boxController=Get.put(SaveController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getCommunity();
    });
    boxController.getFavourite();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        title: CommonText(
          title: "Save Audition",
          fSize: 22.sp,
          fWeight: FontWeight.w700,
          color: AppColor.primary,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx((){
                if (boxController.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColor.primary),
                  );
                }

                if (boxController.faveList.isEmpty) {
                  return Center(child: CommonText(title: "No Audition Found"));
                }return ListView.builder(
                    itemCount: boxController.faveList.length,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context,index){
                      FavouriteModel list = boxController.faveList[index];
                      return  Container(
                        margin: EdgeInsets.only(bottom: 16),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00897B).withOpacity(0.08),
                              offset: const Offset(0, 8),
                              blurRadius: 16,
                              spreadRadius: -2,
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
                                  child: (list.audition.creator.profileImage.isNotEmpty ?? false)
                                      ? CommonImage(
                                    imageSrc: AppUrl.getFullUrl(list.audition.creator.profileImage),
                                    imageType: ImageType.network,
                                    height: 50.h,
                                    width: 50.h,
                                    fill: BoxFit.cover,
                                  )
                                      : Container(
                                    height: 50.h,
                                    width: 50.h,
                                    color: Colors.grey.shade300,
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                title: CommonText(
                                  title: list.audition.creator.fullName ?? "",
                                  fSize: 14,
                                  fWeight: FontWeight.w700,
                                  color: AppColor.primary,
                                ),
                                subtitle: CommonText(
                                  title: OtherHelper.timeAgo(list.createdAt.toString()),
                                  fSize: 12,
                                  fWeight: FontWeight.w500,
                                  color: AppColor.primary,
                                ),
                                trailing: Container(
                                  height: 24.h,
                                  width: 93.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: AppColor.tealLight,
                                  ),
                                  child: Center(
                                    child: CommonText(
                                      title: list.audition.category.toString(),
                                      fSize: 12,
                                      fWeight: FontWeight.w500,
                                      color: AppColor.primary,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Obx(() {
                                final isExpanded = controller.expandedIndex.value == index;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonText(
                                      title: list.audition.title.toString(),
                                      fSize: 14,
                                      maxLine: isExpanded ? null : 3,
                                      overflow:
                                      isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                                      fWeight: FontWeight.w600,
                                      color: AppColor.primary,
                                    ),

                                    SizedBox(height: 4),

                                    GestureDetector(
                                      onTap: () => controller.toggleExpand(index),
                                      child: Text(
                                        isExpanded ? "See less" : "See more",
                                        style: TextStyle(
                                          color: AppColor.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
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
                                  child:Row(
                                    children: [
                                      Obx(() {
                                        final url = AppUrl.getFullUrl(list.audition.auditionFile);
                                        final isPlaying =
                                            boxController.currentUrl.value == url &&
                                                boxController.isPlaying.value;

                                        return GestureDetector(
                                          onTap: () => boxController.togglePlay(url),
                                          child: Container(
                                            height: 39.h,
                                            width: 39.h,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF00897B),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              isPlaying ? Icons.pause : Icons.play_arrow,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        );
                                      }),

                                      SizedBox(width: 10.w),

                                      Expanded(
                                        child: Obx(() {
                                          final url = AppUrl.getFullUrl(list.audition.auditionFile);

                                          final showProgress = boxController.currentUrl.value == url;

                                          return WaveformProgress(
                                            progress: showProgress
                                                ? boxController.progress.value
                                                : 0.0,
                                          );
                                        }),
                                      ),

                                      SizedBox(width: 10.w),

                                      Obx(() {
                                        final url = AppUrl.getFullUrl(list.audition.auditionFile);

                                        final isCurrentPlaying = boxController.currentUrl.value == url;

                                        if (!isCurrentPlaying) return const SizedBox.shrink();

                                        return Text(
                                          boxController.formatTime(boxController.position.value),
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: AppColor.secondary,
                                          ),
                                        );
                                      }),
                                    ],
                                  )
                              ),
                              SizedBox(height: 14.h),
                            ],
                          ),
                        ),
                      );
                    });
              }),
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
      ..color = const Color(0xFF80CBC4)
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
