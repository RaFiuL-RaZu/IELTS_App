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
import '../../../core/services/ielts_gemini_ai_service.dart';
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
    if (!isRecording.value && !isProcessing.value) return;
    _isActionInProgress = true;

    // ⚡ Cancel timer and switch state IMMEDIATELY so the clock and UI stop with zero lag!
    _timer?.cancel();
    _timer = null;
    isRecording.value = false;
    isProcessing.value = true;
    final capturedSeconds = seconds.value;

    // 🛡️ Safety Watchdog: Never allow UI to stay stuck in isProcessing for more than 2 seconds
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (isProcessing.value) {
        debugPrint("⚡ Safety watchdog triggered: forcefully releasing isProcessing");
        isProcessing.value = false;
        isRecorded.value = true;
        _isActionInProgress = false;
      }
    });

    try {
      String? stopPath;
      try {
        stopPath = await recorderController.stop().timeout(
          const Duration(seconds: 2),
          onTimeout: () {
            debugPrint("recorderController.stop timed out; using recordedPath");
            return recordedPath;
          },
        );
      } catch (e) {
        debugPrint("recorderController.stop exception: $e");
      }

      if (stopPath != null && stopPath.isNotEmpty) {
        recordedPath = stopPath;
      }

      try {
        await playerController.stopPlayer();
      } catch (_) {}

      if (recordedPath != null && recordedPath!.isNotEmpty) {
        try {
          // ⚡ Instant non-blocking player preparation with safety timeout
          await playerController.preparePlayer(
            path: recordedPath!,
            volume: 1.0,
            shouldExtractWaveform: false,
          ).timeout(const Duration(seconds: 2));
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
      }

      // ⚡ ALWAYS mark as recorded so the user immediately sees Play, Delete & Submit buttons!
      isRecorded.value = true;
    } catch (e) {
      debugPrint("Stop error: $e");
      isRecorded.value = true;
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
    final effectivePath = recordedPath ?? selectedAudioFile?.path;

    if (effectivePath == null || seconds.value < 5) {
      Get.snackbar(
        "Insufficient Speaking Duration ⚠️",
        "Please record at least 15 to 30 seconds of speech so Gemini AI can analyze your pronunciation, fluency, and vocabulary.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEA580C),
        colorText: Colors.white,
      );
      return;
    }

    isLoading(true);

    // Show Gemini AI Evaluator Loading Dialog
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFC8A96B).withOpacity(0.14),
                  shape: BoxShape.circle,
                ),
                child: const SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Color(0xFF8A6B32),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "🤖 Gemini AI Speaking Examiner",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 8),
              const Text(
                "Listening to your audio recording...\nEvaluating Fluency, Pronunciation, Grammar & Vocabulary.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B), height: 1.45),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      final aiResult = await IeltsGeminiAiService.evaluateSpeakingAudio(
        audioPath: effectivePath,
        cueCardTopic: cueCardTitle ?? category ?? "IELTS Speaking Part 2",
        spokenSeconds: seconds.value,
      );

      if (Get.isDialogOpen == true) {
        Get.back();
      }

      if (Get.isRegistered<IeltsProgressController>()) {
        final ctrl = IeltsProgressController.to;
        ctrl.speakingTaskDone.value = true;
        ctrl.speakingBand.value = aiResult.overallBand;
        ctrl.addTestResult(
          skill: "Speaking",
          testName: cueCardTitle ?? category ?? "Speaking Cue Card Practice",
          score: (aiResult.overallBand * 4).round(),
          totalQuestions: 36,
          bandScore: aiResult.overallBand,
        );
        ctrl.saveToLocalStorage();
      }

      _showSpeakingAiResultSheet(aiResult, cueCardTitle ?? category ?? "Speaking Cue Card");

    } catch (e, s) {
      if (Get.isDialogOpen == true) Get.back();
      debugPrint("Practice save local error: $e");
    } finally {
      isLoading(false);
    }
  }

  void _showSpeakingAiResultSheet(IeltsSpeakingAiResult aiResult, String title) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.86,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                children: [
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC8A96B).withOpacity(0.14),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.auto_awesome, color: Color(0xFF8A6B32), size: 14),
                              SizedBox(width: 6),
                              Text(
                                "Evaluated by Gemini 3.6 Flash AI",
                                style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: Color(0xFF8A6B32)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              aiResult.overallBand.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 46,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF8A6B32),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "/ 9.0 Band",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                        Text(
                          aiResult.overallBand >= 7.5
                              ? "Excellent Speaking Fluency! 🌟"
                              : "Good Attempt! Review pronunciation & vocabulary tips below. 🚀",
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF4B5563)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 4 Criteria Breakdown
                  const Text("IELTS Speaking Criteria Breakdown", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
                  const SizedBox(height: 12),
                  _buildSpeakingCriterion("Fluency & Coherence (FC)", aiResult.fluencyCoherence, "Flow & Speech Continuity"),
                  _buildSpeakingCriterion("Lexical Resource (LR)", aiResult.lexicalResource, "Vocabulary & Collocations"),
                  _buildSpeakingCriterion("Grammatical Range (GRA)", aiResult.grammarAccuracy, "Sentence Structures & Tenses"),
                  _buildSpeakingCriterion("Pronunciation (PR)", aiResult.pronunciation, "Clarity & Intonation"),

                  const SizedBox(height: 18),

                  // Examiner Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC8A96B).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFC8A96B).withOpacity(0.25)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.psychology_rounded, color: Color(0xFF8A6B32), size: 20),
                            SizedBox(width: 8),
                            Text("Examiner Audio Evaluation", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF8A6B32))),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          aiResult.examinerFeedback,
                          style: const TextStyle(fontSize: 12.5, height: 1.45, color: Color(0xFF1E293B)),
                        ),
                        if (aiResult.transcript.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            "Transcribed Snippet: \"${aiResult.transcript}\"",
                            style: const TextStyle(fontSize: 11.5, fontStyle: FontStyle.italic, color: Color(0xFF64748B)),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Pronunciation observations
                  if (aiResult.pronunciationTips.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.record_voice_over_rounded, color: Color(0xFFD97706), size: 20),
                              SizedBox(width: 8),
                              Text("Pronunciation & Intonation Observations", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFFB45309))),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...aiResult.pronunciationTips.map((p) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("• ", style: TextStyle(color: Color(0xFFD97706), fontWeight: FontWeight.bold)),
                                Expanded(child: Text(p, style: const TextStyle(fontSize: 12, height: 1.4, color: Color(0xFF78350F)))),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],

                  // Vocabulary upgrades
                  if (aiResult.vocabularyUpgrades.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFBBF7D0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.auto_awesome, color: Color(0xFF16A34A), size: 20),
                              SizedBox(width: 8),
                              Text("Band 8.5+ Idiomatic Upgrades", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF15803D))),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...aiResult.vocabularyUpgrades.map((v) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("• ", style: TextStyle(color: Color(0xFF16A34A), fontWeight: FontWeight.bold)),
                                Expanded(child: Text(v, style: const TextStyle(fontSize: 12, height: 1.4, color: Color(0xFF14532D)))),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Save & Update Button
                  GestureDetector(
                    onTap: () {
                      Get.back(); // close sheet
                      Get.back(); // return to previous screen
                      Get.snackbar(
                        "AI Speaking Band Saved! 🎤",
                        "Band ${aiResult.overallBand.toStringAsFixed(1)} saved to your dashboard & progress analytics!",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: const Color(0xFF8A6B32),
                        colorText: Colors.white,
                        duration: const Duration(seconds: 3),
                      );
                    },
                    child: Container(
                      height: 48,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC8A96B),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFC8A96B).withOpacity(0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "Save AI Score & Update Dashboard",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildSpeakingCriterion(String name, double band, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFC8A96B).withOpacity(0.16),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "Band ${band.toStringAsFixed(1)}",
              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: Color(0xFF8A6B32)),
            ),
          ),
        ],
      ),
    );
  }
}