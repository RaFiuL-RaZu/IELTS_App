import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/utils/app_colors.dart';

import '../../controller/AuthController/navber_controller.dart';

class NavBarScreen extends StatefulWidget {
  const NavBarScreen({super.key});

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final NavBarController navController = Get.put(NavBarController());

    return Obx(
          () => Scaffold(
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: navController.pages[navController.selectedIndex.value],
        ),

        bottomNavigationBar: Container(
          height: 146,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(40),
                blurRadius: 12,
                offset: const Offset(5, -2),
              ),
            ],
          ),
          child: ClipRRect(
            clipBehavior: Clip.antiAlias,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              elevation: 0,
              currentIndex: navController.selectedIndex.value,
              onTap: navController.changeTab,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedLabelStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColor.primary,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFFB8ABF6),
              ),
              selectedItemColor: AppColor.primary,selectedFontSize: 12,
              unselectedItemColor: Color(0xFFB8ABF6),
              type: BottomNavigationBarType.fixed,
              items: [
                _buildNavItem(
                  navController,
                  0,
                  'assets/icon/activeHome.png',
                  'assets/icon/home.png',
                ),
                _buildNavItem(
                  navController,
                  1,
                  'assets/icon/activeScript.png',
                  'assets/icon/script.png',
                ),
                _buildNavItem(
                  navController,
                  2,
                  'assets/icon/activeAudio.png',
                  'assets/icon/audioIcon.png',
                ),
                _buildNavItem(
                  navController,
                  3,
                  'assets/icon/activeprofile.png',
                  'assets/icon/profileIcon.png',
                ),
                _buildNavItem(
                  navController,
                  4,
                  'assets/icon/activeSet.png',
                  'assets/icon/setIcon.png',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      NavBarController navController,
      int index,
      String unselectedIcon,
      String selectedIcon,
      ) {
    bool isSelected = navController.selectedIndex.value == index;

    return BottomNavigationBarItem(
      label: "",

      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 1.0, end: isSelected ? 1.2 : 1.0),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: Image.asset(
                  isSelected ? selectedIcon : unselectedIcon,
                  width: 24,
                  height: 24,
                ),
              );
            },
          ),

     SizedBox(height: 6.h),

          Column(
            children: [
              Text(
                navController.label[index],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? AppColor.primary
                      : const Color(0xFFB8ABF6),
                ),
              ),

           SizedBox(height: 8.h),

              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 4,
                width: isSelected ? 20 : 0,
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}