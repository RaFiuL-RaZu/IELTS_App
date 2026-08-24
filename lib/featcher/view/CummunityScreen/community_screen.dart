import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:justtsham/featcher/view/SettingScreen/ielts_band_descriptors_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  int _activeCategoryIndex = 0; // 0: Speaking Models, 1: Writing Models, 2: Exam Strategies
  int _playingAudioIndex = -1;
  final FlutterTts _flutterTts = FlutterTts();

  final List<Map<String, dynamic>> _speakingModels = [
    {
      "topic": "Part 2: Artificial Intelligence in Higher Ed",
      "candidate": "Candidate: Sarah (Band 8.5)",
      "duration": "2:15 min",
      "snippet": "I would like to elaborate on how machine learning algorithms have fundamentally transformed tertiary education. In recent years, generative AI has created a seismic paradigm shift by enabling adaptive pedagogy and algorithmic tutoring tailor-made for individual students.",
      "keyVocab": ["Seismic paradigm shift", "Adaptive pedagogy", "Algorithmic tutoring"],
    },
    {
      "topic": "Part 2: A Memorable International Journey",
      "candidate": "Candidate: David (Band 9.0)",
      "duration": "2:20 min",
      "snippet": "Having traveled across Southeast Asia last summer, one destination that left an indelible impression was the ancient city of Kyoto. What struck me most was the harmonious juxtaposition of cutting-edge technological infrastructure and preserved cultural antiquity.",
      "keyVocab": ["Indelible impression", "Harmonious juxtaposition", "Cultural antiquity"],
    },
    {
      "topic": "Part 1: Hometown & Urban Infrastructure",
      "candidate": "Candidate: Liam (Band 8.5)",
      "duration": "1:45 min",
      "snippet": "I hail from Manchester, a historic industrial hub that has undergone substantial architectural regeneration over the past decade. Public transport is exceptionally streamlined and convenient for commuters.",
      "keyVocab": ["Substantial regeneration", "Historic industrial hub", "Streamlined"],
    },
  ];

  final List<Map<String, dynamic>> _writingModels = [
    {
      "title": "Task 2: AI Replacing Teachers (Opinion)",
      "band": "Band 9.0",
      "prompt": "Some people believe that artificial intelligence will replace human teachers in the future. To what extent do you agree or disagree?",
      "thesis": "While artificial intelligence can deliver personalized tutoring, the empathetic and moral guidance of human educators remains wholly irreplaceable.",
      "scoreBreakdown": "TR: 9.0 | CC: 9.0 | LR: 9.0 | GRA: 9.0",
    },
    {
      "title": "Task 1: Renewable Energy Production (Bar Chart)",
      "band": "Band 8.5",
      "prompt": "The bar chart illustrates renewable energy generation across four European countries from 2000 to 2020.",
      "thesis": "Overall, while fossil fuel consumption exhibited a pronounced downward trajectory, renewable capacity witnessed an unprecedented exponential surge.",
      "scoreBreakdown": "TA: 8.5 | CC: 8.5 | LR: 8.5 | GRA: 8.5",
    },
  ];

  final List<Map<String, dynamic>> _examStrategies = [
    {
      "icon": "🎧",
      "title": "Listening: The 30-Second Pre-Reading Secret",
      "desc": "Always underline keywords (names, dates, nouns) in the 30 seconds given before each audio track starts.",
    },
    {
      "icon": "📖",
      "title": "Reading: Skimming vs Scanning Technique",
      "desc": "Spend 2 minutes skimming for main paragraph themes before scanning for specific keywords in True/False/Not Given questions.",
    },
    {
      "icon": "✍️",
      "title": "Writing: The 5-Minute Brainstorming Rule",
      "desc": "Never start writing immediately. Dedicate 5 minutes to generate 2 strong main ideas, 2 examples, and outline cohesive paragraph transitions.",
    },
    {
      "icon": "🗣️",
      "title": "Speaking: Fluency over Perfection",
      "desc": "Never pause silently. Use academic fillers like 'That is an intriguing question...' or 'From a broader perspective...' to buy thinking time.",
    },
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    try {
      await _flutterTts.setLanguage("en-GB");
      await _flutterTts.setSpeechRate(0.48);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setVolume(1.0);

      _flutterTts.setCompletionHandler(() {
        if (mounted) setState(() => _playingAudioIndex = -1);
      });
    } catch (e) {
      debugPrint("Community TTS init error: $e");
    }
  }

  @override
  void dispose() {
    try {
      _flutterTts.stop();
    } catch (_) {}
    super.dispose();
  }

  Future<void> _playModelAudio(int idx) async {
    if (_playingAudioIndex == idx) {
      try {
        await _flutterTts.stop();
      } catch (_) {}
      setState(() => _playingAudioIndex = -1);
      Get.snackbar("Audio Paused", "Paused model audio playback", snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 1));
    } else {
      try {
        await _flutterTts.stop();
      } catch (_) {}
      setState(() => _playingAudioIndex = idx);
      final model = _speakingModels[idx];
      Get.snackbar("Playing Model Audio 🔊", "Listening to ${model["candidate"]}", snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 2));

      try {
        await _flutterTts.speak("${model["candidate"]}. Response to topic: ${model["topic"]}. ${model["snippet"]}");
      } catch (e) {
        debugPrint("Model TTS error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 65.h,
        title: const Text(
          "IELTS Model Library & Resources",
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Category Selector
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryChip("Band 8.5+ Speaking Audios", 0),
                  SizedBox(width: 10.w),
                  _buildCategoryChip("Band 9.0 Writing Models", 1),
                  SizedBox(width: 10.w),
                  _buildCategoryChip("Exam Strategies & Tips", 2),
                ],
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 18.h, bottom: 100.h),
              child: _buildCategoryContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String title, int index) {
    final isSelected = _activeCategoryIndex == index;
    return GestureDetector(
      onTap: () {
        _flutterTts.stop();
        setState(() {
          _activeCategoryIndex = index;
          _playingAudioIndex = -1;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00695C) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryContent() {
    if (_activeCategoryIndex == 0) {
      return Column(
        children: _speakingModels.asMap().entries.map((entry) {
          final idx = entry.key;
          final model = entry.value;
          final isPlaying = _playingAudioIndex == idx;

          return Container(
            margin: EdgeInsets.only(bottom: 18.h),
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
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
                        color: const Color(0xFFE0F2F1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        model["candidate"],
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF004D40)),
                      ),
                    ),
                    Text(
                      model["duration"],
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  model["topic"],
                  style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                ),
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Text(
                    "\"${model["snippet"]}\"",
                    style: const TextStyle(fontSize: 12.5, fontStyle: FontStyle.italic, color: Color(0xFF334155), height: 1.45),
                  ),
                ),
                SizedBox(height: 12.h),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: (model["keyVocab"] as List<String>).map((v) {
                    return Chip(
                      label: Text(v, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: Color(0xFF00695C))),
                      backgroundColor: const Color(0xFFE0F2F1),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }).toList(),
                ),
                SizedBox(height: 14.h),
                GestureDetector(
                  onTap: () => _playModelAudio(idx),
                  child: Container(
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: isPlaying ? const Color(0xFF004D40) : const Color(0xFF00695C),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(isPlaying ? Icons.pause_rounded : Icons.volume_up_rounded, color: Colors.white, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          isPlaying ? "Pause Model Audio" : "Play Audible Pronunciation & Answer",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    } else if (_activeCategoryIndex == 1) {
      return Column(
        children: _writingModels.map((wm) {
          return Container(
            margin: EdgeInsets.only(bottom: 18.h),
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        wm["title"],
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2F1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        wm["band"],
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF00695C)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  "Prompt: ${wm["prompt"]}",
                  style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B), height: 1.35),
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Band 9 Model Thesis & Argument:", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF00695C))),
                      SizedBox(height: 6.h),
                      Text("\"${wm["thesis"]}\"", style: const TextStyle(fontSize: 12.5, fontStyle: FontStyle.italic, color: Color(0xFF334155), height: 1.4)),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Official Rubric: ${wm["scoreBreakdown"]}",
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                ),
              ],
            ),
          );
        }).toList(),
      );
    } else {
      return Column(
        children: [
          // Official Descriptors Card
          GestureDetector(
            onTap: () => Get.to(() => const IeltsBandDescriptorsScreen()),
            child: Container(
              margin: EdgeInsets.only(bottom: 16.h),
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF004D40), Color(0xFF00695C)],
                ),
              ),
              child: Row(
                children: [
                  const Text("📋", style: TextStyle(fontSize: 26)),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Official IELTS Band Descriptors",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                        SizedBox(height: 3),
                        Text(
                          "View Fluency, Lexical, Grammar, & Pronunciation rubrics",
                          style: TextStyle(fontSize: 11.5, color: Color(0xFF80CBC4)),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
                ],
              ),
            ),
          ),

          ..._examStrategies.map((st) {
            return Container(
              margin: EdgeInsets.only(bottom: 14.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(st["icon"], style: const TextStyle(fontSize: 24)),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          st["title"],
                          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          st["desc"],
                          style: const TextStyle(fontSize: 12, color: Color(0xFF475569), height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      );
    }
  }
}
