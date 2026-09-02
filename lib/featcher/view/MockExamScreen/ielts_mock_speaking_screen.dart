import 'dart:async';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/services/ielts_local_storage_service.dart';
import 'package:justtsham/featcher/controller/ScriptController/practice_controller.dart';

class IeltsMockSpeakingScreen extends StatefulWidget {
  final int testNumber;

  const IeltsMockSpeakingScreen({
    super.key,
    this.testNumber = 1,
  });

  @override
  State<IeltsMockSpeakingScreen> createState() => _IeltsMockSpeakingScreenState();
}

class _IeltsMockSpeakingScreenState extends State<IeltsMockSpeakingScreen> {
  late final PracticeController _practiceCtrl;
  final FlutterTts _flutterTts = FlutterTts();

  int _selectedPartIndex = 0; // 0: Part 1, 1: Part 2, 2: Part 3
  bool _isPlayingExaminerAudio = false;
  bool _isSubmitted = false;

  // 1-Min Prep Timer for Part 2 Cue Card
  int _prepSecondsRemaining = 60;
  bool _isPrepTimerRunning = false;
  Timer? _prepTimer;

  int _currentQuestionIndex = 0;

  List<Map<String, String>> get _part1Questions {
    if (widget.testNumber == 2) {
      return [
        {
          "q": "What subject or academic discipline are you currently studying or specializing in?",
          "tip": "State your field of study, your primary academic interests, and why you selected this discipline.",
        },
        {
          "q": "What specific study habits or methods help you absorb complex information effectively?",
          "tip": "Mention active recall, spaced repetition, or collaborative group study sessions with a concise example.",
        },
        {
          "q": "Do you believe learning foreign languages is becoming more crucial in today's globalized world?",
          "tip": "Argue that multilingual proficiency unlocks international career mobility and cognitive adaptability.",
        },
      ];
    } else if (widget.testNumber == 3) {
      return [
        {
          "q": "Could you describe what kind of job or career path you hope to pursue in the future?",
          "tip": "Outline your vocational ambition, industry focus, and the skills you are cultivating.",
        },
        {
          "q": "How do you manage your daily schedule and prioritize urgent tasks under tight deadlines?",
          "tip": "Refer to digital productivity tools (calendars, Kanban boards) and time-blocking techniques.",
        },
        {
          "q": "Do you prefer working autonomously or as part of a collaborative cross-functional team?",
          "tip": "Provide a nuanced answer: independent focus for deep analysis, but team collaboration for creative ideation.",
        },
      ];
    } else if (widget.testNumber == 4) {
      return [
        {
          "q": "What leisure hobbies or recreational activities do you enjoy during your downtime?",
          "tip": "Mention physical sports, reading, or creative arts and explain how they help decompress from stress.",
        },
        {
          "q": "How important is maintaining physical fitness and cardiovascular exercise in your weekly routine?",
          "tip": "Discuss mental vitality, stress alleviation, and discipline using energetic descriptors.",
        },
        {
          "q": "Do you enjoy discovering unfamiliar music genres or exploring cultural art exhibitions?",
          "tip": "Explain emotional resonance and aesthetic appreciation with a brief memorable example.",
        },
      ];
    }

    return [
      {
        "q": "Could you tell me your full name and where you are originally from?",
        "tip": "State your name clearly, your hometown, and a notable geographic or cultural feature.",
      },
      {
        "q": "What do you enjoy most about living in your current hometown or city?",
        "tip": "Mention 2 specific aspects (e.g. green parks, vibrant community, culinary variety) with a brief personal detail.",
      },
      {
        "q": "How important is digital technology in your daily routine, and what device do you rely on most?",
        "tip": "Explain daily utility (work, study, connectivity) using adjectives like indispensable or ubiquitous.",
      },
    ];
  }

