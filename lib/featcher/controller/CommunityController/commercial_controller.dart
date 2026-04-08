import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CommercialController extends GetxController {
  final recorderController = RecorderController();
  var isRecorded = false.obs;
  late final PlayerController playerController;

  var isRecording = false.obs;
  var seconds = 0.obs;
  var currentPosition = 0.obs;
  var totalDuration = 0.obs;

  Timer? _timer;
  String? recordedPath;

  bool _isRequestingPermission = false;
  var playerState = PlayerState.stopped.obs;

  @override
  onInit() {
    debugPrint("Commercial Controller Initialized");
    playerController.onCurrentDurationChanged.listen((duration) {
      currentPosition.value = duration;
    });

    playerController.onCurrentDurationChanged.listen((duration) {
      totalDuration.value = duration;
    });

    playerController.onPlayerStateChanged.listen((state) {
      playerState.value = state;
    });

    super.onInit();

  }

  @override
  void onClose() {
    _timer?.cancel();
    debugPrint("Commercial Controller Closed");
    recorderController.dispose();
    super.onClose();
  }

  Future<void> startRecording() async {
    if (_isRequestingPermission || isRecording.value) return;

    _isRequestingPermission = true;

    final status = await Permission.microphone.request();

    _isRequestingPermission = false;

    if (!status.isGranted) {
      print("Permission denied");
      return;
    }

    try {
      await recorderController.record();

      isRecording.value = true;
      seconds.value = 0;

      _startTimer();

      print("Recording started");
    } catch (e) {
      debugPrint("Start error: $e");
    }
  }

  Future<void> stopRecording() async {
    if (!isRecording.value) return;

    try {
      recordedPath = await recorderController.stop();

      if (recordedPath == null) {
        throw Exception("Recording not found");
      }

      debugPrint("RECORDED PATH: $recordedPath");

      await playerController.preparePlayer(
        path: recordedPath!,
      );

      isRecorded.value = true;

    } catch (e) {
      print("Stop error: $e");
    } finally {
      isRecording.value = false;
      _timer?.cancel();
      _timer = null;
    }
  }

  Future<void> toggleRecording() async {
    if (_isRequestingPermission) return;

    if (isRecording.value) {
      await stopRecording();
    } else {
      await startRecording();
    }
  }

  Future<void> playPause() async {
    if (playerController.playerState == PlayerState.playing) {
      await playerController.pausePlayer();
      playerState.value = PlayerState.paused;
    } else {
      await playerController.startPlayer();
      playerState.value = PlayerState.playing;
    }
  }

  String remainingTime() {
    final remaining = totalDuration.value - currentPosition.value;

    if (remaining < 0) return "00:00";

    final min = (remaining ~/ 60000).toString().padLeft(2, '0');
    final sec = ((remaining % 60000) ~/ 1000).toString().padLeft(2, '0');

    return "$min:$sec";
  }
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      seconds.value++;
    });
  }

  String get formattedTime {
    final min = (seconds.value ~/ 60).toString().padLeft(2, '0');
    final sec = (seconds.value % 60).toString().padLeft(2, '0');
    return "$min:$sec";
  }
}
