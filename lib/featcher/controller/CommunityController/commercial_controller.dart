import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:justtsham/featcher/controller/CommunityController/community_controller.dart';
import 'package:justtsham/featcher/controller/ScriptController/script_controller.dart';
import 'package:justtsham/featcher/view/ScriptScreen/script_screen.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/constant/prefs_helper.dart';
import '../../../core/services/api_services.dart';
import '../../../core/utils/app_urls.dart';

class CommercialController extends GetxController {
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
    debugPrint("pickAudioFile called");


    var status = await Permission.storage.status;
    if (!status.isGranted) {
      debugPrint("Storage permission not granted, requesting...");
      status = await Permission.storage.request();
    }

    if (!status.isGranted) {
      var mediaStatus = await Permission.audio.status;
      if (!mediaStatus.isGranted) {
        debugPrint("Audio permission not granted, requesting...");
        mediaStatus = await Permission.audio.request();
      }
    }

    debugPrint("Storage permission: ${status.isGranted}");

    isLoading.value = true;

    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav', 'm4a', 'ogg'],
        withData: true,
      );

      debugPrint("FilePicker result: ${result != null ? 'has result' : 'null'}");

      if (result != null && result.files.single.path != null) {
        selectedAudioFile = File(result.files.single.path!);
        audioFileName.value = result.files.single.name;
        debugPrint("Selected file: ${audioFileName.value}");

        await _prepareUploadedAudio(result.files.single.path!);
      } else if (result == null) {
        debugPrint("User cancelled file picker");
      } else {
        debugPrint("No file path in result");
      }
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

      if (recordedPath == null) return;

      await playerController.stopPlayer(); // 🔥 ADD THIS

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

      debugPrint("saveAudition :");
      Map<String, String> header = {
        "token": PrefsHelper.token,
        "Content-Type":"application/json"
      };
      debugPrint("saveAudition2 :");

      Map<String,dynamic> body = {
        'data':jsonEncode({
          "scriptId": id,
        })
      };
      debugPrint("saveAudition3 :");

      final response = await ApiService.audioFileUpload(
        url: AppUrl.practiceScript,
        body: body,
        header: header,
        method: "POST",
        filePath: selectedAudioFile != null && selectedAudioFile!.path.isNotEmpty
            ? selectedAudioFile!.path
            : recordedPath ?? "",
        fileField: "practiceScriptFile",
      );
      debugPrint("saveAudition4 :");
      debugPrint("Response: ${response.body}");
      debugPrint("Response: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Response: ${response.body}");
        debugPrint("Response: ${response.statusCode}");
        if(title=="script"){
          Get.offAll(()=>ScriptScreen());
          ScriptController.instance.getScript();
        }else{
          Get.back();
          CommunityController.instance.getCommunity();

        }
      }
    } catch (e, s) {
      debugPrint("Error: $e");
      debugPrint("StackTrace: $s");
    } finally {
      isLoading(false);
    }
  }
}