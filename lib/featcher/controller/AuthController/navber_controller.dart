import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/constant/prefs_helper.dart';
import 'package:justtsham/featcher/view/AuditionScreen/audition_screen.dart';
import 'package:justtsham/featcher/view/CummunityScreen/community_screen.dart';
import 'package:justtsham/featcher/view/ScriptScreen/script_screen.dart';
import 'package:justtsham/featcher/view/SettingScreen/setting_screen.dart';

import '../../view/HomeScreen/home_screen.dart';
import '../../view/authentication/Login_screen.dart';

class NavBarController extends GetxController {
  var selectedIndex = 0.obs;

  void changeTab(int index) {
    if (index != 0 && PrefsHelper.token.isEmpty) {
      _showLoginDialog();
      return;
    }
    selectedIndex.value = index;
  }

  void _showLoginDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text("Login Required"),
        content: const Text("Please login first to access this feature."),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.to(() => LoginScreen());
            },
            child: const Text("Login"),
          ),
        ],
      ),
    );
  }

  final List<Widget> pages = [
    HomeScreen(),
    ScriptScreen(),
    AuditionScreen(),
    CommunityScreen(),
    SettingScreen(),
  ];

  final List<String> label = [
    "Home",
    "Scripts",
    "Tracking",
    "Community",
    "Settings",
  ];
}
