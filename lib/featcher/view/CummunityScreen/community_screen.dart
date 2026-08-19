import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/constant/other_helper.dart';
import 'package:justtsham/featcher/controller/CommunityController/community_controller.dart';
import 'package:justtsham/featcher/controller/HomeController/home_controller.dart';
import 'package:justtsham/featcher/model/CommunityModel/weekly_model.dart';

import '../../../core/constant/prefs_helper.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_icons.dart';
import '../../../core/utils/app_image.dart';
import '../../../core/utils/app_urls.dart';
import '../../../core/widgets/commom_image.dart';
import '../../../core/widgets/common_text.dart';
import '../../controller/CommunityController/box_controller.dart';
import '../../model/HomeModel/audition_model.dart';
import '../HomeScreen/waveForme.dart';
import 'commercial_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final controller = Get.put(CommunityController());
  final BoxController boxController=Get.put(BoxController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getCommunity();
    });
    boxController.getBoxData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                title: "IELTS Community",
                fSize: 22,
                fWeight: FontWeight.w800,
                color: AppColor.primary,
              ),
              SizedBox(height: 12.h),
              Obx(() {
               if (controller.isLoading.value) {
                 return Center(
                   child: CircularProgressIndicator(color: AppColor.primary),
                 );
               }

               final data = controller.weeklyModel;
               if (data == null) {
                 return const SizedBox();
               }

               return Container(
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
                         title: data.title ?? "",
                         maxLine: 2,
                         fSize: 22,
                         overflow: TextOverflow.ellipsis,
                         fWeight: FontWeight.w700,
                         color: Colors.white,
                       ),
                       SizedBox(height: 10.h),
                       CommonText(
                         title:
                         data.content ?? "",
                         fSize: 16,
                         maxLine: 3,
                         overflow: TextOverflow.ellipsis,
                         fWeight: FontWeight.w400,
                         color: Colors.white,
                       ),
                       SizedBox(height: 10.h),
                       CommonText(
                         title: "${OtherHelper.formatDate(data.weeklyScriptExpiryDate.toString())} remaining",
                         fSize: 12,
                         fWeight: FontWeight.w400,
                         color: Colors.white,
                       ),
                       SizedBox(height: 10.h),
                       GestureDetector(
                         onTap: () {
                           if(data.isPracticed==false){
                             Get.to(() => CommercialScreen(title:data.content.toString(), id: data.id.toString(), page: 'community',));
                           }
                         },
                         child: Container(
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
                                   title: data.isPracticed==true ? "Completed" : "Submit Your Take",
                                   fSize: 20.sp,
                                   fWeight: FontWeight.w500,
                                   color: Colors.white,
                                 ),
                               ],
                             ),
                           ),
                         ),
                       ),
                     ],
                   ),
                 ),
               );
               ;
             }),
              SizedBox(height: 20.h),
              Obx((){
                if (boxController.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColor.primary),
                  );
                }

                if (boxController.communityList.isEmpty) {
                  return Center(child: CommonText(title: "No Audition Found"));
                }return ListView.builder(
                    itemCount: boxController.communityList.length,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context,index){
                      CommunityModel list = boxController.communityList[index];
                      return  Container(
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
                                  child: (list.user?.profileImage?.isNotEmpty ?? false)
                                      ? CommonImage(
                                    imageSrc: AppUrl.imageUrl + list.user!.profileImage!,
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
                                  title: list.user?.fullName ?? "",
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
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 24.h,
                                      padding: const EdgeInsets.symmetric(horizontal:10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: const Color(0xFFE5E2FD),
                                      ),
                                      child: Center(
                                        child: CommonText(
                                          title: list.category.toString(),
                                          fSize: 12,
                                          fWeight: FontWeight.w500,
                                          color: AppColor.primary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 1),
                                    PopupMenuButton<String>(
                                      color: Colors.white,
                                      surfaceTintColor: Colors.white,
                                      icon: const Icon(Icons.more_vert),
                                      onSelected: (value) async {
                                        final success = await boxController.notInterestedCommunity(
                                          id: list.id.toString(),
                                          action: value,
                                        );

                                        if (success) {
                                          debugPrint("$value Success");
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        PopupMenuItem<String>(
                                          value: PrefsHelper.userId == list.user!.id.toString()
                                              ? "delete"
                                              : "notInterested",
                                          child: SizedBox(
                                            width: 150,
                                            child: Text(
                                              PrefsHelper.userId == list.user!.id.toString()
                                                  ? "Delete"
                                                  : "Report",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Obx(() {
                                final isExpanded = controller.expandedIndex.value == index;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonText(
                                      title: list.content.toString(),
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
                                        final url = AppUrl.imageUrl + (list.audioFile ?? "");
                                        final isPlaying =
                                            boxController.currentUrl.value == url &&
                                                boxController.isPlaying.value;

                                        return GestureDetector(
                                          onTap: () => boxController.togglePlay(url),
                                          child: Container(
                                            height: 39.h,
                                            width: 39.h,
                                            decoration: const BoxDecoration(
                                              color: Color(0xff3C2A5D),
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
                                          final url = AppUrl.imageUrl + (list.audioFile ?? "");

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
                                        final url = AppUrl.imageUrl + (list.audioFile ?? "");

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
