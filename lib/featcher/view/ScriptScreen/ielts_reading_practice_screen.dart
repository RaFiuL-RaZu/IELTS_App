import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/services/ielts_local_storage_service.dart';

class IeltsReadingPracticeScreen extends StatefulWidget {
  final String passageTitle;
  final String passageText;
  final String difficulty;

  const IeltsReadingPracticeScreen({
    super.key,
    required this.passageTitle,
    required this.passageText,
    required this.difficulty,
  });

  @override
  State<IeltsReadingPracticeScreen> createState() => _IeltsReadingPracticeScreenState();
}

class _IeltsReadingPracticeScreenState extends State<IeltsReadingPracticeScreen> {
  int _secondsRemaining = 1200; // 20 mins
  Timer? _timer;
  bool _isTimerRunning = true;
  final Map<int, String> _userAnswers = {};
  bool _isSubmitted = false;

  final List<Map<String, dynamic>> _readingQuestions = [
    {
      "id": 1,
      "type": "True / False / Not Given",
      "question": "1. Photovoltaic cell efficiency has improved by more than 35% over the past two decades.",
      "options": ["TRUE", "FALSE", "NOT GIVEN"],
      "correct": "TRUE",
      "explanation": "Paragraph 2 states that solid-state advancements enabled an efficiency increase from 18% to over 53%.",
    },
    {
      "id": 2,
      "type": "True / False / Not Given",
      "question": "2. European municipalities are universally transitioning to 100% solar grids by 2030.",
      "options": ["TRUE", "FALSE", "NOT GIVEN"],
      "correct": "FALSE",
      "explanation": "Paragraph 4 explains that several Eastern European cities still face severe funding deficits preventing full transition.",
    },
    {
      "id": 3,
      "type": "Paragraph Heading Matching",
      "question": "3. What is the central theme of Paragraph B?",
      "options": ["Grid Integration Barriers", "Battery Chemistry Advances", "Economic Feasibility", "Government Subsidies"],
      "correct": "Battery Chemistry Advances",
      "explanation": "Paragraph B specifically discusses lithium-iron-phosphate and solid-state electrode breakthroughs.",
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsRemaining > 0 && _isTimerRunning) {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF111827), size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Academic Reading Arena",
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timer & Passage Info Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E5F5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.timer_outlined, size: 18, color: Color(0xFF6A1B9A)),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        _formatTime(_secondsRemaining),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF6A1B9A),
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E5F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.difficulty,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6A1B9A),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Reading Passage Card
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    offset: const Offset(0, 3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.passageTitle,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    widget.passageText,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.55,
                      color: Color(0xFF374151),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            const Text(
              "Questions 1-3: Comprehension Check",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
              ),
            ),
            SizedBox(height: 10.h),

            // Questions
            ..._readingQuestions.map((q) {
              final qId = q["id"] as int;
              final selectedOpt = _userAnswers[qId];
              final isCorrect = selectedOpt == q["correct"];

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _isSubmitted
                        ? (isCorrect ? Colors.green : Colors.red)
                        : const Color(0xFFE5E7EB),
                    width: _isSubmitted ? 1.5 : 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        q["type"] as String,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF4B5563)),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      q["question"] as String,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF111827)),
                    ),
                    SizedBox(height: 10.h),
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
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: isChosen ? const Color(0xFFF3E5F5) : const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isChosen ? const Color(0xFF6A1B9A) : const Color(0xFFE5E7EB),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isChosen ? Icons.radio_button_checked : Icons.radio_button_off,
                                size: 18,
                                color: isChosen ? const Color(0xFF6A1B9A) : Colors.grey.shade400,
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  opt,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isChosen ? FontWeight.w700 : FontWeight.w500,
                                    color: isChosen ? const Color(0xFF4A148C) : const Color(0xFF374151),
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
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isCorrect ? Colors.green.shade800 : Colors.red.shade800,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),

            SizedBox(height: 10.h),

            // Submit Button
            GestureDetector(
              onTap: () {
                setState(() {
                  _isSubmitted = !_isSubmitted;
                });
                if (_isSubmitted) {
                  int correctCount = 0;
                  for (final q in _readingQuestions) {
                    if (_userAnswers[q["id"]] == q["correct"]) {
                      correctCount++;
                    }
                  }
                  final double band = correctCount == 3 ? 8.0 : (correctCount == 2 ? 7.0 : 6.0);
                  if (Get.isRegistered<IeltsProgressController>()) {
                    IeltsProgressController.to.addTestResult(
                      skill: "Reading",
                      testName: "Reading: ${widget.passageTitle}",
                      score: correctCount,
                      totalQuestions: _readingQuestions.length,
                      bandScore: band,
                    );
                  }
                  Get.snackbar(
                    "Reading Evaluated! 📖",
                    "Score: $correctCount / ${_readingQuestions.length} • Band $band saved to dashboard!",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: const Color(0xFF4A148C),
                    colorText: Colors.white,
                  );
                }
              },
              child: Container(
                height: 48.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF6A1B9A),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6A1B9A).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _isSubmitted ? "Reset & Re-read" : "Submit Reading Answers",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
