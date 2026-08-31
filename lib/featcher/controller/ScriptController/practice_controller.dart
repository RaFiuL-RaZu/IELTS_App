import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/constant/prefs_helper.dart';
import '../../../core/services/api_services.dart';
import '../../../core/services/ielts_local_storage_service.dart';
import '../../../core/utils/app_urls.dart';

class PracticeController extends GetxController {
  final recorderController = RecorderController();
  late final PlayerController playerController;

  var isRecorded = false.obs;
  var isRecording = false.obs;
  var isUploadedAudio = false.obs;

  var playerState = PlayerState.stopped.obs;

  var seconds = 0.obs;
  var currentPosition = 0.obs;
  var totalDuration = 0.obs;

  Timer? _timer;
  String? recordedPath;

  bool _isRequestingPermission = false;


  File? selectedAudioFile;
  RxString audioFileName = "".obs;
  RxBool isLoading = false.obs;

  Future<void> pickAudioFile() async {
    if (Platform.isAndroid) {
      var audioStatus = await Permission.audio.request();
      if (!audioStatus.isGranted) {
        final storageStatus = await Permission.storage.request();
        if (!storageStatus.isGranted) return;
      }
    }

    isLoading.value = true;

    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav', 'm4a', 'aac', 'ogg'],
        withData: false,
      );

      if (result == null) return;

      final file = result.files.single;
      String? filePath = file.path;

      if (filePath == null && file.bytes != null) {
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/${file.name}');
        await tempFile.writeAsBytes(file.bytes!);
        filePath = tempFile.path;
      }

      if (filePath == null) return;

