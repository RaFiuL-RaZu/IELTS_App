import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/constant/prefs_helper.dart';
import 'package:justtsham/core/services/api_services.dart';
import 'package:justtsham/core/utils/app_urls.dart';
import 'package:justtsham/featcher/model/CommunityModel/community_model.dart';
import 'package:waveform_flutter/waveform_flutter.dart';

class SaveAuditionController extends GetxController {

  static SaveAuditionController get instance=>Get.put(SaveAuditionController());


  var expandedIndex = (-1).obs;

  void toggleExpand(int index) {
    if (expandedIndex.value == index) {
      expandedIndex.value = -1;
    } else {
      expandedIndex.value = index;
    }
  }

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
  // Recording state
  var isRecording = false.obs;

  // Timer
  var seconds = 0.obs;
  Timer? timer;

  // Mic stream
  late Stream<Amplitude> micStream;

  @override
  void onInit() {
    super.onInit();
  }

  /// Start Recording
  void startRecording() {
    isRecording.value = true;
    seconds.value = 0;

    // 🔥 important: new stream each time
    micStream = createRandomAmplitudeStream();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      seconds.value++;
    });
  }

  /// Stop Recording
  void stopRecording() {
    isRecording.value = false;
    timer?.cancel();
  }

  /// Toggle
  void toggleRecording() {
    if (isRecording.value) {
      stopRecording();
    } else {
      startRecording();
    }
  }

  /// Format time
  String get formattedTime {
    final minutes = (seconds.value ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds.value % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }
  RxBool isLoading=false.obs;

  WeeklyModel weeklyModel = WeeklyModel(
    id: "weekly_ielts_1",
    title: "Describe an environmental initiative in your community",
    content: "You should say:\n- What the initiative was\n- Who organized it\n- What actions were taken\n- And explain why this initiative was important for your local community.",
    category: "Environment & Nature",
    difficulty: "Band 7.5 - 8.5",
    duration: "02:00",
    isWeeklyScript: true,
    isPracticed: false,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    weeklyScriptExpiryDate: DateTime.now().add(const Duration(days: 7)),
  );

  Future<void> getCommunity() async {
    isLoading(false);
  }




  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}