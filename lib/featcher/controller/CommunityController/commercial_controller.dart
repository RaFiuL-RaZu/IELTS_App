import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:permission_handler/permission_handler.dart';

class CommercialController extends GetxController {
  final recorderController = RecorderController();
  late final PlayerController playerController;

  var isRecorded = false.obs;
  var isRecording = false.obs;

  var playerState = PlayerState.stopped.obs;

  var seconds = 0.obs;
  var currentPosition = 0.obs;
  var totalDuration = 0.obs;

  Timer? _timer;
  String? recordedPath;

  bool _isRequestingPermission = false;

  @override
  void onInit() {
    super.onInit();

    playerController = PlayerController();

    debugPrint("Commercial Controller Initialized");

    playerController.onCurrentDurationChanged.listen((duration) {
      currentPosition.value = duration;
    });

    playerController.onCurrentDurationChanged.listen((duration) {
      currentPosition.value = duration;
    });

    playerController.onPlayerStateChanged.listen((state) {
      debugPrint("PLAYER STATE: $state");
      playerState.value = state;
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    recorderController.dispose();
    playerController.dispose();
    debugPrint("Commercial Controller Closed");
    super.onClose();
  }


  Future<void> startRecording() async {
    if (_isRequestingPermission || isRecording.value) return;

    _isRequestingPermission = true;

    final status = await Permission.microphone.request();

    _isRequestingPermission = false;

    if (!status.isGranted) {
      debugPrint("Permission denied");
      return;
    }

    try {
      await recorderController.record();

      isRecording.value = true;
      seconds.value = 0;

      _startTimer();

      debugPrint("Recording started");
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

      totalDuration.value = await playerController.getDuration();

      playerState.value = playerController.playerState;

      isRecorded.value = true;
    } catch (e) {
      debugPrint("Stop error: $e");
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

  void deleteRecording() {
    recordedPath = null;
    isRecorded.value = false;

    currentPosition.value = 0;
    totalDuration.value = 0;

    playerState.value = PlayerState.stopped;

    playerController.stopPlayer();

    seconds.value = 0;

    _timer?.cancel();
    _timer = null;
  }


  Future<void> playPause() async {
    if (playerController.playerState == PlayerState.playing) {
      await playerController.pausePlayer();
    } else {
      await playerController.startPlayer();
    }
  }


  String remainingTime() {
    final remaining = totalDuration.value - currentPosition.value;

    if (remaining < 0) return "00:00";

    final min = (remaining ~/ 60000).toString().padLeft(2, '0');
    final sec =
    ((remaining % 60000) ~/ 1000).toString().padLeft(2, '0');

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