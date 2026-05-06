import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/constant/other_helper.dart';
import 'package:justtsham/core/utils/app_colors.dart';
import 'package:justtsham/core/utils/app_icons.dart';
import 'package:justtsham/core/utils/app_urls.dart';
import 'package:justtsham/core/widgets/common_text.dart';
import 'package:justtsham/featcher/controller/HomeController/home_controller.dart';
import 'package:justtsham/featcher/model/HomeModel/audition_model.dart';

import '../../../core/utils/app_image.dart';
import '../../../core/widgets/commom_image.dart';
import '../CummunityScreen/community_screen.dart';
import 'notification_screen.dart';


class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller=Get.put(HomeController());
  @override
  void initState() {
    controller.getHomeData();
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
              SizedBox(height: 60.h,),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: CommonText(title: "Good Morning!",fSize:16,fWeight: FontWeight.w500,color: AppColor.secondary,),
                subtitle: CommonText(title: "Studio Feed",fSize: 22,fWeight: FontWeight.w700,color: AppColor.primary,),
                trailing: GestureDetector(
                  onTap: (){
                    Get.to(()=>NotificationScreen());
                  },
                  child: Container(
                    height: 40.h,
                    width: 40.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 3,
                          ),
                        ]
                    ),child:Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(AppIcons.notify,height: 20.h,width: 17.w,color: AppColor.primary,),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h,),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Row(
                           spacing: 5,
                           children: [
                             Image.asset(AppIcons.trophy, height: 15.h, width: 15.h),
                             CommonText(
                               title: "Weekly Challenge",
                               fSize: 12,
                               fWeight: FontWeight.w700,
                               color: Colors.white,
                             ),
                           ],
                         ),
                         SizedBox(height: 6.h),
                         CommonText(
                           title: '"Superhero Movie Trailer"',
                           fSize: 20,
                           fWeight: FontWeight.w700,
                           color: Colors.white,
                         ),
                         SizedBox(height: 5.h),
                         CommonText(
                           title: "324 entries • Ends in 2d",
                           fSize: 14,
                           fWeight: FontWeight.w400,
                           color: Colors.white,
                         ),
                       ],
                     ),
                      Container(
                        height: 48.h,
                        width: 48.w,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 3,
                              ),
                            ]
                        ),child:Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Image.asset(AppIcons.play,height: 19.h,width: 19.w,color: AppColor.primary,fit: BoxFit.fill,),
                      ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h,),
              Obx(() => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(controller.items.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          controller.selectItem(index);
                          debugPrint("selected index: ${controller.selectedIndex.value}");
                          debugPrint("selected item: ${controller.items[index]}");
                        },
                        child: voiceBox(
                          title: controller.items[index],
                          isSelected: controller.selectedIndex.value == index,
                        ),
                      ),
                    );
                  }),
                ),
              )),
              SizedBox(height: 20.h,),
              Obx((){
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColor.primary),
                  );
                }

                if (controller.filteredList.isEmpty) {
                  return Center(child: CommonText(title: "No Audition Found"));
                }return ListView.builder(
                      itemCount: controller.filteredList.length,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context,index){
                        AuditionModel list = controller.filteredList[index];
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
                                    child: CommonImage(
                                      imageSrc: AppUrl.imageUrl + list.creator.profileImage,
                                      imageType: ImageType.network,
                                      height: 50.h,
                                      width: 50.h,
                                      fill: BoxFit.cover,
                                    ),
                                  ),
                                  title: CommonText(
                                    title: list.creator.fullName,
                                    fSize: 14,
                                    fWeight: FontWeight.w700,
                                    color: AppColor.primary,
                                  ),
                                  subtitle: CommonText(
                                    title: OtherHelper.timeAgo(list.creator.createdAt.toString()),
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
                                        title: list.category,
                                        fSize: 12,
                                        fWeight: FontWeight.w500,
                                        color: AppColor.primary,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                CommonText(
                                  title: list.title,
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
                                      Obx(() {
                                        final url = AppUrl.imageUrl + list.auditionFile;

                                        final isPlaying =
                                            controller.currentUrl.value == url &&
                                                controller.isPlaying.value;

                                        return GestureDetector(
                                          onTap: () => controller.togglePlay(url),
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

                                      /// WAVE
                                      Expanded(
                                        child: AudioFileWaveforms(
                                          size: Size(double.infinity, 50),
                                          playerController: controller.playerController,
                                          waveformType: WaveformType.fitWidth,
                                          enableSeekGesture: true,
                                        ),
                                      ),

                                      SizedBox(width: 10.w),

                                      /// TIME
                                      Flexible(
                                        child: Text(
                                          "1:24",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: AppColor.secondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
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
                                              title: list.likeCount.toString(),
                                              color: AppColor.secondary,
                                              fSize: 12,
                                              fWeight: FontWeight.w700,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          spacing: 5,
                                          children: [
                                            GestureDetector(
                                              onTap: (){
                                                controller.toggleCommentField(index);

                                              },
                                              child: Image.asset(
                                                AppIcons.message,
                                                height: 20.h,
                                                width: 20.w,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            CommonText(
                                              title: list.commentCount.toString(),
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
                                Obx(() {
                                  return AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: controller.activeCommentIndex.value == index
                                        ? Padding(
                                      key: const ValueKey("comment"),
                                      padding: EdgeInsets.only(top: 12.h),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: controller.commentController,
                                              decoration: InputDecoration(
                                                prefixIcon: Padding(
                                                  padding: const EdgeInsets.all(12.0),
                                                  child: Image.asset(
                                                    AppIcons.message,
                                                    height: 10.h,
                                                    width: 10.w,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                suffixIcon:Padding(
                                                  padding: const EdgeInsets.all(12.0),
                                                  child: GestureDetector(
                                                    onTap: (){
                                                      controller.postComment(id: list.id);
                                                    },
                                                    child: Image.asset(
                                                      AppIcons.send,
                                                      height: 10.h,
                                                      width: 10.w,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                hintText: "Write a comment...",
                                                hintStyle: const TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF99A1AF),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                     enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFBFBFBF),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF6C4DFF),
                                        width: 1.5,
                                      ),
                                    ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    )
                                        : const SizedBox.shrink(),
                                  );
                                })
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

  Container voiceBox({
    required String title,
    required bool isSelected,
  }) {
    return Container(
      height: 34.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: isSelected
              ? [
            Color(0xFF180E27),
            Color(0xFF56397C),

          ]
              : [
            Colors.white,
            Colors.white
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? Colors.white.withOpacity(0.3)
                : Color(0xFF8A79D6),
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: CommonText(
            title: title,
            fSize: 14,
            fWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
class CleanWavePainter extends CustomPainter {
  final double progress;

  CleanWavePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2
      ..color = Colors.deepPurple
      ..strokeCap = StrokeCap.round;

    final centerY = size.height / 2;

    final barCount = 40;
    final barWidth = size.width / barCount;

    for (int i = 0; i < barCount; i++) {
      final x = i * barWidth;

      double waveHeight = (i / barCount) < progress
          ? (10 + (i % 5) * 3) // active wave
          : 3; // inactive wave

      canvas.drawLine(
        Offset(x, centerY - waveHeight),
        Offset(x, centerY + waveHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CleanWavePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}


