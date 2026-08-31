import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:justtsham/featcher/view/ProfileScreen/ielts_band_descriptors_screen.dart';

class IeltsResourcesScreen extends StatefulWidget {
  const IeltsResourcesScreen({super.key});

  @override
  State<IeltsResourcesScreen> createState() => _IeltsResourcesScreenState();
}

class _IeltsResourcesScreenState extends State<IeltsResourcesScreen> {
  int _activeTabIndex = 0;
  int _playingAudioIndex = -1;
  final FlutterTts _flutterTts = FlutterTts();

  final List<String> _tabs = [
    "Cheat Sheets",
    "Podcasts & Sources",
    "50+ Spelling Traps",
    "Speaking Models",
    "Test Day Rules",
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
      debugPrint("TTS init error: $e");
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      "Copied to Clipboard! 📋",
      label,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF004D40),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "IELTS Resources",
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
          // Custom Tab Navigation Bar (Compact Segmented Track)
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Container(
              height: 42.h,
              padding: EdgeInsets.all(3.5.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(21),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: List.generate(_tabs.length, (index) {
                    final tabTitle = _tabs[index];
                    final isSelected = _activeTabIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => _activeTabIndex = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: EdgeInsets.only(right: index < _tabs.length - 1 ? 6.w : 0),
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF00695C) : Colors.transparent,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF00695C).withOpacity(0.25),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          tabTitle,
                          style: TextStyle(
                            fontSize: 12.5.sp,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            color: isSelected ? Colors.white : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),

          // Active Tab Content
          Expanded(
            child: IndexedStack(
              index: _activeTabIndex,
              children: [
                _buildCheatSheetsTab(),
                _buildSourcesTab(),
                _buildSpellingTrapsTab(),
                _buildSpeakingModelsTab(),
                _buildTestDayTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 1: MASTER CHEAT SHEETS & TEMPLATES
  // ==========================================
  Widget _buildCheatSheetsTab() {
    return ListView(
      padding: EdgeInsets.all(16.w),
      physics: const BouncingScrollPhysics(),
      children: [
        // 1. Linking Words Master Sheet
        _buildExpandableSheetCard(
          title: "Band 8.5+ Linking Words & Cohesive Devices",
          badge: "Writing & Speaking",
          badgeColor: const Color(0xFF0284C7),
          icon: Icons.link_rounded,
          content: [
            {
              "category": "Contrast & Concession",
              "items": "• Conversely (Opposite perspective)\n• In stark contrast to (Striking difference)\n• Notwithstanding the fact that (Despite the reality)\n• On the flip side (Alternative dimension)\n• Whereas / While (Comparing two situations)",
            },
            {
              "category": "Cause, Effect & Consequence",
              "items": "• Consequently (As a result)\n• As an inevitable consequence (Unavoidable outcome)\n• In light of this (Considering these facts)\n• Thereby leading to (Resulting directly in)\n• Stems predominantly from (Originates mainly from)",
            },
            {
              "category": "Addition & Reinforcement",
              "items": "• Furthermore / Moreover (In addition)\n• In tandem with this (Alongside this factor)\n• Not only [X] but also [Y] (Parallel emphasis)\n• It is equally noteworthy that (Worthy of equal attention)",
            },
            {
              "category": "Exemplification & Evidence",
              "items": "• To substantiate this claim (To provide proof)\n• A salient example of this is (A prominent instance)\n• As exemplified by recent empirical research (Demonstrated by studies)",
            },
            {
              "category": "Conclusion & Encapsulation",
              "items": "• In summation / To encapsulate (To summarize concisely)\n• Taking all parameters into account (Considering all factors)\n• The preponderance of evidence suggests (Major evidence indicates)",
            },
          ],
        ),

        SizedBox(height: 16.h),

        // 2. Task 1 Academic Chart & Graph Vocabulary
        _buildExpandableSheetCard(
          title: "Writing Task 1: Academic Graph & Chart Vocabulary",
          badge: "Task 1 Academic",
          badgeColor: const Color(0xFF059669),
          icon: Icons.show_chart_rounded,
          content: [
            {
              "category": "Upward Trends & Surges",
              "items": "• Surged exponentially (Rapid and vast increase)\n• Experienced a meteoric rise (Swift upward leap)\n• Climbed steadily to reach a peak of (Gradual peak)\n• Rocketed / Soared (Dramatic sharp rise)",
            },
            {
              "category": "Downward Trends & Slumps",
              "items": "• Plummeted / Slumped drastically (Severe drop)\n• Dipped marginally (Slight temporary decline)\n• Suffered a precipitous downturn (Steep downward fall)\n• Diminished progressively (Gradual continuous decrease)",
            },
            {
              "category": "Stability & Fluctuations",
              "items": "• Plateaued at / Leveled off at (Remained stable after change)\n• Remained virtually static (No noticeable change)\n• Exhibited erratic fluctuations (Wild irregular swings)",
            },
            {
              "category": "Band 9 Overview Starters",
              "items": "• Overall, what stands out from the graph is that...\n• A cursory glance at the data reveals two divergent trajectories...\n• It is abundantly manifest that [X] maintained absolute dominance throughout the period...",
            },
          ],
        ),

        SizedBox(height: 16.h),

        // 3. Task 2 Band 9 Essay Structural Templates
        _buildExpandableSheetCard(
          title: "Writing Task 2: Band 9 Structural Skeletons",
          badge: "Task 2 Essay",
          badgeColor: const Color(0xFFD97706),
          icon: Icons.article_rounded,
          content: [
            {
              "category": "Opinion (Agree / Disagree) Skeleton",
              "items": "• Intro: [Paraphrase prompt]. While some argue [opposing stance], I firmly contend that [thesis] due to [Reason A] and [Reason B].\n• Body 1: The primary justification for this view lies in [Reason A]...\n• Body 2: Furthermore, an equally compelling dimension is [Reason B]...\n• Conclusion: In conclusion, although [counter-argument], I reiterate that [restate thesis].",
            },
            {
              "category": "Discussion (Both Views + Opinion) Skeleton",
              "items": "• Intro: It is often debated whether [View 1] or [View 2]. While valid arguments support the former, I subscribe to the latter perspective.\n• Body 1 (View 1): On the one hand, proponents of [View 1] argue that...\n• Body 2 (View 2 + Your Stance): On the other hand, there are stronger grounds to support [View 2] because...\n• Conclusion: To encapsulate, while [View 1] has merit, [View 2] offers a far more sustainable paradigm.",
            },
          ],
        ),

        SizedBox(height: 16.h),

        // 4. Speaking Natural Fillers & Delay Phrases
        _buildExpandableSheetCard(
          title: "Speaking: Natural Delay Phrases & Fillers",
          badge: "Fluency Hack",
          badgeColor: const Color(0xFF7C3AED),
          icon: Icons.record_voice_over_rounded,
          content: [
            {
              "category": "Buying 3-5 Seconds to Think (Avoid Dead Silence)",
              "items": "• \"That is an intriguing question to ponder...\"\n• \"I haven't given it much thought previously, but off the top of my head...\"\n• \"From a broader societal standpoint, one could argue that...\"\n• \"Well, to be completely candid with you...\"",
            },
            {
              "category": "Expressing Speculation & Nuance (Part 3)",
              "items": "• \"It is highly probable that... in the foreseeable future.\"\n• \"I am somewhat skeptical about whether this will materialize, however...\"\n• \"The long-term ramifications remain to be seen...\"",
            },
          ],
        ),
      ],
    );
  }

  Widget _buildExpandableSheetCard({
    required String title,
    required String badge,
    required Color badgeColor,
    required IconData icon,
    required List<Map<String, String>> content,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: false,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: badgeColor, size: 20),
          ),
          title: Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(badge, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: badgeColor)),
                ),
              ],
            ),
          ),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
              child: Column(
                children: content.map((section) {
                  return Container(
                    margin: EdgeInsets.only(top: 10.h),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              section["category"]!,
                              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, color: const Color(0xFF00695C)),
                            ),
                            GestureDetector(
                              onTap: () => _copyToClipboard(section["items"]!, section["category"]!),
                              child: Row(
                                children: [
                                  const Icon(Icons.copy_rounded, size: 13, color: Color(0xFF64748B)),
                                  SizedBox(width: 4.w),
                                  Text("Copy", style: TextStyle(fontSize: 10.5.sp, color: const Color(0xFF64748B), fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          section["items"]!,
                          style: TextStyle(fontSize: 12.sp, color: const Color(0xFF334155), height: 1.45),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TAB 2: RECOMMENDED PODCASTS & READING
  // ==========================================
  Widget _buildSourcesTab() {
    final podcasts = [
      {
        "title": "BBC 6 Minute English",
        "category": "🎧 Listening & Daily Idioms",
        "level": "Intermediate to Advanced",
        "desc": "Short 6-minute discussions on trending global topics with British RP pronunciation and natural colloquial vocabulary.",
        "why": "Best for IELTS Listening Section 1 & 2 accent familiarity.",
      },
      {
        "title": "IELTS Speaking for Success",
        "category": "🗣️ Band 9 Speaking Model Audio",
        "level": "Band 7.0 - 9.0",
        "desc": "Native speaker Maria & Rory answer real current IELTS Speaking Part 1, 2, and 3 cue cards with flawless lexical resources.",
        "why": "Hear exactly how Band 9 grammar and natural humor flow.",
      },
      {
        "title": "TED Talks Daily",
        "category": "🧠 Academic Ideas & Lecture Speed",
        "level": "Advanced (Band 8+)",
        "desc": "Short presentations by global researchers covering technology, psychology, climate change, and linguistics.",
        "why": "Prepares you for fast, complex Section 4 academic lectures.",
      },
    ];

    final readingSources = [
      {
        "title": "The Economist & Scientific American",
        "category": "📖 Academic Reading Section 3",
        "desc": "Analytical long-form articles on economics, environment, and history.",
        "why": "Cambridge IELTS Reading passages are directly adapted from these publications.",
      },
      {
        "title": "National Geographic & Nature Journal",
        "category": "📖 Science & Biodiversity Passages",
        "desc": "Deep dives into wildlife biology, archaeology, geology, and astronomy.",
        "why": "Builds fast scanning ability for dense technical terms and True/False/Not Given questions.",
      },
    ];

    return ListView(
      padding: EdgeInsets.all(16.w),
      physics: const BouncingScrollPhysics(),
      children: [
        _buildSectionTitle("Top Recommended IELTS Podcasts", Icons.podcasts_rounded),
        SizedBox(height: 10.h),
        ...podcasts.map((p) => _buildSourceCard(p, const Color(0xFF0284C7))),

        SizedBox(height: 20.h),
        _buildSectionTitle("Authoritative Academic Reading Sources", Icons.menu_book_rounded),
        SizedBox(height: 10.h),
        ...readingSources.map((r) => _buildSourceCard(r, const Color(0xFF059669))),
      ],
    );
  }

  Widget _buildSourceCard(Map<String, String> item, Color accentColor) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item["category"]!,
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: accentColor),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            item["title"]!,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
          ),
          SizedBox(height: 6.h),
          Text(
            item["desc"]!,
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF475569), height: 1.35),
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.star_rounded, color: Color(0xFFD97706), size: 16),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    "Exam Value: ${item["why"]}",
                    style: TextStyle(fontSize: 11.sp, color: const Color(0xFF64748B), fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 3: 50+ IELTS SPELLING & EXAM TRAPS
  // ==========================================
  Widget _buildSpellingTrapsTab() {
    final spellingTraps = [
      {"word": "Accommodation", "trap": "Double 'cc' and double 'mm'. (Most misspelled word in IELTS!)"},
      {"word": "Embarrassment", "trap": "Double 'rr' and double 'ss'."},
      {"word": "Questionnaire", "trap": "Double 'nn' with 'aire' at the end."},
      {"word": "Privilege", "trap": "No 'd'. It is '-lege', not '-ledge'."},
      {"word": "Occurrence", "trap": "Double 'cc' and double 'rr', ending in '-rence'."},
      {"word": "Millennium", "trap": "Double 'll' and double 'nn'."},
      {"word": "Necessary", "trap": "One 'c', double 'ss'."},
      {"word": "Harassment", "trap": "One 'r', double 'ss'."},
      {"word": "Definitely", "trap": "Contains 'finite' in the middle (not 'definately')."},
      {"word": "Separate", "trap": "Has 'para' in the middle (not 'seperate')."},
      {"word": "Environment", "trap": "Don't forget the silent 'n' before 'ment'."},
      {"word": "Government", "trap": "Don't omit the 'n' in 'govern'."},
      {"word": "Pronunciation", "trap": "It is 'nun', not 'noun' (pronounce vs pronunciation)."},
      {"word": "Disappoint", "trap": "One 's', double 'pp'."},
      {"word": "Liaison", "trap": "Double 'i': L-i-a-i-s-o-n."},
    ];

    final listeningTraps = [
      {"rule": "13 vs 30 / 14 vs 40", "tip": "Teens (-teen) have strong stress on the second syllable (thir-TEEN). Decades (-ty) have stress on the first (THIR-ty)."},
      {"rule": "Letter Homophones", "tip": "Beware of: A / 8, B / P, G / J, M / N. Speakers often correct themselves ('That's B for Bravo, not P')."},
      {"rule": "Plural 's' Trap", "tip": "If the recording says 'students', writing 'student' counts as 100% incorrect."},
      {"rule": "Self-Correction Distractor", "tip": "\"We'll meet at 4:30... actually no, let's make it 5:00.\" -> The answer is 5:00!"},
    ];

    return ListView(
      padding: EdgeInsets.all(16.w),
      physics: const BouncingScrollPhysics(),
      children: [
        _buildSectionTitle("High-Frequency Spelling Traps (Double Letters)", Icons.spellcheck_rounded),
        SizedBox(height: 10.h),
        ...spellingTraps.map((s) => Container(
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  s["word"]!,
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: Color(0xFFDC2626)),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  s["trap"]!,
                  style: TextStyle(fontSize: 12.sp, color: const Color(0xFF334155), height: 1.35),
                ),
              ),
            ],
          ),
        )),

        SizedBox(height: 20.h),
        _buildSectionTitle("Listening Traps & Self-Correction Distractors", Icons.hearing_disabled_rounded),
        SizedBox(height: 10.h),
        ...listeningTraps.map((l) => Container(
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFDE68A)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l["rule"]!, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF92400E))),
              SizedBox(height: 4.h),
              Text(l["tip"]!, style: TextStyle(fontSize: 12.sp, color: const Color(0xFF78350F), height: 1.35)),
            ],
          ),
        )),
      ],
    );
  }

  // ==========================================
  // TAB 4: SPEAKING BAND 8.5 MODELS (WITH TTS)
  // ==========================================
  Widget _buildSpeakingModelsTab() {
    final models = [
      {
        "topic": "Part 2: Technological Innovation (AI in Education)",
        "candidate": "Candidate: Sarah (Band 8.5)",
        "snippet": "I would like to elaborate on how artificial intelligence has fundamentally transformed tertiary education. In recent years, generative AI has created a seismic paradigm shift by enabling adaptive pedagogy and algorithmic tutoring tailor-made for individual students.",
        "collocations": ["Seismic paradigm shift", "Adaptive pedagogy", "Algorithmic tutoring"],
      },
      {
        "topic": "Part 2: An Unforgettable Journey",
        "candidate": "Candidate: David (Band 9.0)",
        "snippet": "Having traveled across Southeast Asia last summer, one destination that left an indelible impression was the ancient city of Kyoto. What struck me most was the harmonious juxtaposition of cutting-edge technological infrastructure and preserved cultural antiquity.",
        "collocations": ["Indelible impression", "Harmonious juxtaposition", "Cultural antiquity"],
      },
      {
        "topic": "Part 1: Hometown & Infrastructure",
        "candidate": "Candidate: Liam (Band 8.5)",
        "snippet": "I hail from Manchester, a historic industrial hub that has undergone substantial architectural regeneration over the past decade. Public transport is exceptionally streamlined and convenient for commuters.",
        "collocations": ["Historic industrial hub", "Architectural regeneration", "Streamlined"],
      },
    ];

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      physics: const BouncingScrollPhysics(),
      itemCount: models.length,
      itemBuilder: (context, index) {
        final m = models[index];
        final isPlaying = _playingAudioIndex == index;

        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isPlaying ? const Color(0xFF00695C) : const Color(0xFFE2E8F0),
              width: isPlaying ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2F1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(m["candidate"] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF004D40))),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      if (isPlaying) {
                        await _flutterTts.stop();
                        setState(() => _playingAudioIndex = -1);
                      } else {
                        setState(() => _playingAudioIndex = index);
                        await _flutterTts.speak(m["snippet"] as String);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isPlaying ? const Color(0xFFDC2626) : const Color(0xFF00695C),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(isPlaying ? Icons.stop_rounded : Icons.volume_up_rounded, color: Colors.white, size: 16),
                          SizedBox(width: 4.w),
                          Text(isPlaying ? "Stop Audio" : "Listen Audio 🎙️", style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Text(m["topic"] as String, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
              SizedBox(height: 8.h),
              Text(
                "\"${m["snippet"]}\"",
                style: TextStyle(fontSize: 12.5.sp, color: const Color(0xFF334155), height: 1.4, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 10.h),
              Wrap(
                spacing: 6.w,
                runSpacing: 6.h,
                children: (m["collocations"] as List<String>).map((c) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text("💎 $c", style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A))),
                )).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================
  // TAB 5: TEST DAY MASTER CHECKLIST & RULES
  // ==========================================
  Widget _buildTestDayTab() {
    return ListView(
      padding: EdgeInsets.all(16.w),
      physics: const BouncingScrollPhysics(),
      children: [
        // Official Band Descriptors Banner
        GestureDetector(
          onTap: () => Get.to(() => const IeltsBandDescriptorsScreen()),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF004D40), Color(0xFF00695C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_rounded, color: Color(0xFF80CBC4), size: 28),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Official IELTS Band Descriptors",
                        style: TextStyle(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w800),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "View British Council / IDP marking rubric for Band 6 to Band 9.",
                        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11.5.sp),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
              ],
            ),
          ),
        ),

        SizedBox(height: 18.h),
        _buildSectionTitle("Test Day Checklist & Instructions", Icons.checklist_rounded),
        SizedBox(height: 10.h),

        _buildChecklistItem("Valid Original Passport / National ID", "The EXACT identification document used during exam registration. Photocopies or digital photos are strictly prohibited.", true),
        _buildChecklistItem("Clear Transparent Water Bottle", "Labels must be peeled off completely. No colored bottles allowed.", true),
        _buildChecklistItem("Pencils (HB / 2B) & High-Quality Eraser", "Required for Listening and Reading paper tests. Sharpeners allowed.", true),
        _buildChecklistItem("NO Smartwatches or Digital Devices", "Even analog watches must be left in the cloakroom. Wall clocks will be visible in the examination hall.", false),
        _buildChecklistItem("Arrive 45 Minutes Prior to Test Time", "Required for biometric registration, photo capture, and metal detector security scanning.", true),

        SizedBox(height: 18.h),
        _buildSectionTitle("Exam Room Timing & Strategy", Icons.alarm_on_rounded),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("1. Listening: Transfer Time Difference", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
              SizedBox(height: 4.h),
              Text("Paper-based gives 10 minutes to transfer answers. Computer-delivered IELTS gives ONLY 2 minutes to check answers!", style: TextStyle(fontSize: 11.5.sp, color: const Color(0xFF475569))),
              const Divider(height: 20),
              const Text("2. Reading: NO Transfer Time", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
              SizedBox(height: 4.h),
              Text("Write your answers directly on the answer sheet as you read. Do not wait for the end.", style: TextStyle(fontSize: 11.5.sp, color: const Color(0xFF475569))),
              const Divider(height: 20),
              const Text("3. Writing: Word Count Penalty", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
              SizedBox(height: 4.h),
              Text("Task 1 must be at least 150 words (aim for 160-180). Task 2 must be at least 250 words (aim for 270-290).", style: TextStyle(fontSize: 11.5.sp, color: const Color(0xFF475569))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChecklistItem(String title, String desc, bool isAllowed) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isAllowed ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isAllowed ? Icons.check_circle_outline_rounded : Icons.cancel_outlined,
              color: isAllowed ? const Color(0xFF047857) : const Color(0xFFDC2626),
              size: 18,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                SizedBox(height: 2.h),
                Text(desc, style: TextStyle(fontSize: 11.5.sp, color: const Color(0xFF475569), height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF00695C), size: 20),
        SizedBox(width: 8.w),
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
        ),
      ],
    );
  }
}
