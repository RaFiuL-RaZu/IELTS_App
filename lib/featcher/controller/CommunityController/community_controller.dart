import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:waveform_flutter/waveform_flutter.dart';

class CommunityController extends GetxController {

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

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}