  Map<String, dynamic> get _part2CueCard {
    if (widget.testNumber == 2) {
      return {
        "title": "Describe an inspiring teacher or academic mentor who profoundly influenced your education.",
        "bullets": [
          "Who this educator was and what subject they instructed",
          "What distinctive pedagogical techniques or approaches they utilized",
          "How this person assisted you during an academic or personal challenge",
          "And explain why their mentorship exerted such an enduring positive impact on you.",
        ],
        "sample": "I would like to speak about my high school physics professor, Dr. Alistair Vance, whose passionate instruction revolutionized how I perceive the natural world. Rather than relying on monotonous rote memorization, Dr. Vance transformed the laboratory into an experimental workshop where students deduced thermodynamic and Newtonian principles through hands-on inquiry. When I struggled with advanced calculus-based mechanics, he dedicated additional hours after class, patient and encouraging. His mentorship not only elevated my academic performance but also instilled an enduring intellectual curiosity that guides my university aspirations to this day."
      };
    } else if (widget.testNumber == 3) {
      return {
        "title": "Describe a technological device or software application that drastically improved your daily productivity.",
        "bullets": [
          "What the gadget or application is and when you adopted it",
          "How you integrate it into your work, studies, or daily workflow",
          "What distinct features distinguish it from other tools",
          "And explain how this technology transformed your efficiency or lifestyle.",
        ],
        "sample": "I would like to describe an AI-powered knowledge management and asynchronous note-taking application called Obsidian, which I integrated into my workflow approximately eighteen months ago. Unlike conventional linear document editors, this software leverages bidirectional hyperlinks and interactive graphical neural maps. I employ it daily to synthesize lecture notes, literature reviews, and research citations into an interconnected personal knowledge repository. It has eliminated disorganized digital fragmentation and accelerated my academic writing productivity exponentially."
      };
    } else if (widget.testNumber == 4) {
      return {
        "title": "Describe a memorable journey or cultural trip you took to an unfamiliar destination.",
        "bullets": [
          "Where you travelled and who accompanied you on the journey",
          "What cultural or natural sights you explored while there",
          "What unexpected experiences or encounters occurred",
          "And explain why this trip remains vivid and significant in your memory.",
        ],
        "sample": "A journey that remains indelibly etched in my memory is a two-week cultural expedition to Kyoto, Japan, which I undertook with two close university colleagues during the autumn foliage season. We traversed centuries-old Shinto shrines, participated in a traditional Zen tea ceremony, and explored bamboo groves in Arashiyama. An unexpected highlight occurred when an elderly local artisan invited us into his ceramic workshop to demonstrate ancient pottery techniques. The trip profoundly enriched my intercultural perspective and deepened my reverence for architectural heritage."
      };
    }

    return {
      "title": "Describe an environmental project or green initiative in your city that made a positive difference.",
      "bullets": [
        "What the initiative was and who was responsible for launching it",
        "What concrete practical activities were conducted to support nature",
        "What hurdles or difficulties the project coordinators faced",
        "And explain why you feel this initiative produced an inspiring outcome.",
      ],
      "sample": "I would like to talk about an urban reforestation initiative called 'Green Canopy', which was spearheaded by local university researchers and environmental volunteers two years ago. The central objective was to convert barren industrial wastelands into biodiversity corridors. Volunteers planted thousands of indigenous saplings and installed solar-powered drip irrigation. Despite bureaucratic funding delays, the project successfully restored local bird populations and lowered neighborhood summer temperatures. It stands as an inspiring testament to citizen-led ecological rejuvenation."
    };
  }

  List<Map<String, String>> get _part3Questions {
    if (widget.testNumber == 2) {
      return [
        {
          "q": "To what extent can digital AI platforms replace human classroom instructors in the future?",
          "tip": "Explain that while AI excels at personalized drilling, human mentors provide moral guidance and emotional empathy.",
        },
        {
          "q": "Should governments guarantee free universal access to tertiary and vocational education?",
          "tip": "Weigh fiscal burdens on taxpayers against immense socio-economic returns in national innovation and productivity.",
        },
        {
          "q": "How can school curricula best adapt to prepare youngsters for jobs that do not yet exist?",
          "tip": "Emphasize critical thinking, adaptable cognitive resilience, digital literacy, and collaborative problem-solving.",
        },
      ];
    } else if (widget.testNumber == 3) {
      return [
        {
          "q": "Do you believe increasing automation will inevitably exacerbate technological unemployment?",
          "tip": "Discuss creative destruction: obsolete repetitive jobs are replaced by higher-level supervisory and ethical roles.",
        },
        {
          "q": "How can individuals protect their psychological wellbeing amidst always-connected remote work cultures?",
          "tip": "Advocate for rigid digital boundaries, scheduled offline downtime, and dedicated ergonomic domestic spaces.",
        },
        {
          "q": "What ethical regulations should international bodies enforce on artificial intelligence developers?",
          "tip": "Highlight algorithmic transparency, data privacy guarantees, and safeguards against algorithmic bias.",
        },
      ];
    } else if (widget.testNumber == 4) {
      return [
        {
          "q": "How can governments strike a balance between promoting tourism and preserving delicate historical landmarks?",
          "tip": "Suggest strict visitor quotas, tourist conservation tariffs, and investing revenues directly into archaeological preservation.",
        },
        {
          "q": "In what ways does international travel combat xenophobia and promote global peace?",
          "tip": "Discuss dismantling cultural stereotypes through authentic interpersonal immersion and shared culinary/historical appreciation.",
        },
        {
          "q": "Do you believe virtual reality tours could eventually diminish the urge for physical international vacations?",
          "tip": "Argue that VR provides valuable educational previews, but visceral sensory experiences and human connection cannot be simulated.",
        },
      ];
    }

    return [
      {
        "q": "Do you believe individual actions alone can resolve climate challenges, or must governments enforce strict legislation?",
        "tip": "Present a balanced perspective: personal consumer choices matter, but macro-level subsidies and carbon regulations have systemic impact.",
      },
      {
        "q": "In what practical ways can educational institutions cultivate genuine environmental awareness among students?",
        "tip": "Highlight experiential learning: recycling drives, botanical projects, and integrating sustainability into science curricula.",
      },
      {
        "q": "How might rapid advancements in renewable energy transform metropolitan infrastructure over the next two decades?",
        "tip": "Discuss smart grids, electric mass transit, net-zero residential buildings, and reduced urban air pollution.",
      },
    ];
  }

