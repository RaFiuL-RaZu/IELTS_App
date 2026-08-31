import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controller/AuthController/navber_controller.dart';

class NavBarScreen extends StatelessWidget {
  const NavBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NavBarController navController = Get.put(NavBarController());

    final List<Map<String, dynamic>> navItems = [
      {
        "label": "Dashboard",
        "icon": Icons.dashboard_rounded,
      },
      {
        "label": "4 Skills",
        "icon": Icons.school_rounded,
      },
      {
        "label": "Mock Exam",
        "icon": Icons.timer_rounded,
      },
      {
        "label": "Resources",
        "icon": Icons.auto_stories_rounded,
      },
      {
        "label": "Profile",
        "icon": Icons.person_rounded,
      },
    ];

    return Obx(() => Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: navController.pages[navController.selectedIndex.value],
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          bottom: 18.h,
        ),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        height: 60.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(navItems.length, (index) {
            final isSelected = navController.selectedIndex.value == index;
            final item = navItems[index];

            if (isSelected) {
              // Active Pill: Original Teal theme with solid icon + text label
              return GestureDetector(
                onTap: () => navController.changeTab(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00695C), // Original IELTS Teal
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00695C).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item["icon"] as IconData,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        item["label"] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              // Inactive Item: Circular button with original app icons
              return GestureDetector(
                onTap: () => navController.changeTab(index),
                child: Container(
                  height: 42.h,
                  width: 42.h,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      item["icon"] as IconData,
                      color: const Color(0xFF64748B),
                      size: 20,
                    ),
                  ),
                ),
              );
            }
          }),
        ),
      ),
    ));
  }
}