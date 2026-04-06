

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HomeController extends GetxController{

  final ValueNotifier<bool> isPlaying = ValueNotifier(false);

  void togglePlay() {
    isPlaying.value = !isPlaying.value;
  }

  void dispose() {
    isPlaying.dispose();
  }

  RxInt selectedIndex = (-1).obs;

  void selectItem(int index) {
    if (selectedIndex.value == index) {
      selectedIndex.value = -1;
    } else {
      selectedIndex.value = index;
    }
  }

  List<String> items = [
    "All",
    "Commercial",
    "Animation",
    "Narration",
  ];
}