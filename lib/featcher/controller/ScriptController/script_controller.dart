

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ScriptController extends GetxController{

  RxInt selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }


  RxInt selectedTab = 0.obs;

  void selectItem(int index) {
    selectedTab.value = index;
  }
  RxInt selectedTime = 0.obs;

  void selectTimeItem(int index) {
    selectedTime.value = index;
  }


  List<String> items = [
    "All",
    "E-Learning",
    "Character",
    "Narration",
    "Video Game",
    "Animation",
    "Commercial",
    "Sports",
  ];

  List<String> timeList = [
    "15 sec",
    "30 sec",
    "45 sec",
  ];

  RxBool isDropdownOpen = false.obs;

  List<String> categories = [
    "All",
    "E-Learning",
    "Character",
    "Narration",
    "Video Game",
    "Animation",
    "Commercial",
    "Sports",
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
    "Energetic",
    "Dramatic",
    "Conversational",
    "Authoritative",
    "Quirky",
  ];

  RxString selectedTone = "".obs;

  void toggleToneDropdown() {
    isToneDropdownOpen.value = !isToneDropdownOpen.value;
  }

  void selectTone(String value) {
    selectedTone.value = value;
    isToneDropdownOpen.value = false;
  }
  }