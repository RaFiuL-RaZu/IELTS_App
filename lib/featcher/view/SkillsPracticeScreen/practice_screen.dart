import 'dart:async';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_colors.dart';
import '../../controller/ScriptController/practice_controller.dart';

class PracticeScreen extends StatefulWidget {
  final String content;
  final String title;
  final String? cardTitle;

  const PracticeScreen({
    super.key,
    required this.content,
    required this.title,
    this.cardTitle,
  });

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  late final PracticeController controller;

  // 1-Min Preparation Timer
  int _prepSecondsRemaining = 60;
  bool _isPrepTimerRunning = false;
  Timer? _prepTimer;

  @override
  void initState() {
    super.initState();
    controller = Get.put(PracticeController());
  }

  @override
  void dispose() {
    _prepTimer?.cancel();
    super.dispose();
  }

  void _startPrepTimer() {
    if (_isPrepTimerRunning) {
      _prepTimer?.cancel();
      setState(() {
        _isPrepTimerRunning = false;
      });
    } else {
      setState(() {
        _isPrepTimerRunning = true;
        _prepSecondsRemaining = 60;
      });
      _prepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_prepSecondsRemaining > 0) {
          setState(() {
            _prepSecondsRemaining--;
          });
        } else {
          timer.cancel();
          setState(() {
            _isPrepTimerRunning = false;
          });
          Get.snackbar(
            "Prep Time Over! 🎤",
            "Your 1 minute preparation time is up. Tap the mic to record your 2-minute response!",
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color(0xFF00695C),
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0F172A), size: 20),
          onPressed: () => Get.back(),
        ),
        title: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 3.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFFE0F2F1),
              ),
              child: Text(
                widget.title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF00695C),
                  letterSpacing: 0.5,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            const Text(
              "IELTS Speaking Arena",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Top Section: Cue Card Prompt & 1-Min Prep
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cue Card Container
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(18.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.record_voice_over_rounded, color: Color(0xFF00695C), size: 20),
                                SizedBox(width: 8),
                                Text(
                                  "Candidate Cue Card",
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF00695C),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                "Part 2 • 2 Mins",
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 14.h),
                        Text(
                          widget.content,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1E293B),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 14.h),

                  // 1-Minute Prep Countdown Banner
                  GestureDetector(
                    onTap: _startPrepTimer,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _isPrepTimerRunning
                              ? [const Color(0xFFEA580C), const Color(0xFFF97316)]
                              : [const Color(0xFF00695C), const Color(0xFF00897B)],
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: (_isPrepTimerRunning ? const Color(0xFFEA580C) : const Color(0xFF00695C)).withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _isPrepTimerRunning ? Icons.timer_outlined : Icons.play_circle_outline_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                _isPrepTimerRunning
                                    ? "Prep Countdown: ${_prepSecondsRemaining}s"
                                    : "Start 1-Min Prep Countdown",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            _isPrepTimerRunning ? "Tap to Pause" : "Start",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Voice Studio (Recording & Instant Play/Pause Controls)
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 28.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(36),
                topRight: Radius.circular(36),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  offset: const Offset(0, -6),
                  blurRadius: 18,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Live Timer Display
                Obx(() {
                  final isRecorded = controller.isRecorded.value;
                  final displayTime = isRecorded
                      ? controller.remainingTime()
                      : controller.formattedTime;

                  return Text(
                    displayTime,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                      letterSpacing: 1.2,
                    ),
                  );
                }),

                SizedBox(height: 10.h),

                // Audio Waveform Visualization
                Obx(() {
                  if (controller.isRecording.value) {
                    return AudioWaveforms(
                      enableGesture: false,
                      size: Size(double.infinity, 36.h),
                      recorderController: controller.recorderController,
                      waveStyle: const WaveStyle(
                        waveColor: Color(0xFFEF4444),
                        showMiddleLine: false,
                        extendWaveform: true,
                        spacing: 4,
                        waveThickness: 3.5,
                      ),
                    );
                  } else if (controller.isRecorded.value) {
                    final current = controller.currentPosition.value;
                    final total = controller.totalDuration.value > 0
                        ? controller.totalDuration.value
                        : (controller.seconds.value * 1000);
                    final progress = (total > 0) ? (current / total).clamp(0.0, 1.0) : 0.0;
                    final isPlaying = controller.playerState.value == PlayerState.playing;

                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Animated Wave Bars & Status
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(24, (i) {
                              final heightFactor = (i % 4 == 0)
                                  ? 1.0
                                  : (i % 3 == 0)
                                      ? 0.7
                                      : (i % 2 == 0)
                                          ? 0.45
                                          : 0.3;
                              final isActive = (i / 24.0) <= progress;
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 2.w),
                                width: 3.5.w,
                                height: 22.h * (isPlaying ? (heightFactor * (0.6 + (i % 5) * 0.1)) : heightFactor),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? const Color(0xFF00695C)
                                      : const Color(0xFF94A3B8),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              );
                            }),
                          ),
                          SizedBox(height: 6.h),
                          // Scrubber & Timings
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 3.h,
                              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
                              overlayShape: RoundSliderOverlayShape(overlayRadius: 12.r),
                              activeTrackColor: const Color(0xFF00695C),
                              inactiveTrackColor: const Color(0xFFCBD5E1),
                              thumbColor: const Color(0xFF004D40),
                            ),
                            child: Slider(
                              value: current.toDouble().clamp(0.0, total.toDouble()),
                              min: 0.0,
                              max: total > 0 ? total.toDouble() : 1.0,
                              onChanged: (val) async {
                                await controller.playerController.seekTo(val.toInt());
                                controller.currentPosition.value = val.toInt();
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      height: 10.h,
                      margin: EdgeInsets.symmetric(horizontal: 40.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  }
                }),

                SizedBox(height: 20.h),

                // Instant Action Controls (Record / Play-Pause / Delete / Submit)
                Obx(() {
                  if (controller.isRecorded.value) {
                    // Recorded State: [Delete/Re-record] [Instant Play/Pause] [Submit Grade]
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Delete / Re-record
                        GestureDetector(
                          onTap: () => controller.deleteRecording(),
                          child: Container(
                            height: 52.h,
                            width: 52.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEE2E2),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFEF4444).withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444), size: 24),
                            ),
                          ),
                        ),

                        // Instant Play / Pause Center Button
                        GestureDetector(
                          onTap: () async {
                            await controller.playPause();
                          },
                          child: Container(
                            height: 76.h,
                            width: 76.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFF00695C),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF00695C).withOpacity(0.35),
                                  blurRadius: 14,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                controller.playerState.value == PlayerState.playing
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 42,
                              ),
                            ),
                          ),
                        ),

                        // Submit / Complete Speaking Test
                        GestureDetector(
                          onTap: () => controller.createCommunity(
                            cueCardTitle: widget.cardTitle ?? widget.title,
                            category: widget.title,
                          ),
                          child: Container(
                            height: 52.h,
                            width: 52.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0F2F1),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF00695C).withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(Icons.check_rounded, color: Color(0xFF00695C), size: 26),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    // Ready to Record / Active Recording State
                    final isRec = controller.isRecording.value;
                    final isProc = controller.isProcessing.value;

                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (isProc) return;
                            if (isRec) {
                              await controller.stopRecording();
                            } else {
                              await controller.startRecording();
                            }
                          },
                          child: Container(
                            height: 76.h,
                            width: 76.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isRec
                                  ? const Color(0xFFEF4444)
                                  : const Color(0xFF00695C),
                              boxShadow: [
                                BoxShadow(
                                  color: (isRec
                                          ? const Color(0xFFEF4444)
                                          : const Color(0xFF00695C))
                                      .withOpacity(0.35),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Center(
                              child: isProc
                                  ? const SizedBox(
                                      height: 28,
                                      width: 28,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                                    )
                                  : Icon(
                                      isRec ? Icons.stop_rounded : Icons.mic_rounded,
                                      color: Colors.white,
                                      size: 38,
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          isProc
                              ? "Finalizing audio response..."
                              : isRec
                                  ? "Recording in progress... (Tap to stop)"
                                  : "Tap mic to start speaking response",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isRec
                                ? const Color(0xFFEF4444)
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    );
                  }
                }),

                SizedBox(height: 14.h),

                // Upload Audio File Alternative
                GestureDetector(
                  onTap: () => controller.pickAudioFile(),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.upload_file_rounded, color: Color(0xFF475569), size: 18),
                        SizedBox(width: 6),
                        Text(
                          "Or upload audio file (.mp3, .m4a)",
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

