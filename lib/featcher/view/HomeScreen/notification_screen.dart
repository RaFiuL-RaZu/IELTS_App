import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/services/ielts_local_storage_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      "title": "Speaking Practice Reminder",
      "body": "Practice today's Speaking Part 2 Cue Card: 'Artificial Intelligence in Education'. Record your answer and review Band 8+ vocabulary.",
      "time": "10 mins ago",
      "icon": Icons.mic_rounded,
      "color": Color(0xFF00695C),
      "bgColor": Color(0xFFE0F2F1),
      "isUnread": true,
    },
    {
      "title": "IELTS Reading Tip",
      "body": "Remember to skim the topic sentence of each paragraph first before attempting 'List of Headings' questions.",
      "time": "2 hours ago",
      "icon": Icons.menu_book_rounded,
      "color": Color(0xFF0D9488),
      "bgColor": Color(0xFFF0FDFA),
      "isUnread": true,
    },
    {
      "title": "Listening Mock Test Available",
      "body": "A new Section 2 dialogue listening test is ready in your Practice tab with auto-scoring and audio transcript.",
      "time": "Yesterday",
      "icon": Icons.headset_rounded,
      "color": Color(0xFF0284C7),
      "bgColor": Color(0xFFE0F2FE),
      "isUnread": false,
    },
    {
      "title": "Writing Task 2 Model Strategy",
      "body": "Check out the new Band 9 opinion essay analysis on 'Renewable Energy Production' in the Resources section.",
      "time": "2 days ago",
      "icon": Icons.edit_note_rounded,
      "color": Color(0xFFE65100),
      "bgColor": Color(0xFFFFF3E0),
      "isUnread": false,
    },
    {
      "title": "Study Goal Milestone",
      "body": "Keep up the daily consistency! Your upcoming exam preparation schedule is on track.",
      "time": "3 days ago",
      "icon": Icons.emoji_events_rounded,
      "color": Color(0xFF7C3AED),
      "bgColor": Color(0xFFEDE9FE),
      "isUnread": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final progressCtrl = Get.find<IeltsProgressController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 65.h,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Study Notifications",
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all_rounded, color: Color(0xFF00695C), size: 22),
            tooltip: "Mark all as read",
            onPressed: () {
              setState(() {
                for (var n in _notifications) {
                  n["isUnread"] = false;
                }
              });
              Get.snackbar(
                "Updated",
                "All notifications marked as read",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: const Color(0xFF004D40),
                colorText: Colors.white,
                duration: const Duration(seconds: 2),
                margin: const EdgeInsets.all(16),
              );
            },
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 80.h,
                    width: 80.h,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.notifications_off_outlined, color: Color(0xFF94A3B8), size: 36),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  const Text(
                    "No Notifications",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF334155)),
                  ),
                  SizedBox(height: 6.h),
                  const Text(
                    "You're all caught up with your IELTS prep schedule!",
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            )
          : ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              itemCount: _notifications.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final item = _notifications[index];
                final isUnread = item["isUnread"] as bool;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      item["isUnread"] = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isUnread ? const Color(0xFF00695C).withOpacity(0.3) : const Color(0xFFE2E8F0),
                        width: isUnread ? 1.5 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isUnread
                              ? const Color(0xFF00695C).withOpacity(0.06)
                              : Colors.black.withOpacity(0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 44.h,
                          width: 44.h,
                          decoration: BoxDecoration(
                            color: item["bgColor"] as Color,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Icon(
                              item["icon"] as IconData,
                              color: item["color"] as Color,
                              size: 22.sp,
                            ),
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item["title"] as String,
                                      style: TextStyle(
                                        fontSize: 14.5.sp,
                                        fontWeight: isUnread ? FontWeight.w800 : FontWeight.w700,
                                        color: const Color(0xFF0F172A),
                                      ),
                                    ),
                                  ),
                                  if (isUnread)
                                    Container(
                                      height: 8,
                                      width: 8,
                                      margin: EdgeInsets.only(left: 6.w),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF00695C),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                item["body"] as String,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF475569),
                                  height: 1.35,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                item["time"] as String,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
