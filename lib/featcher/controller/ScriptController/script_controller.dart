

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ScriptController extends GetxController{

  RxInt selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  RxInt selectedTab = (-1).obs;

  void selectItem(int index) {
    if (selectedTab.value == index) {
      selectedTab.value = -1;
    } else {
      selectedTab.value = index;
    }
  }

  List<String> items = [
    "All",
    "Commercial",
    "Animation",
    "Narration",
  ];
  }