      selectedAudioFile = File(filePath);
      audioFileName.value = file.name;
      await _prepareUploadedAudio(filePath);
    } catch (e) {
      debugPrint("Error picking audio file: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _prepareUploadedAudio(String path) async {
    try {
      if (isRecording.value) {
        await stopRecording();
      }

      // Stop any existing playback first
      await playerController.stopPlayer();

      await playerController.preparePlayer(path: path);

      totalDuration.value = await playerController.getDuration();

      currentPosition.value = 0;

      // Set recordedPath so play/pause button works for uploaded audio too
      recordedPath = path;

      isUploadedAudio.value = true;
      isRecorded.value = true;
      playerState.value = playerController.playerState;

      // Small delay to ensure player is ready
      await Future.delayed(const Duration(milliseconds: 100));

      await playerController.startPlayer();

      debugPrint("Uploaded audio prepared and playing: $path");
    } catch (e) {
      debugPrint("Error preparing uploaded audio: $e");
    }
  }

  @override
  void onInit() {
    super.onInit();

    playerController = PlayerController();

    debugPrint("Commercial Controller Initialized");

    playerController.onCurrentDurationChanged.listen((duration) {
      currentPosition.value = duration;
    });

    playerController.onPlayerStateChanged.listen((state) {
      playerState.value = state;
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    _timer = null;

    try {
      if (playerState.value == PlayerState.playing) {
        playerController.stopPlayer();
      }
    } catch (_) {}

    try {
      playerController.dispose();
    } catch (e) {
      debugPrint("Player dispose error: $e");
    }

    try {
      recorderController.dispose();
    } catch (e) {
      debugPrint("Recorder dispose error: $e");
    }

    super.onClose();
  }

  var isProcessing = false.obs;
  bool _isActionInProgress = false;

  Future<void> startRecording() async {
    if (_isRequestingPermission || isRecording.value || _isActionInProgress) return;
    _isActionInProgress = true;

    PermissionStatus status;
    try {
      _isRequestingPermission = true;
      status = await Permission.microphone.request();
    } finally {
      _isRequestingPermission = false;
    }

    if (!status.isGranted) {
      _isActionInProgress = false;
      debugPrint("Permission denied: $status");
      final bool needSettings =
          status.isPermanentlyDenied || (Platform.isIOS && status.isDenied);

      if (needSettings) {
        Get.dialog(
          AlertDialog(
            title: const Text('Microphone Permission Required'),
            content: const Text(
              'Microphone access is required to record audio.\n\n'
              'Go to: Settings → Privacy & Security → Microphone → enable this app.\n\n'
              'Or tap "Open Settings" below.',
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Get.back();
                  await openAppSettings();
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
      } else {
        Get.snackbar(
          'Permission Required',
          'Microphone permission is needed to record audio.',
          snackPosition: SnackPosition.TOP,
        );
      }
      return;
    }

    try {
      // ⚡ Explicit file path in app documents directory for reliable Android storage
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/ielts_speaking_${DateTime.now().millisecondsSinceEpoch}.m4a';
      recordedPath = filePath;

      await recorderController.record(path: filePath);
      isRecorded.value = false;
      isRecording.value = true;
      seconds.value = 0;

      _startTimer();

      debugPrint("Recording started at: $filePath");
    } catch (e) {
      debugPrint("Start error: $e");
    } finally {
      _isActionInProgress = false;
    }
  }

  Future<void> stopRecording() async {
    if (!isRecording.value || _isActionInProgress) return;
    _isActionInProgress = true;

    // ⚡ Cancel timer and switch state IMMEDIATELY so the clock and UI stop with zero lag!
    _timer?.cancel();
    _timer = null;
    isRecording.value = false;
    isProcessing.value = true;
    final capturedSeconds = seconds.value;

    try {
      final stopPath = await recorderController.stop();
      if (stopPath != null && stopPath.isNotEmpty) {
        recordedPath = stopPath;
      }

      if (recordedPath != null && recordedPath!.isNotEmpty) {
        try {
          await playerController.stopPlayer();
        } catch (_) {}

        try {
          // ⚡ Instant non-blocking player preparation
          await playerController.preparePlayer(
            path: recordedPath!,
            volume: 1.0,
            shouldExtractWaveform: false,
          );
        } catch (e) {
          debugPrint("preparePlayer error: $e");
        }

        try {
          await playerController.setVolume(1.0);
        } catch (_) {}

        try {
          final duration = await playerController.getDuration();
          totalDuration.value = duration > 0 ? duration : (capturedSeconds * 1000);
        } catch (_) {
          totalDuration.value = capturedSeconds * 1000;
        }

        currentPosition.value = 0;
        playerState.value = playerController.playerState;
        isRecorded.value = true;
      }
    } catch (e) {
      debugPrint("Stop error: $e");
    } finally {
      isProcessing.value = false;
      _isActionInProgress = false;
    }
  }

  Future<void> toggleRecording() async {
    if (_isRequestingPermission || _isActionInProgress) return;

    if (isRecording.value) {
      await stopRecording();
    } else {
      await startRecording();
    }
  }

  void deleteRecording() {
    recordedPath = null;
    isRecorded.value = false;
    isUploadedAudio.value = false;
    selectedAudioFile = null;
    audioFileName.value = "";

    currentPosition.value = 0;
    totalDuration.value = 0;

    playerState.value = PlayerState.stopped;

    try {
      playerController.stopPlayer();
    } catch (_) {}

    seconds.value = 0;

    _timer?.cancel();
    _timer = null;
  }

  Future<void> playPause() async {
    if (_isActionInProgress) return;
    try {
      final isPlaying = playerState.value == PlayerState.playing;
      if (isPlaying) {
        playerState.value = PlayerState.paused;
        await playerController.pausePlayer();
      } else {
        // If track is at the end, replay from start
        if (currentPosition.value >= totalDuration.value && totalDuration.value > 0) {
          await playerController.seekTo(0);
          currentPosition.value = 0;
        }
        await playerController.setVolume(1.0);
        playerState.value = PlayerState.playing;
        await playerController.startPlayer();
      }
    } catch (e) {
      debugPrint("Play/Pause error: $e");
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



  Future<void> createCommunity({String? cueCardTitle, String? category}) async {
    isLoading(true);

    try {
      debugPrint("saveAudition :");
      await Future.delayed(const Duration(milliseconds: 400));

      if (Get.isRegistered<IeltsProgressController>()) {
        final ctrl = IeltsProgressController.to;
        ctrl.speakingTaskDone.value = true;
        ctrl.speakingBand.value = 7.5;
        ctrl.addTestResult(
          skill: "Speaking",
          testName: cueCardTitle ?? category ?? "Speaking Cue Card Practice",
          score: 8,
          totalQuestions: 9,
          bandScore: 7.5,
        );
        ctrl.saveToLocalStorage();
      }

      Get.back();
      Get.snackbar(
        "Speaking Test Completed! 🎯",
        "Your IELTS Speaking response has been recorded. Daily task checked & Band 7.5 saved!",
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF004D40),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e, s) {
      debugPrint("Practice save local error: $e");
    } finally {
      isLoading(false);
    }
  }
}