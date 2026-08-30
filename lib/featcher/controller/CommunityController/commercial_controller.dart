import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:justtsham/featcher/controller/AuthController/navber_controller.dart';
import 'package:justtsham/featcher/controller/CommunityController/community_controller.dart';
import 'package:justtsham/featcher/controller/ScriptController/script_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/constant/prefs_helper.dart';
import '../../../core/services/api_services.dart';
import '../../../core/utils/app_urls.dart';

class CommercialController extends GetxController {
  final recorderController = RecorderController();
  late PlayerController playerController;

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
    _setupPlayerListeners();
    debugPrint("Commercial Controller Initialized");
  }

  void _setupPlayerListeners() {
    playerController.onCurrentDurationChanged.listen((duration) {
      currentPosition.value = duration;
    });
    playerController.onPlayerStateChanged.listen((state) {
      playerState.value = state;
    });
  }

  @override
  void onClose() async {
    try {
      if (playerController.playerState == PlayerState.playing) {
        await playerController.stopPlayer();
      }
    } catch (_) {}

    try {
      await playerController.pausePlayer();
    } catch (_) {}

    try {
    playerController.dispose();
    } catch (e) {
      debugPrint("Player dispose ignored: $e");
    }

    try {
      recorderController.dispose();
    } catch (e) {
      debugPrint("Recorder dispose ignored: $e");
    }

    super.onClose();
  }

  Future<void> startRecording() async {
    if (_isRequestingPermission || isRecording.value) return;

    _isRequestingPermission = true;

    PermissionStatus status;
    try {
      status = await Permission.microphone.request();
    } finally {
      _isRequestingPermission = false;
    }

    if (!status.isGranted) {
      debugPrint("Permission denied: $status");
      // On iOS, after first denial status is 'denied' (not permanentlyDenied)
      // because iOS never re-prompts — user must go to Settings.
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

      if (recordedPath == null) return;

      try {
        await playerController.stopPlayer();
      } catch (_) {}

      await playerController.preparePlayer(path: recordedPath!);

      totalDuration.value = await playerController.getDuration();
      playerState.value = playerController.playerState;

      isRecorded.value = true;
    } catch (e) {
      debugPrint("Stop error: $e");
    } finally {
      isRecording.value = false;
      _timer?.cancel();
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
    isUploadedAudio.value = false;
    selectedAudioFile = null;
    audioFileName.value = "";

    currentPosition.value = 0;
    totalDuration.value = 0;

    playerState.value = PlayerState.stopped;

    playerController.stopPlayer();

    seconds.value = 0;

    _timer?.cancel();
    _timer = null;
  }


  Future<void> playPause() async {
    try {
      if (playerController.playerState == PlayerState.playing) {
        await playerController.pausePlayer();
      } else {
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



  Future<void> practiceScript({required String id, required String title}) async {
    isLoading(true);

    try {

      await Future.delayed(const Duration(milliseconds: 300));
      if (title == "script") {
        Get.until((route) => route.isFirst);
        Get.find<NavBarController>().changeTab(1);
        ScriptController.instance.getScript();
      } else {
        Get.back();
        CommunityController.instance.getCommunity();
      }
      Get.snackbar(
        "Response Recorded! 🎙️",
        "Your IELTS response has been saved locally.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.teal.shade800,
        colorText: Colors.white,
      );
    } catch (e, s) {
      debugPrint("Practice script local error: $e");
    } finally {
      isLoading(false);
    }
  }
}