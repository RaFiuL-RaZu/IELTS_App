import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/constant/other_helper.dart';
import 'package:justtsham/core/constant/prefs_helper.dart';
import 'package:justtsham/core/utils/app_colors.dart';
import 'package:justtsham/core/utils/app_icons.dart';
import 'package:justtsham/core/utils/app_urls.dart';
import 'package:justtsham/core/widgets/common_text.dart';
import 'package:justtsham/featcher/controller/CommunityController/community_controller.dart';
import 'package:justtsham/featcher/controller/HomeController/home_controller.dart';
import 'package:justtsham/featcher/model/HomeModel/audition_model.dart';
import 'package:justtsham/featcher/model/HomeModel/comment_model.dart';
import 'package:justtsham/featcher/view/HomeScreen/waveForme.dart';
import '../../../core/widgets/commom_image.dart';
import '../CummunityScreen/commercial_screen.dart';
import 'notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 3 && hour < 11) {
      return "Morning";
    } else if (hour >= 11 && hour < 15) {
      return "Noon";
    } else if (hour >= 15 && hour < 21) {
      return "Evening";
    } else {
      return "Night";
    }
  }
  final HomeController controller = Get.put(HomeController());
  final CommunityController boxController = Get.put(CommunityController());
  @override
  void initState() {
    controller.getHomeData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      boxController.getCommunity();
    });
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
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: CommonText(
                  title: "Your voice.Your vault",
                  fSize: 16,
                  fWeight: FontWeight.w500,
                  color: AppColor.secondary,
                ),
                subtitle: CommonText(
                  title: PrefsHelper.myName,
                  fSize: 22,
                  fWeight: FontWeight.w700,
                  color: AppColor.primary,
                ),
                trailing: GestureDetector(
                  onTap: () {
                    Get.to(() => NotificationScreen());
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
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        AppIcons.notify,
                        height: 20.h,
                        width: 17.w,
                        color: AppColor.primary,
                      ),
                    ),
                  ),
                ),
              ),
              Obx(() {
                if (boxController.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColor.primary),
                  );
                }

                final data = boxController.weeklyModel;

                if (data == null) {
                return const SizedBox();
                }
                return Column(
                  children: [
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
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                              title: data.content ?? "",
                              fSize: 16,
                              maxLine: 3,
                              overflow: TextOverflow.ellipsis,
                              fWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                            SizedBox(height: 10.h),
                            CommonText(
                              title: data.weeklyScriptExpiryDate != null
                                  ? "${OtherHelper.formatDate(data.weeklyScriptExpiryDate.toString())} remaining"
                                  : "No date available",
                              fSize: 12,
                              fWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                            SizedBox(height: 10.h),
                            GestureDetector(
                              onTap: () {
                                if (data.isPracticed == false) {
                                  Get.to(() => CommercialScreen(
                                    title: data.content.toString(),
                                    id: data.id.toString(),
                                    page: 'community',
                                  ));
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
                                        title: data.isPracticed == true
                                            ? "Completed"
                                            : "Submit Your Take",
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
                    ),
                  ],
                );
              }),
              SizedBox(height: 20.h),
              Obx(
                () => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(controller.items.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () {
                            controller.selectItem(index);
                            debugPrint(
                              "selected index: ${controller.selectedIndex.value}",
                            );
                            debugPrint(
                              "selected item: ${controller.items[index]}",
                            );
                          },
                          child: voiceBox(
                            title: controller.items[index],
                            isSelected: controller.selectedIndex.value == index,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColor.primary),
                  );
                }

                if (controller.filteredList.isEmpty) {
                  return Center(child: CommonText(title: "No Audition Found"));
                }
                return ListView.builder(
                  itemCount: controller.filteredList.length,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    AuditionModel list = controller.filteredList[index];
                    return Container(
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
                              contentPadding: const EdgeInsets.only(left: 0, right: 0),
                              leading: GestureDetector(
                                onTap: () {
                                  Get.dialog(
                                    AlertDialog(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      title: const Text("User Options"),
                                      content: const Text(
                                        "Are you not interested in this person's posts?",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Get.back(),
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Get.back();

                                            Get.dialog(
                                              AlertDialog(
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                title: const Text("Block User"),
                                                content: const Text(
                                                  "Blocking this user will prevent you from seeing their posts and interactions.",
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Get.back(),
                                                    child: const Text("Cancel"),
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Colors.red,
                                                    ),
                                                    onPressed: () {
                                                      Get.back();
                                                      controller.userBlock(id: list.creator.id);
                                                    },
                                                    child: const Text(
                                                      "Block",
                                                      style: TextStyle(color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            "Block User",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: ClipOval(
                                  child: (list.creator.profileImage.isNotEmpty ?? false)
                                      ? CommonImage(
                                    imageSrc: AppUrl.imageUrl + list.creator.profileImage,
                                    imageType: ImageType.network,
                                    height: 50,
                                    width: 50,
                                    fill: BoxFit.cover,
                                  )
                                      : Container(
                                    height: 50,
                                    width: 50,
                                    color: Colors.grey.shade300,
                                    child: const Icon(
                                      Icons.person,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              title: CommonText(
                                title: list.creator.fullName,
                                fSize: 14,
                                fWeight: FontWeight.w700,
                                color: AppColor.primary,
                              ),
                              subtitle: CommonText(
                                title: OtherHelper.timeAgo(
                                  list.creator.createdAt.toString(),
                                ),
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
                                        title: list.category,
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
                                    elevation: 4,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(
                                      minWidth: 24,
                                      minHeight: 24,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    icon: const Icon(
                                      Icons.more_vert,
                                      size: 20,
                                    ),
                                    onSelected: (value) async {
                                      if (value == "not_interested") {
                                        await controller.notInterested(id: list.id);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem<String>(
                                        value: "not_interested",
                                        padding: EdgeInsets.zero,
                                        child: SizedBox(
                                          width: 150,
                                          height: 30,
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 16),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Report",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
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

                            final text = list.title.toString();

                            final textSpan = TextSpan(
                              text: text,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            );

                            final tp = TextPainter(
                              text: textSpan,
                              maxLines: 3,
                              textDirection: TextDirection.ltr,
                            );

                            tp.layout(maxWidth: Get.width); // or specific width

                            final isOverflowing = tp.didExceedMaxLines;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonText(
                                  title: text,
                                  fSize: 14,
                                  maxLine: isExpanded ? null : 3,
                                  overflow: isExpanded
                                      ? TextOverflow.visible
                                      : TextOverflow.ellipsis,
                                  fWeight: FontWeight.w600,
                                  color: AppColor.primary,
                                ),

                                const SizedBox(height: 4),

                                if (isOverflowing)
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
                              child: Row(
                                children: [
                                  list.auditionFile.isEmpty
                                      ? Container(
                                          height: 39.h,
                                          width: 39.h,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
                                        )
                                      : Obx(() {
                                          final url = AppUrl.imageUrl + list.auditionFile;
                                          final isPlaying = controller.currentUrl.value == url && controller.isPlaying.value;
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

                                  Expanded(
                                    child: Obx(() {
                                      final url =
                                          AppUrl.imageUrl + list.auditionFile;
                                      final showProgress =
                                          controller.currentUrl.value == url;
                                      return Padding(
                                        padding:  EdgeInsets.symmetric(vertical: 5),
                                        child: WaveformProgress(
                                          progress: showProgress
                                              ? controller.progress.value
                                              : 0.0,
                                        ),
                                      );
                                    }),
                                  ),

                                  SizedBox(width: 10.w),

                                  Obx(() {
                                    final url =
                                        AppUrl.imageUrl + list.auditionFile;
                                    final isCurrentPlaying =
                                        controller.currentUrl.value == url;
                                    if (!isCurrentPlaying) {
                                      return const SizedBox.shrink();
                                    }
                                    return Text(
                                      controller.formatTime(
                                        controller.position.value,
                                      ),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColor.secondary,
                                      ),
                                    );
                                  }),
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
                                        Obx(() {
                                          return GestureDetector(
                                            onTap: () {

                                              controller.createLike(
                                                id: list.id,
                                              );
                                            },
                                            child: list.isLiked.value
                                                ? Image.asset(
                                                    AppIcons.love,
                                                    height: 20.h,
                                                    width: 20.w,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.asset(
                                                    AppIcons.fakeLove,
                                                    height: 20.h,
                                                    width: 20.w,
                                                    fit: BoxFit.cover,
                                                  ),
                                          );
                                        }),
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
                                          onTap: () {
                                            if (controller
                                                    .activeCommentIndex
                                                    .value ==
                                                index) {
                                              controller.hideCommentField();
                                            } else {
                                              controller.getComment(
                                                id: list.id,
                                              );
                                              controller.toggleCommentField(
                                                index,
                                              );
                                            }
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
                                GestureDetector(
                                  onTap: () async {
                                    if (!list.isFavorite.value) {
                                      final success = await controller.addBookMark(id: list.id);
                                      if (success) {
                                        list.isFavorite.value = true;
                                      }
                                    } else {
                                      final success = await controller.deleteBookMark(id: list.id);
                                      if (success) {
                                        list.isFavorite.value = false;
                                      }
                                    }
                                  },
                                  child: Obx(() {
                                    return list.isFavorite.value ? Image.asset(
                                      AppIcons.fullBook,
                                      color: Color(0xFF7741C1),
                                      height: 21,
                                      width: 16,
                                    ) : Image.asset(
                                      AppIcons.fav,
                                      height: 21,
                                      width: 16,
                                    );
                                  }),
                                )
                              ],
                            ),

                            Obx(() {
                              if (controller.activeCommentIndex.value !=
                                  index) {
                                return const SizedBox.shrink();
                              }
                              if (controller.isComment.value) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              return Column(
                                children: [
                                  SizedBox(height: 10),

                                  ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: controller.commentList.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, i) {
                                      CommentModel comment =
                                          controller.commentList[i];

                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipOval(
                                            child:  CommonImage(
                                              imageSrc:
                                                  AppUrl.imageUrl +
                                                  (comment.user?.profileImage ??
                                                      ""),
                                              imageType: ImageType.network,
                                              height: 30,
                                              width: 30,
                                              fill: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(width: 5),

                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  CommonText(
                                                    title: comment.user?.fullName ?? "",
                                                    fSize: 14,
                                                    fWeight: FontWeight.w500,
                                                  ),

                                                  GestureDetector(
                                                    onTapDown: (details) async {
                                                      final value = await showMenu<String>(
                                                        context: context,
                                                        color: Colors.white,
                                                        position: RelativeRect.fromLTRB(
                                                          details.globalPosition.dx,
                                                          details.globalPosition.dy,
                                                          details.globalPosition.dx,
                                                          0,
                                                        ),
                                                        items: const [
                                                          PopupMenuItem<String>(
                                                            value: "delete",
                                                            height: 24,
                                                            padding: EdgeInsets.zero,
                                                            child: Align(
                                                              alignment: Alignment.centerLeft,
                                                              child: Padding(
                                                                padding: EdgeInsets.only(left: 12),
                                                                child: Text(
                                                                  "Delete",
                                                                  style: TextStyle(
                                                                    fontSize: 13,
                                                                    fontWeight: FontWeight.w500,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );

                                                      if (value == "delete") {
                                                        final success = await controller.deleteComment(
                                                          id: comment.id.toString(),
                                                        );

                                                        if (success) {
                                                          controller.commentList.removeWhere(
                                                                (item) => item.id == comment.id,
                                                          );
                                                        }
                                                      }
                                                    },
                                                    child: CommonText(
                                                      title: comment.comment ?? "",
                                                      fSize: 14,
                                                      fWeight: FontWeight.w400,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),

                                  SizedBox(height: 10),

                                  Obx(() {
                                    return AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      child:
                                          controller.activeCommentIndex.value ==
                                              index
                                          ? Padding(
                                              key: const ValueKey("comment"),
                                              padding: EdgeInsets.only(
                                                top: 12.h,
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: TextField(
                                                      controller: controller
                                                          .commentController,
                                                      decoration: InputDecoration(
                                                        prefixIcon: Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                12.0,
                                                              ),
                                                          child: Image.asset(
                                                            AppIcons.message,
                                                            height: 10.h,
                                                            width: 10.w,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        suffixIcon: Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                12.0,
                                                              ),
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              controller
                                                                  .postComment(
                                                                    id: list.id,
                                                                  );
                                                            },
                                                            child: Image.asset(
                                                              AppIcons.send,
                                                              height: 10.h,
                                                              width: 10.w,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        hintText:
                                                            "Write your comment...",
                                                        hintStyle:
                                                            const TextStyle(
                                                              fontSize: 14,
                                                              color: Color(
                                                                0xFF99A1AF,
                                                              ),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    12,
                                                                  ),
                                                              borderSide:
                                                                  const BorderSide(
                                                                    color: Color(
                                                                      0xFFBFBFBF,
                                                                    ),
                                                                  ),
                                                            ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    12,
                                                                  ),
                                                              borderSide:
                                                                  const BorderSide(
                                                                    color: Color(
                                                                      0xFF6C4DFF,
                                                                    ),
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
                                  }),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Container voiceBox({required String title, required bool isSelected}) {
    return Container(
      height: 34.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: isSelected
              ? [Color(0xFF180E27), Color(0xFF56397C)]
              : [Colors.white, Colors.white],
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
