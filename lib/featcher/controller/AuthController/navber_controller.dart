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
    selectedIndex.value = index;
  }

  final List<Widget> pages = [
    const HomeScreen(),
    const ScriptScreen(),
    const AuditionScreen(),
    const CommunityScreen(),
    const SettingScreen(),
  ];

  final List<String> label = [
    "Dashboard",
    "4 Skills",
    "Mock Exam",
    "Resources",
    "Analytics",
  ];
}