  @override
  void initState() {
    super.initState();
    _practiceCtrl = Get.put(PracticeController());
    _initTts();
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
            _isPlayingExaminerAudio = false;
          });
        }
      });

      _flutterTts.setErrorHandler((msg) {
        if (mounted) {
          setState(() {
            _isPlayingExaminerAudio = false;
          });
        }
      });
    } catch (e) {
      debugPrint("TTS init error: $e");
    }
  }

  @override
  void dispose() {
    _prepTimer?.cancel();
    try {
      _flutterTts.stop();
    } catch (_) {}
    super.dispose();
  }

  Future<void> _playExaminerAudio(String text) async {
    if (_isPlayingExaminerAudio) {
      await _flutterTts.stop();
      setState(() {
        _isPlayingExaminerAudio = false;
      });
      return;
    }

    setState(() {
      _isPlayingExaminerAudio = true;
    });

    try {
      await _flutterTts.speak(text);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isPlayingExaminerAudio = false;
        });
      }
    }
  }

  void _togglePrepTimer() {
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
      _prepTimer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (_prepSecondsRemaining > 0) {
          setState(() {
            _prepSecondsRemaining--;
          });
        } else {
          t.cancel();
          setState(() {
            _isPrepTimerRunning = false;
          });
          Get.snackbar(
            "Prep Time Over! 🎤",
            "Your 1-minute candidate preparation has finished. Tap the mic to record your 2-minute speech!",
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color(0xFF8A6B32),
            colorText: Colors.white,
          );
        }
      });
    }
  }

  void _handleSubmit() {
    if (_isSubmitted) {
      // Reset
      setState(() {
        _isSubmitted = false;
      });
      _practiceCtrl.deleteRecording();
      return;
    }

    final double band = 8.0;

    setState(() {
      _isSubmitted = true;
    });

    if (Get.isRegistered<IeltsProgressController>()) {
      final ctrl = IeltsProgressController.to;
      ctrl.speakingTaskDone.value = true;
      ctrl.speakingBand.value = band;
      ctrl.addTestResult(
        skill: "Speaking",
        testName: "Mock Test ${widget.testNumber} - Speaking",
        score: 8,
        totalQuestions: 9,
        bandScore: band,
        isMockExam: true,
      );
      ctrl.saveToLocalStorage();
    }

    Get.snackbar(
      "Speaking Test Evaluated! 🎯",
      "Band $band saved to dashboard & Mock Exam score history updated!",
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF8A6B32),
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text(
          "Speaking Interview Simulator",
          style: TextStyle(
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
            // Audio Hero Card (Matching Listening Screen EXACTLY)
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [Color(0xFF5C471E), Color(0xFF8A6B32), Color(0xFFC8A96B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFC8A96B).withOpacity(0.28),
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
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  "🎙️ EXAMINER TRACK (EN-GB)",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFFF7E8C8),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              if (_isPlayingExaminerAudio) ...[
                                SizedBox(width: 4.w),
                                const SizedBox(
                                  height: 8,
                                  width: 8,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFF7E8C8)),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "11-14 Mins",
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    "IELTS Mock Test ${widget.testNumber} - Speaking",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 14.h),

                  // Animated Waveform Bars matching Listening Screen
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(24, (index) {
                      final heights = [10, 16, 24, 18, 12, 28, 22, 14, 20, 26, 16, 30, 24, 18, 12, 22, 28, 14, 20, 16, 24, 18, 12, 10];
                      final h = heights[index % heights.length].toDouble();

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        height: _isPlayingExaminerAudio ? (h * (0.6 + (index % 3) * 0.2)) : h * 0.5,
                        width: 3.5,
                        decoration: BoxDecoration(
                          color: _isPlayingExaminerAudio ? const Color(0xFFF7E8C8) : Colors.white.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),

                  SizedBox(height: 16.h),

                  // Center Play/Stop Examiner Audio Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_selectedPartIndex == 0) {
                            _playExaminerAudio("Hello. Welcome to the IELTS Speaking Interview. ${_part1Questions[_currentQuestionIndex]["q"]!}");
                          } else if (_selectedPartIndex == 1) {
                            _playExaminerAudio("Now, I am going to give you a topic and I would like you to talk about it for one to two minutes. ${_part2CueCard["title"]}");
                          } else {
                            _playExaminerAudio("Let's consider broader issues related to this topic. ${_part3Questions[_currentQuestionIndex]["q"]!}");
                          }
                        },
                        child: Container(
                          height: 52.h,
                          width: 52.h,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            _isPlayingExaminerAudio ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            color: const Color(0xFF8A6B32),
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 18.h),

            // Segmented Part Switcher
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  _buildPartTab("Part 1: Intro", 0),
                  _buildPartTab("Part 2: Cue Card", 1),
                  _buildPartTab("Part 3: Discussion", 2),
                ],
              ),
            ),

            SizedBox(height: 18.h),

            // Dynamic Content per Part
            if (_selectedPartIndex == 0) ...[
              _buildQuestionsList(
                title: "Part 1 Questions (Listen & Respond aloud):",
                questions: _part1Questions,
              ),
            ] else if (_selectedPartIndex == 1) ...[
              _buildCueCardView(),
            ] else ...[
              _buildQuestionsList(
                title: "Part 3 Analytical Discussion Points:",
                questions: _part3Questions,
              ),
            ],

            SizedBox(height: 18.h),

            // Collapsible Model Speaking Answer (Matching Listening Tapescript)
            ExpansionTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: Color(0xFFE2E8F0))),
              collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: Color(0xFFE2E8F0))),
              backgroundColor: Colors.white,
              collapsedBackgroundColor: Colors.white,
              initiallyExpanded: false,
              title: const Text(
                "📜 Band 8.5+ Spoken Model Response",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9E7C38)),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Text(
                    _part2CueCard["sample"] as String,
                    style: const TextStyle(fontSize: 13.5, height: 1.55, fontStyle: FontStyle.italic, color: Color(0xFF334155)),
                  ),
                ),
              ],
            ),

            SizedBox(height: 22.h),

            // Candidate Voice Recorder Card
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Obx(() {
                final isRecording = _practiceCtrl.isRecording.value;
                final isRecorded = _practiceCtrl.isRecorded.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Candidate Voice Recording:",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: isRecording ? const Color(0xFFFEE2E2) : const Color(0xFFC8A96B).withOpacity(0.14),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isRecording
                                ? "Recording: ${_practiceCtrl.seconds.value}s"
                                : (isRecorded ? "Captured ${_practiceCtrl.seconds.value}s" : "Standby"),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: isRecording ? const Color(0xFFDC2626) : const Color(0xFF8A6B32),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    if (isRecording) ...[
                      AudioWaveforms(
                        enableGesture: false,
                        size: Size(double.infinity, 32.h),
                        recorderController: _practiceCtrl.recorderController,
                        waveStyle: const WaveStyle(
                          waveColor: Color(0xFFEF4444),
                          showMiddleLine: false,
                          extendWaveform: true,
                          spacing: 4,
                          waveThickness: 3,
                        ),
                      ),
                      SizedBox(height: 10.h),
                    ],

                    if (isRecorded && !isRecording) ...[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => _practiceCtrl.playPause(),
                              child: Container(
                                height: 36.h,
                                width: 36.h,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFC8A96B),
                                ),
                                child: Icon(
                                  _practiceCtrl.playerState.value == PlayerState.playing
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                _practiceCtrl.playerState.value == PlayerState.playing
                                    ? "Playing your response..."
                                    : "Candidate audio captured (${_practiceCtrl.seconds.value}s)",
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF334155)),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444), size: 20),
                              onPressed: () => _practiceCtrl.deleteRecording(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                    ],

                    // Controls Row
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (isRecording) {
                                _practiceCtrl.stopRecording();
                              } else {
                                _practiceCtrl.startRecording();
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              decoration: BoxDecoration(
                                color: isRecording ? const Color(0xFFDC2626) : const Color(0xFFC8A96B),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: (isRecording ? const Color(0xFFDC2626) : const Color(0xFFC8A96B)).withOpacity(0.25),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    isRecording ? "Stop Speaking" : (isRecorded ? "Re-record Response" : "Record Your Answer"),
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),

            if (_isSubmitted) ...[
              SizedBox(height: 16.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFC8A96B).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFC8A96B).withOpacity(0.35)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Official Speaking Evaluation",
                          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF785B20)),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF9E7C38),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            "Band 8.0",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    const Text(
                      "Criteria: Fluency & Coherence (8.0) • Lexical Resource (8.0) • Grammatical Range (8.0) • Pronunciation (8.0)\nFluency maintained with wide topical vocabulary, clear sentence rhythm, and authentic British interview completion.",
                      style: TextStyle(fontSize: 12, color: Color(0xFF45330D), height: 1.4),
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: 22.h),

            // Action Button matching Listening & Reading
            GestureDetector(
              onTap: _handleSubmit,
              child: Container(
                height: 48.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFC8A96B),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFC8A96B).withOpacity(0.28),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _isSubmitted ? "Reset & Retry Test" : "Submit Speaking Test",
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

  Widget _buildPartTab(String title, int index) {
    final isSelected = _selectedPartIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPartIndex = index;
            _currentQuestionIndex = 0;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFC8A96B) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionsList({
    required String title,
    required List<Map<String, String>> questions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
        ),
        SizedBox(height: 14.h),

        ...List.generate(questions.length, (idx) {
          final item = questions[idx];
          final isCurrent = _currentQuestionIndex == idx;

          return Container(
            margin: EdgeInsets.only(bottom: 14.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isCurrent ? const Color(0xFFC8A96B) : const Color(0xFFE2E8F0),
                width: isCurrent ? 1.5 : 1,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: isCurrent ? const Color(0xFFC8A96B).withOpacity(0.14) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Question ${idx + 1}",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: isCurrent ? const Color(0xFF785B20) : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() => _currentQuestionIndex = idx);
                        _playExaminerAudio(item["q"]!);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC8A96B).withOpacity(0.14),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.volume_up_rounded, color: Color(0xFF785B20), size: 16),
                            SizedBox(width: 4),
                            Text("Listen", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF785B20))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  item["q"]!,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A), height: 1.4),
                ),
                SizedBox(height: 8.h),
                Text(
                  "💡 Strategy: ${item["tip"]!}",
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.35),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCueCardView() {
    final bullets = _part2CueCard["bullets"] as List<String>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Individual Long Turn (Cue Card):",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
        ),
        SizedBox(height: 12.h),

        // 1-Min Prep Banner
        GestureDetector(
          onTap: _togglePrepTimer,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isPrepTimerRunning
                    ? [const Color(0xFFEA580C), const Color(0xFFF97316)]
                    : [const Color(0xFF8A6B32), const Color(0xFFC8A96B)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: (_isPrepTimerRunning ? const Color(0xFFEA580C) : const Color(0xFFC8A96B)).withOpacity(0.3),
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
                      size: 20,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      _isPrepTimerRunning
                          ? "1-Minute Prep Countdown: ${_prepSecondsRemaining}s"
                          : "Start 1-Min Preparation Time",
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                Text(
                  _isPrepTimerRunning ? "Pause" : "Start",
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700, decoration: TextDecoration.underline),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 14.h),

        // Cue Card
        Container(
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "You should say:",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF785B20)),
                  ),
                  GestureDetector(
                    onTap: () => _playExaminerAudio(_part2CueCard["title"] as String),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC8A96B).withOpacity(0.14),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.volume_up_rounded, color: Color(0xFF785B20), size: 16),
                          SizedBox(width: 4),
                          Text("Listen", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF785B20))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Text(
                _part2CueCard["title"] as String,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A), height: 1.35),
              ),
              SizedBox(height: 12.h),
              ...bullets.map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("• ", style: TextStyle(color: Color(0xFFC8A96B), fontWeight: FontWeight.w900, fontSize: 14)),
                    Expanded(
                      child: Text(
                        b,
                        style: const TextStyle(fontSize: 13, color: Color(0xFF334155), height: 1.4),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }
}
