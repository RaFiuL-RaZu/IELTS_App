import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:justtsham/featcher/view/HomeScreen/home_screen.dart';
import 'package:justtsham/featcher/view/SkillsPracticeScreen/skills_practice_screen.dart';
import 'package:justtsham/featcher/view/MockExamScreen/mock_exam_screen.dart';
import 'package:justtsham/featcher/view/ResourcesScreen/ielts_resources_screen.dart';
import 'package:justtsham/featcher/view/ProfileScreen/candidate_profile_screen.dart';

class NavBarController extends GetxController {
  var selectedIndex = 0.obs;
  var skillPracticeIndex = 0.obs; // 0: Speaking, 1: Listening, 2: Reading, 3: Writing

  void changeTab(int index, {int skillIndex = -1}) {
    selectedIndex.value = index;
    if (skillIndex >= 0) {
      skillPracticeIndex.value = skillIndex;
    }
  }

  void openSkill(int skillIndex) {
    skillPracticeIndex.value = skillIndex;
    selectedIndex.value = 1; // Switch to 4 Skills tab
  }

  final List<Widget> pages = [
    const HomeScreen(),
    const SkillsPracticeScreen(),
    const MockExamScreen(),
    const IeltsResourcesScreen(),
    const CandidateProfileScreen(),
  ];

  final List<String> label = [
    "Dashboard",
    "4 Skills",
    "Mock Exam",
    "Resources",
    "Profile",
  ];
}
