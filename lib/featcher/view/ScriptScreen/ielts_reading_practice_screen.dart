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

  late final List<Map<String, dynamic>> _readingQuestions;

  @override
  void initState() {
    super.initState();
    _readingQuestions = _getQuestionsForPassage(widget.passageTitle);
    _startTimer();
  }

  List<Map<String, dynamic>> _getQuestionsForPassage(String title) {
    if (title.contains("Cognitive") || title.contains("Neuroscience") || title.contains("Memory")) {
      return [
        {
          "id": 1,
          "type": "True / False / Not Given",
          "question": "1. Synaptic plasticity decreases when spaced repetition techniques are applied.",
          "options": ["TRUE", "FALSE", "NOT GIVEN"],
          "correct": "FALSE",
          "explanation": "The passage confirms that spaced repetition actively strengthens synaptic plasticity and long-term potentiation.",
        },
        {
          "id": 2,
          "type": "True / False / Not Given",
          "question": "2. Myelin sheath deposition is enhanced around neural pathways that are frequently retrieved.",
          "options": ["TRUE", "FALSE", "NOT GIVEN"],
          "correct": "TRUE",
          "explanation": "Neurological imaging reveals thickened myelin layers around frequently activated recall circuits.",
        },
        {
          "id": 3,
          "type": "Multiple Choice",
          "question": "3. Which state is identified as essential for neural memory consolidation?",
          "options": ["Slow-wave sleep cycles", "Continuous cramming sessions", "High caffeine intake", "Ambient background audio"],
          "correct": "Slow-wave sleep cycles",
          "explanation": "Deep sleep cycles facilitate synaptic pruning and transfer information from hippocampus to neocortex.",
        },
      ];
    } else if (title.contains("Deep-Sea") || title.contains("Vent") || title.contains("Biodiversity")) {
      return [
        {
          "id": 1,
          "type": "True / False / Not Given",
          "question": "1. Chemosynthetic organisms in hydrothermal vents rely directly on sunlight for energy.",
          "options": ["TRUE", "FALSE", "NOT GIVEN"],
          "correct": "FALSE",
          "explanation": "Hydrothermal organisms derive metabolic energy from hydrogen sulfide oxidation, completely independent of solar phototrophy.",
        },
        {
          "id": 2,
          "type": "True / False / Not Given",
          "question": "2. Hydrothermal vent clusters are predominantly formed along mid-ocean ridge zones.",
          "options": ["TRUE", "FALSE", "NOT GIVEN"],
          "correct": "TRUE",
          "explanation": "Tectonic plate divergence along mid-ocean ridges creates the volcanic geothermal activity necessary for vent formation.",
        },
        {
          "id": 3,
          "type": "Multiple Choice",
          "question": "3. What is the primary objective of commercial deep-sea extraction projects?",
          "options": ["Harvesting polymetallic nodules for green tech", "Building underwater tourist stations", "Collecting deep algae for cosmetics", "Drilling for thermal heating pipes"],
          "correct": "Harvesting polymetallic nodules for green tech",
          "explanation": "Abyssal plain nodules contain high concentrations of nickel, cobalt, and rare-earth elements for battery storage.",
        },
      ];
    } else if (title.contains("Workplace") || title.contains("Safety") || title.contains("Ergonomic")) {
      return [
        {
          "id": 1,
          "type": "True / False / Not Given",
          "question": "1. Employees are required to participate in mandatory fire drills every quarter.",
          "options": ["TRUE", "FALSE", "NOT GIVEN"],
          "correct": "TRUE",
          "explanation": "Section 1 mandates quarterly emergency evacuation exercises led by certified floor marshals.",
        },
        {
          "id": 2,
          "type": "True / False / Not Given",
          "question": "2. Monitor screens should be positioned directly at or slightly below eye level.",
          "options": ["TRUE", "FALSE", "NOT GIVEN"],
          "correct": "TRUE",
          "explanation": "Ergonomic standards require screen tops to align with eye height to avoid cervical spine fatigue.",
        },
        {
          "id": 3,
          "type": "Multiple Choice",
          "question": "3. What immediate action must be taken upon hearing a continuous fire alarm?",
          "options": ["Evacuate calmly via emergency stairs to muster point", "Collect personal belongings from lockers", "Take the main building elevator down", "Wait at the desk for manager instruction"],
          "correct": "Evacuate calmly via emergency stairs to muster point",
          "explanation": "Guidelines strictly forbid using elevators and instruct all personnel to proceed directly to designated muster zones.",
        },
      ];
    } else if (title.contains("Benefits") || title.contains("Maternity") || title.contains("Leave")) {
      return [
        {
          "id": 1,
          "type": "True / False / Not Given",
          "question": "1. Full-time employees accrue 2.5 paid leave days for every completed calendar month of service.",
          "options": ["TRUE", "FALSE", "NOT GIVEN"],
          "correct": "TRUE",
          "explanation": "Section 2 outlines the exact statutory accrual rate for full-time contracted personnel.",
        },
        {
          "id": 2,
          "type": "True / False / Not Given",
          "question": "2. Hybrid telecommuting staff may work remotely without prior line manager approval.",
          "options": ["TRUE", "FALSE", "NOT GIVEN"],
          "correct": "FALSE",
          "explanation": "The policy requires a signed remote work agreement and weekly managerial schedule confirmation.",
        },
        {
          "id": 3,
          "type": "Multiple Choice",
          "question": "3. What is the deadline for submitting corporate medical insurance claims?",
          "options": ["Within 30 calendar days of medical treatment", "Within 12 months of annual review", "At the end of each fiscal tax year", "Only during probation periods"],
          "correct": "Within 30 calendar days of medical treatment",
          "explanation": "Receipts and doctor invoices must be submitted via the HR portal within 30 days of consultation.",
        },
      ];
    } else if (title.contains("Library") || title.contains("Libraries") || title.contains("Heritage")) {
      return [
        {
          "id": 1,
          "type": "True / False / Not Given",
          "question": "1. Early 19th-century public libraries offered unrestricted borrowing to the working class.",
          "options": ["TRUE", "FALSE", "NOT GIVEN"],
          "correct": "FALSE",
          "explanation": "Historical records indicate private subscription fees excluded the vast majority of working-class laborers.",
        },
        {
          "id": 2,
          "type": "True / False / Not Given",
          "question": "2. Contemporary public libraries provide access to digital workstations and media workshops.",
          "options": ["TRUE", "FALSE", "NOT GIVEN"],
          "correct": "TRUE",
          "explanation": "Section 3 highlights digital makerspaces, computer labs, and open e-book lending platforms.",
        },
        {
          "id": 3,
          "type": "Multiple Choice",
          "question": "3. What historic legislation empowered UK local councils to establish rate-funded libraries?",
          "options": ["The Public Libraries Act of 1850", "The Education Reform Bill of 1902", "The Copyright Charter of 1888", "The Municipal Heritage Ordinance of 1945"],
          "correct": "The Public Libraries Act of 1850",
          "explanation": "The landmark 1850 Act granted borough councils permission to levy taxes to establish public libraries.",
        },
      ];
    } else {
      // Default / Renewable Energy Passage
      return [
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
          "type": "Multiple Choice",
          "question": "3. What is the central technological bottleneck facing high-density solar adoption?",
          "options": ["Grid storage capacity & intermittent supply", "High consumer tax surcharges", "Lack of silicon in global supply chains", "Government opposition to green subsidies"],
          "correct": "Grid storage capacity & intermittent supply",
          "explanation": "Managing off-peak battery storage and grid frequency balancing remains the primary structural hurdle.",
        },
      ];
    }
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
                    final ctrl = IeltsProgressController.to;
                    ctrl.readingTaskDone.value = true;
                    ctrl.readingBand.value = band;
                    ctrl.addTestResult(
                      skill: "Reading",
                      testName: "Reading: ${widget.passageTitle}",
                      score: correctCount,
                      totalQuestions: _readingQuestions.length,
                      bandScore: band,
                    );
                    ctrl.saveToLocalStorage();
                  }
                  Get.snackbar(
                    "Reading Practice Completed! 📖",
                    "Score: $correctCount / ${_readingQuestions.length} • Band $band saved & Dashboard checklist updated!",
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
