import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CommunityController extends GetxController{
  final ValueNotifier<bool> isPlaying = ValueNotifier(false);

  void togglePlay() {
    isPlaying.value = !isPlaying.value;
  }

  void dispose() {
    isPlaying.dispose();
  }
}