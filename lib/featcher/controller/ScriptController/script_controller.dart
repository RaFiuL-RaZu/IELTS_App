

import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:justtsham/core/constant/prefs_helper.dart';
import 'package:justtsham/core/data/ielts_data.dart';
import 'package:justtsham/core/services/api_services.dart';
import 'package:justtsham/core/utils/app_urls.dart';
import 'package:justtsham/featcher/model/ScriptModel/script_model.dart';

class ScriptController extends GetxController{

  static ScriptController get instance=>Get.put(ScriptController());

  var expandedIndex = (-1).obs;
  RxInt activeSkillTab = 0.obs; // 0: Speaking, 1: Listening, 2: Reading, 3: Writing

  void toggleExpand(int index) {
    if (expandedIndex.value == index) {
      expandedIndex.value = -1;
    } else {
      expandedIndex.value = index;
    }
  }

  RxList<ScriptModel> filteredScriptList = <ScriptModel>[].obs;
  TextEditingController searchController = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    filteredScriptList.value = scriptList;
  }


  void searchScripts(String query) {
    String selectedCategory = items[selectedTab.value];

    List<ScriptModel> tempList = scriptList;

    if (selectedCategory != "All") {
      tempList = tempList.where((script) {
        return script.category
            ?.toLowerCase()
            .trim() ==
            selectedCategory.toLowerCase().trim();
      }).toList();
    }

    if (query.isNotEmpty) {
      tempList = tempList.where((script) {
        return (script.title ?? "")
            .toLowerCase()
            .contains(query.toLowerCase()) ||
            (script.category ?? "")
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            (script.content ?? "")
                .toLowerCase()
                .contains(query.toLowerCase());
      }).toList();
    }

    filteredScriptList.value = tempList;
  }
  void filterScriptsByCategory(int index) {
    selectedTab.value = index;

    searchScripts(searchController.text);
  }

  RxInt selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }


  RxInt selectedTab = 0.obs;

  void selectItem(int index) {
    selectedTab.value = index;
  }
  RxInt selectedSecond = 0.obs;
  RxString selectedTime = "15 sec".obs;

  void selectTimeItem(int index) {
    selectedSecond.value = index;
    selectedTime.value = timeList[index];
  }


  List<String> timeList = [
    "15 sec",
    "30 sec",
    "45 sec",
    "1 minute",
  ];

  List<String> items = [
    "All",
    "Technology & AI",
    "Work & Study",
    "Environment & Nature",
    "Travel & Culture",
    "People & Society",
    "Events & Experiences",
  ];

  RxBool isDropdownOpen = false.obs;

  List<String> categories = [
    "Technology & AI",
    "Work & Study",
    "Environment & Nature",
    "Travel & Culture",
    "People & Society",
    "Events & Experiences",
  ];

  RxString selectedCategory = "".obs;

  void toggleDropdown() {
    isDropdownOpen.value = !isDropdownOpen.value;
  }

  void selectCategory(String value) {
    selectedCategory.value = value;
    isDropdownOpen.value = false;
  }

  RxBool isToneDropdownOpen = false.obs;

  List<String> toneList = [
    "Formal / Academic",
    "Conversational",
    "Descriptive",
    "Analytical",
    "Persuasive",
  ];

  RxString selectedTone = "".obs;

  void toggleToneDropdown() {
    isToneDropdownOpen.value = !isToneDropdownOpen.value;
  }

  void selectTone(String value) {
    selectedTone.value = value;
    isToneDropdownOpen.value = false;
  }
  RxBool isLoading=false.obs;

  RxList<ScriptModel> scriptList=<ScriptModel>[].obs;

  void _loadDefaultIeltsCueCards() {
    final localList = IeltsData.cueCards.map((cue) {
      final bullets = cue.bulletPoints.map((b) => "• $b").join("\n");
      final part3 = cue.part3Questions.isNotEmpty
          ? "\n\nPart 3 Discussion Questions:\n" +
              cue.part3Questions.map((q) => "Q: $q").join("\n")
          : "";
      final vocab = cue.band8Vocabulary.isNotEmpty
          ? "\n\nBand 8+ Vocabulary:\n" + cue.band8Vocabulary.join(", ")
          : "";

      final fullContent =
          "Prompt Points:\n$bullets\n\nBand 8.5 Model Answer:\n${cue.sampleAnswer}$part3$vocab";

      return ScriptModel(
        id: cue.id,
        title: cue.title,
        category: cue.topicCategory,
        content: fullContent,
        createdAt: DateTime.now(),
      );
    }).toList();

    scriptList.value = localList;
    filteredScriptList.value = localList;
  }

  Future<void> getScript() async {
    _loadDefaultIeltsCueCards();
    isLoading(false);
  }






  var script = "".obs;
  Future<void> createScript() async {
    isLoading(true);
    await Future.delayed(const Duration(milliseconds: 300));

    final cat = selectedCategory.value.isNotEmpty ? selectedCategory.value : "Technology & AI";
    final tone = selectedTone.value.isNotEmpty ? selectedTone.value : "Band 8.0 Fluent";
    final dur = selectedTime.value.isNotEmpty ? selectedTime.value : "2 Min";

    script.value = "Describe a significant experience with $cat.\n\n"
        "You should say:\n"
        "• What this was and when it happened\n"
        "• Who was involved with you\n"
        "• What key steps were taken\n"
        "• And explain why this experience made a lasting impact on your perspective ($tone style, target duration: $dur).";

    isLoading(false);
  }
}