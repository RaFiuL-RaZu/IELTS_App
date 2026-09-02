import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/services/ielts_local_storage_service.dart';

class IeltsListeningPracticeScreen extends StatefulWidget {
  final String sectionTitle;
  final String sectionNumber;
  final String audioSnippet;
  final String? audioUrl;

  const IeltsListeningPracticeScreen({
    super.key,
    required this.sectionTitle,
    required this.sectionNumber,
    required this.audioSnippet,
    this.audioUrl,
  });

  @override
  State<IeltsListeningPracticeScreen> createState() => _IeltsListeningPracticeScreenState();
}

class _IeltsListeningPracticeScreenState extends State<IeltsListeningPracticeScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = const Duration(minutes: 2, seconds: 30);
  Timer? _ticker;
  double _playbackSpeed = 1.0;

  final Map<int, String> _userAnswers = {};
  bool _isSubmitted = false;

  late final List<Map<String, dynamic>> _questions;

  @override
  void initState() {
    super.initState();
    _questions = _getQuestionsForSection(widget.sectionNumber, widget.sectionTitle);
    _initTts();
  }

  List<Map<String, dynamic>> _getQuestionsForSection(String sectionNumber, String title) {
    if (sectionNumber.contains("2") || title.contains("Campus") || title.contains("Library") || title.contains("Orientation")) {
      return [
        {
          "id": 1,
          "question": "1. Where is the postgraduate multimedia computer lab located?",
          "options": ["On the ground floor to the left", "On the second floor east wing", "In the basement archive", "Next to the central cafeteria"],
          "correct": "On the ground floor to the left",
          "explanation": "The orientation guide clearly states: 'On your left is the multimedia lab, while research cubicles are located on the second floor.'",
        },
        {
          "id": 2,
          "question": "2. What is the maximum borrowing limit for research journals?",
          "options": ["Up to 5 print journals for 14 days", "10 reference textbooks for 7 days", "Unlimited digital papers only", "2 journals for overnight loan only"],
          "correct": "Up to 5 print journals for 14 days",
          "explanation": "The library regulations allow enrolled postgraduates up to 5 print journals for a 14-day checkout period.",
        },
        {
          "id": 3,
          "question": "3. What is required to reserve private study carrels?",
          "options": ["Advance student ID registration online", "Payment of a daily £5 booking deposit", "Written recommendation from course tutor", "Reservation must be made 1 month prior"],
          "correct": "Advance student ID registration online",
          "explanation": "Carrel pods are booked through the student portal using your university credentials.",
        },
      ];
    } else if (sectionNumber.contains("3") || title.contains("Climate") || title.contains("Tutorial") || title.contains("Research")) {
      return [
        {
          "id": 1,
          "question": "1. What is the student's primary concern regarding the satellite dataset?",
          "options": ["Resolution inconsistencies across equatorial zones", "Excessive file sizes for university servers", "Corrupted thermal sensor timestamps", "Lack of historical data prior to 1990"],
          "correct": "Resolution inconsistencies across equatorial zones",
          "explanation": "The student mentions equatorial cloud cover creating spatial resolution variances in the raw telemetry data.",
        },
        {
          "id": 2,
          "question": "2. Which statistical methodology did Professor Jenkins recommend?",
          "options": ["Monte Carlo simulation algorithms", "Standard linear regression models", "Qualitative interview surveying", "Manual chart plotting"],
          "correct": "Monte Carlo simulation algorithms",
          "explanation": "Professor Jenkins advises using stochastic Monte Carlo algorithms to model climate variance accurately.",
        },
        {
          "id": 3,
          "question": "3. What is the agreed deadline for submitting the revised research draft?",
          "options": ["Next Thursday before 5:00 PM", "End of the current semester", "Tomorrow morning at 9:00 AM", "In two weeks after field tests"],
          "correct": "Next Thursday before 5:00 PM",
          "explanation": "The tutor confirms: 'Please email me the updated methodology draft by Thursday 5:00 PM.'",
        },
      ];
    } else if (sectionNumber.contains("4") || title.contains("Cognitive") || title.contains("Language") || title.contains("Lecture")) {
      return [
        {
          "id": 1,
          "question": "1. Which cerebral region is primarily responsible for syntactic parsing?",
          "options": ["Broca's area in the frontal lobe", "Wernicke's area in the temporal lobe", "The primary visual cortex", "The cerebellum balance center"],
          "correct": "Broca's area in the frontal lobe",
          "explanation": "The lecturer highlights Broca's area for grammar, syntax, and complex structural sentence generation.",
        },
        {
          "id": 2,
          "question": "2. What neurobiological phenomenon occurs when memory pathways are repeatedly stimulated?",
          "options": ["Long-term potentiation", "Synaptic deterioration", "Cerebral atrophy", "Axon fragmentation"],
          "correct": "Long-term potentiation",
          "explanation": "Repetitive activation induces long-term potentiation (LTP), strengthening synaptic connections.",
        },
        {
          "id": 3,
          "question": "3. According to recent fMRI studies, bilingual individuals demonstrate:",
          "options": ["Enhanced executive cognitive control", "Delayed auditory reaction times", "Decreased gray matter density", "Impaired visual recognition"],
          "correct": "Enhanced executive cognitive control",
          "explanation": "Managing two linguistic systems activates superior dorsolateral prefrontal cortex executive functions.",
        },
      ];
    } else {
      // Default / Section 1: Cambridge 18 Student Accommodation
      return [
        {
          "id": 1,
          "question": "1. What type of accommodation is requested?",
          "options": ["Single ensuite room", "Double studio apartment", "Shared flat", "Family suite"],
          "correct": "Single ensuite room",
          "explanation": "In the dialogue, the caller specifies needing a single ensuite room close to the research campus.",
        },
        {
          "id": 2,
          "question": "2. Expected arrival date:",
          "options": ["Friday, 14th October", "Monday, 17th October", "Wednesday, 19th October", "Saturday, 22nd October"],
          "correct": "Friday, 14th October",
          "explanation": "The booking assistant confirms arrival on Friday, October 14th before 6:00 PM.",
        },
        {
          "id": 3,
          "question": "3. Method of payment selected:",
          "options": ["Credit Card", "Bank Transfer", "Cash on Arrival", "University Voucher"],
          "correct": "Credit Card",
          "explanation": "A credit card deposit of 10% is processed immediately over the phone.",
        },
      ];
    }
  }

  Future<void> _initTts() async {
    try {
      await _flutterTts.setLanguage("en-GB");
      await _flutterTts.setSpeechRate(0.48);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setVolume(1.0);

      _flutterTts.setCompletionHandler(() {
        if (mounted) {
          setState(() {
            _isPlaying = false;
            _position = Duration.zero;
          });
          _ticker?.cancel();
        }
      });

      _flutterTts.setErrorHandler((msg) {
        debugPrint("TTS error: $msg");
      });
    } catch (e) {
      debugPrint("TTS init error: $e");
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    try {
      _flutterTts.stop();
    } catch (_) {}
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      try {
        await _flutterTts.stop();
      } catch (_) {}
      _ticker?.cancel();
      setState(() {
        _isPlaying = false;
      });
    } else {
      setState(() {
        _isPlaying = true;
      });

      // Spoken Cambridge exam introduction + dialogue
      final textToSpeak = "You will hear ${widget.sectionNumber}. ${widget.sectionTitle}. "
          "First you have some time to look at questions one to three. "
          "${widget.audioSnippet}";

      try {
        await _flutterTts.setSpeechRate(0.48 * _playbackSpeed);
        await _flutterTts.speak(textToSpeak);
      } catch (e) {
        debugPrint("TTS speak error: $e");
      }

      _startTicker();
      Get.snackbar(
        "Audio Playing 🎧",
        "Listening to ${widget.sectionNumber} British English dialogue",
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF004D40),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    final intervalMs = (1000 / _playbackSpeed).round();
    _ticker = Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
      if (!mounted) return;
      setState(() {
        if (_position < _duration) {
          _position += const Duration(seconds: 1);
        } else {
          _isPlaying = false;
          _position = Duration.zero;
          timer.cancel();
        }
      });
    });
  }

  void _seekRelative(int seconds) {
    setState(() {
      final newSeconds = _position.inSeconds + seconds;
      if (newSeconds < 0) {
        _position = Duration.zero;
      } else if (newSeconds > _duration.inSeconds) {
        _position = _duration;
      } else {
        _position = Duration(seconds: newSeconds);
      }
    });
  }

  void _changeSpeed() {
    setState(() {
      if (_playbackSpeed == 1.0) {
        _playbackSpeed = 1.25;
      } else if (_playbackSpeed == 1.25) {
        _playbackSpeed = 1.5;
      } else {
        _playbackSpeed = 1.0;
      }
    });
    if (_isPlaying) {
      _flutterTts.setSpeechRate(0.48 * _playbackSpeed);
      _startTicker();
    }
    Get.snackbar(
      "Playback Speed",
      "Speed set to ${_playbackSpeed}x",
      snackPosition: SnackPosition.TOP,
      duration: const Duration(milliseconds: 900),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final progress = _duration.inMilliseconds > 0
        ? (_position.inMilliseconds / _duration.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 65.h,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 20),
          onPressed: () {
            _flutterTts.stop();
            Get.back();
          },
        ),
        title: Text(
          widget.sectionNumber,
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Audio Player Card
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [Color(0xFF193B57), Color(0xFF24537B), Color(0xFF2E6FA0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2E6FA0).withOpacity(0.28),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Text(
                              "🔊 AUDIBLE EXAM TRACK (EN-GB)",
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF90C1E5),
                                letterSpacing: 0.5,
                              ),
                            ),
                            if (_isPlaying) ...[
                              SizedBox(width: 6.w),
                              const SizedBox(
                                height: 8,
                                width: 8,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF90C1E5)),
                              ),
                            ],
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: _changeSpeed,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "${_playbackSpeed}x",
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    widget.sectionTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 14.h),

                  // Animated Audio Waveforms
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(24, (index) {
                      final active = (index / 24.0) <= progress;
                      final heights = [10, 16, 24, 18, 12, 28, 22, 14, 20, 26, 16, 30, 24, 18, 12, 22, 28, 14, 20, 16, 24, 18, 12, 10];
                      final h = heights[index % heights.length].toDouble();

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        height: _isPlaying ? (h * (0.6 + (index % 3) * 0.2)) : h * 0.5,
                        width: 3.5,
                        decoration: BoxDecoration(
                          color: active ? const Color(0xFF90C1E5) : Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),

                  SizedBox(height: 14.h),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                      trackHeight: 4,
                      activeTrackColor: const Color(0xFF90C1E5),
                      inactiveTrackColor: Colors.white.withOpacity(0.25),
                      thumbColor: Colors.white,
                    ),
                    child: Slider(
                      value: progress,
                      onChanged: (v) {
                        setState(() {
                          final targetSec = (v * _duration.inSeconds).toInt();
                          _position = Duration(seconds: targetSec);
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(_position),
                          style: const TextStyle(color: Color(0xFFB0D5EE), fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          _formatDuration(_duration),
                          style: const TextStyle(color: Color(0xFFB0D5EE), fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => _seekRelative(-10),
                        icon: const Icon(Icons.replay_10_rounded, color: Colors.white, size: 28),
                      ),
                      SizedBox(width: 16.w),
                      GestureDetector(
                        onTap: _togglePlayPause,
                        child: Container(
                          height: 56.h,
                          width: 56.h,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            color: const Color(0xFF2E6FA0),
                            size: 34,
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      IconButton(
                        onPressed: () => _seekRelative(10),
                        icon: const Icon(Icons.forward_10_rounded, color: Colors.white, size: 28),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 22.h),

            // Tapescript Collapsible
            ExpansionTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: Color(0xFFE2E8F0))),
              collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: Color(0xFFE2E8F0))),
              backgroundColor: Colors.white,
              collapsedBackgroundColor: Colors.white,
              initiallyExpanded: true,
              title: const Text(
                "📜 Spoken Audio Transcript / Tapescript",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF2E6FA0)),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Text(
                    widget.audioSnippet,
                    style: const TextStyle(fontSize: 13.5, height: 1.5, color: Color(0xFF334155)),
                  ),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // Question Sheet Header
            const Text(
              "Section Questions (Listen & Answer):",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
            SizedBox(height: 14.h),

            // Questions List
            ..._questions.map((q) {
              final qId = q["id"] as int;
              final selectedOpt = _userAnswers[qId];
              final isCorrect = selectedOpt == q["correct"];

              return Container(
                margin: EdgeInsets.only(bottom: 16.h),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isSubmitted
                        ? (isCorrect ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F))
                        : const Color(0xFFE2E8F0),
                    width: _isSubmitted ? 1.5 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      q["question"],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    ...(q["options"] as List<String>).map((opt) {
                      final isChosen = selectedOpt == opt;
                      return GestureDetector(
                        onTap: _isSubmitted
                            ? null
                            : () {
                                setState(() {
                                  _userAnswers[qId] = opt;
                                });
                              },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: isChosen ? const Color(0xFF2E6FA0).withOpacity(0.12) : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isChosen ? const Color(0xFF2E6FA0) : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isChosen ? Icons.radio_button_checked : Icons.radio_button_off,
                                size: 18,
                                color: isChosen ? const Color(0xFF2E6FA0) : Colors.grey.shade400,
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  opt,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isChosen ? FontWeight.w700 : FontWeight.w500,
                                    color: isChosen ? const Color(0xFF193B57) : const Color(0xFF334155),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    if (_isSubmitted) ...[
                      SizedBox(height: 8.h),
                      Text(
                        "💡 ${q["explanation"]}",
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: isCorrect ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),

            SizedBox(height: 14.h),

            // Submit / Reset Button
            GestureDetector(
              onTap: () {
                setState(() {
                  _isSubmitted = !_isSubmitted;
                });
                if (_isSubmitted) {
                  int correctCount = 0;
                  for (final q in _questions) {
                    if (_userAnswers[q["id"]] == q["correct"]) {
                      correctCount++;
                    }
                  }
                  final double band = correctCount == 3 ? 8.5 : (correctCount == 2 ? 7.5 : 6.5);
                  if (Get.isRegistered<IeltsProgressController>()) {
                    final ctrl = IeltsProgressController.to;
                    ctrl.listeningTaskDone.value = true;
                    ctrl.listeningBand.value = band;
                    ctrl.addTestResult(
                      skill: "Listening",
                      testName: "${widget.sectionNumber}: ${widget.sectionTitle}",
                      score: correctCount,
                      totalQuestions: _questions.length,
                      bandScore: band,
                      isMockExam: widget.sectionTitle.toLowerCase().contains("mock") || widget.sectionNumber.toLowerCase().contains("mock"),
                    );
                    ctrl.saveToLocalStorage();
                  }
                  Get.snackbar(
                    "Listening Test Evaluated! 🎯",
                    "Score: $correctCount / ${_questions.length} • Band $band saved & Dashboard checklist updated!",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: const Color(0xFF193B57),
                    colorText: Colors.white,
                  );
                }
              },
              child: Container(
                height: 48.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E6FA0),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2E6FA0).withOpacity(0.28),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _isSubmitted ? "Reset & Retry Test" : "Submit Answer Sheet",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
