import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/data/ielts_data.dart';
import 'package:justtsham/core/services/ielts_local_storage_service.dart';
import 'package:justtsham/featcher/controller/AuthController/navber_controller.dart';
import 'package:justtsham/featcher/view/SkillsPracticeScreen/ielts_listening_practice_screen.dart';
import 'package:justtsham/featcher/view/SkillsPracticeScreen/ielts_reading_practice_screen.dart';
import 'package:justtsham/featcher/view/SkillsPracticeScreen/ielts_writing_practice_screen.dart';
import 'package:justtsham/featcher/view/SkillsPracticeScreen/practice_screen.dart';

class SkillsPracticeScreen extends StatefulWidget {
  const SkillsPracticeScreen({super.key});

  @override
  State<SkillsPracticeScreen> createState() => _SkillsPracticeScreenState();
}

class _SkillsPracticeScreenState extends State<SkillsPracticeScreen> {
  NavBarController get _navBarCtrl => Get.isRegistered<NavBarController>()
      ? Get.find<NavBarController>()
      : Get.put(NavBarController());

  int _speakingSubTab = 0; // 0: Cue Cards, 1: Part 1 Topics, 2: Generator
  String _selectedCategory = "Technology & AI";
  final TextEditingController _customTopicController = TextEditingController();
  _CustomCueCardData? _generatedCard;
  bool _showModelAnswer = true;

  final List<String> _categories = [
    "Technology & AI",
    "Environment & Nature",
    "Education & School",
    "Travel & Culture",
    "Work & Career",
    "Hometown & Daily Life",
  ];

  final List<String> _quickTopicSuggestions = [
    "Artificial Intelligence",
    "Renewable Energy",
    "Remote Working",
    "An Unforgettable Trip",
    "Higher Education Reform",
    "A Skill I Mastered",
  ];

  void _generateCustomCueCard() {
    final rawTopic = _customTopicController.text.trim().isNotEmpty
        ? _customTopicController.text.trim()
        : _selectedCategory;

    final topic = rawTopic;

    String title = "Describe an important experience or innovation in $topic";
    String prompt = "Describe a significant aspect or personal experience related to $topic that has had a meaningful impact on you.";
    List<String> bullets = [
      "What it is and how you first became familiar with it",
      "Why this particular aspect of $topic is important",
      "What key benefits, changes, or challenges it involves",
      "And explain why it holds lasting personal or societal significance.",
    ];
    String modelAnswer =
        "I would like to talk about $topic, which has undoubtedly played a transformative role in my perspective. "
        "I first encountered this a couple of years ago, and since then, it has completely reshaped my daily routine and outlook. "
        "What strikes me the most is how rapidly $topic has gained traction across diverse communities. "
        "On one hand, it provides unprecedented efficiency and opens up a wide array of new possibilities. On the other hand, navigating its nuances requires dedication and continuous adaptation. "
        "Looking ahead, I am convinced that $topic will continue to be a pivotal factor for future innovation and personal development. "
        "All things considered, embracing this experience has been immensely rewarding for my intellectual growth.";
    String strategy = "Structure your response into 3 parts: engaging background context, specific details/examples with contrast linkers ('On the one hand...'), and a forward-looking conclusion.";
    List<String> vocab = [
      "Transformative role",
      "Gained significant traction",
      "Unprecedented efficiency",
      "Pivotal factor",
      "Immensely rewarding",
    ];

    setState(() {
      _generatedCard = _CustomCueCardData(
        title: title,
        prompt: prompt,
        bulletPoints: bullets,
        modelAnswer: modelAnswer,
        strategy: strategy,
        keyVocab: vocab,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final progressCtrl = Get.find<IeltsProgressController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 65.h,
        title: const Text(
          "IELTS 4-Skill Practice Hub",
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
          // 4-Skill Compact Segmented Bar
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
              child: Obx(() => Row(
                children: [
                  _buildSkillTab("Speaking", 0),
                  _buildSkillTab("Listening", 1),
                  _buildSkillTab("Reading", 2),
                  _buildSkillTab("Writing", 3),
                ],
              )),
            ),
          ),

          // Main Practice Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 16.h, bottom: 100.h),
              child: Obx(() => _buildActiveSkillView(progressCtrl)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillTab(String title, int index) {
    final isSelected = _navBarCtrl.skillPracticeIndex.value == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          _navBarCtrl.skillPracticeIndex.value = index;
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
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
            title,
            style: TextStyle(
              fontSize: 12.5.sp,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveSkillView(IeltsProgressController progressCtrl) {
    switch (_navBarCtrl.skillPracticeIndex.value) {
      case 0:
        return _buildSpeakingSkillView(progressCtrl);
      case 1:
        return _buildListeningSkillView();
      case 2:
        return _buildReadingSkillView();
      case 3:
        return _buildWritingSkillView();
      default:
        return const SizedBox();
    }
  }

  // --- SPEAKING MODULE ---
  Widget _buildSpeakingSkillView(IeltsProgressController progressCtrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sub-tabs
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildSubTabButton("Speaking Cue Cards", 0),
              SizedBox(width: 10.w),
              _buildSubTabButton("Part 1 Interview", 1),
              SizedBox(width: 10.w),
              _buildSubTabButton("Topic AI Generator", 2),
            ],
          ),
        ),
        SizedBox(height: 18.h),

        if (_speakingSubTab == 0) ...[
          // Cue Cards List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: IeltsData.cueCardPool.length,
            itemBuilder: (context, index) {
              final card = IeltsData.cueCardPool[index];
              return Obx(() {
                final isBookmarked = progressCtrl.savedCueCardIds.contains(card.id);
                final prevResult = progressCtrl.getLatestTestResult(card.title);

                return Container(
                  margin: EdgeInsets.only(bottom: 18.h),
                  padding: EdgeInsets.all(18.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: prevResult != null ? const Color(0xFF80CBC4) : const Color(0xFFE2E8F0),
                      width: prevResult != null ? 1.5 : 1,
                    ),
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
                          Expanded(
                            child: Wrap(
                              spacing: 8.w,
                              runSpacing: 6.h,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFC8A96B).withOpacity(0.14),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    card.topicCategory,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF785B20),
                                    ),
                                  ),
                                ),
                                if (prevResult != null)
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8F5E9),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: const Color(0xFFA5D6A7)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.check_circle_rounded, size: 13, color: Color(0xFF2E7D32)),
                                        const SizedBox(width: 4),
                                        Text(
                                          "Completed (Band ${prevResult.bandScore})",
                                          style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF2E7D32)),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => progressCtrl.toggleCueCardBookmark(card.id),
                            child: Icon(
                              isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                              color: isBookmarked ? const Color(0xFFC8A96B) : Colors.grey.shade400,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        card.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      ...card.bulletPoints.map((bp) => Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("• ", style: TextStyle(color: Color(0xFFC8A96B), fontWeight: FontWeight.w800, fontSize: 14)),
                            Expanded(
                              child: Text(
                                bp,
                                style: const TextStyle(fontSize: 12.5, color: Color(0xFF475569), height: 1.35),
                              ),
                            ),
                          ],
                        ),
                      )),
                      SizedBox(height: 14.h),
                      // Band 9 Sample Snippet Box
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
                            const Text(
                              "Band 8.5+ Model Opening:",
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF785B20)),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "\"${card.sampleAnswer}\"",
                              style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Color(0xFF334155), height: 1.4),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => PracticeScreen(
                            content: "${card.title}\n\n${card.bulletPoints.join('\n')}\n\nBand 8.5 Model Answer:\n${card.sampleAnswer}",
                            title: card.topicCategory,
                            cardTitle: card.title,
                          ));
                        },
                        child: Container(
                          height: 44.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: prevResult != null ? const Color(0xFF8A6B32) : const Color(0xFFC8A96B),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFC8A96B).withOpacity(0.28),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(prevResult != null ? Icons.replay_rounded : Icons.mic_none_rounded, color: Colors.white, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                prevResult != null ? "Retake / Practice Again" : "Start 1-Min Prep & Record",
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
            },
          ),
        ] else if (_speakingSubTab == 1) ...[
          // Part 1 Topics
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: IeltsData.speakingPart1Topics.length,
            itemBuilder: (context, index) {
              final p1 = IeltsData.speakingPart1Topics[index];
              return Container(
                margin: EdgeInsets.only(bottom: 16.h),
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
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2FE),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text("Part 1 Topic", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF0284C7))),
                        ),
                        SizedBox(width: 10.w),
                        Text(p1.topic, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    ...p1.questions.map((q) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Q: ${q.prompt}", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                          SizedBox(height: 6.h),
                          Text("Model: \"${q.sampleAnswer}\"", style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Color(0xFF475569), height: 1.4)),
                        ],
                      ),
                    )),
                  ],
                ),
              );
            },
          ),
        ] else ...[
          // Topic Generator
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2F1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.auto_awesome_rounded, color: Color(0xFF00695C), size: 20),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Generate Custom IELTS Cue Card",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                          ),
                          Text(
                            "Create personalized Part 2 topics with Band 8.5+ Model Answers",
                            style: TextStyle(fontSize: 11.5.sp, color: const Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Category Selector
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: "Select Category",
                    labelStyle: TextStyle(fontSize: 13.sp, color: const Color(0xFF64748B)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                  items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 13)))).toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _selectedCategory = v);
                  },
                ),
                SizedBox(height: 14.h),

                // Custom Topic Input
                TextField(
                  controller: _customTopicController,
                  decoration: InputDecoration(
                    hintText: "Or type your own topic (e.g. Electric Vehicles)...",
                    hintStyle: TextStyle(fontSize: 12.5.sp, color: const Color(0xFF94A3B8)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
                SizedBox(height: 10.h),

                // Quick Topic Suggestions Chips
                Wrap(
                  spacing: 6.w,
                  runSpacing: 6.h,
                  children: _quickTopicSuggestions.map((sug) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _customTopicController.text = sug;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Text(
                          "+ $sug",
                          style: TextStyle(fontSize: 11.sp, color: const Color(0xFF475569), fontWeight: FontWeight.w600),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                SizedBox(height: 16.h),

                // Generate Button
                GestureDetector(
                  onTap: _generateCustomCueCard,
                  child: Container(
                    height: 48.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8A6B32), Color(0xFFC8A96B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFC8A96B).withOpacity(0.28),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.psychology_rounded, color: Colors.white, size: 20),
                        SizedBox(width: 8.w),
                        const Text(
                          "Generate Cue Card & Model Answer",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13.5),
                        ),
                      ],
                    ),
                  ),
                ),

                // Generated Output Display
                if (_generatedCard != null) ...[
                  SizedBox(height: 20.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFC8A96B).withOpacity(0.35), width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC8A96B),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text("IELTS Speaking Part 2", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white)),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC8A96B).withOpacity(0.14),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text("Band 8.5+ Ready", style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFF785B20))),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),

                        // Main Prompt
                        Text(
                          _generatedCard!.prompt,
                          style: TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A), height: 1.35),
                        ),
                        SizedBox(height: 12.h),

                        // Bullet Points
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("You should say:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF785B20))),
                              SizedBox(height: 6.h),
                              ..._generatedCard!.bulletPoints.map((b) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("• ", style: TextStyle(color: Color(0xFFC8A96B), fontWeight: FontWeight.bold)),
                                    Expanded(child: Text(b, style: TextStyle(fontSize: 12.sp, color: const Color(0xFF334155), height: 1.3))),
                                  ],
                                ),
                              )),
                            ],
                          ),
                        ),

                        SizedBox(height: 12.h),

                        // Band 8.5 Model Answer Toggle
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Band 8.5+ Model Answer", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                            GestureDetector(
                              onTap: () => setState(() => _showModelAnswer = !_showModelAnswer),
                              child: Text(_showModelAnswer ? "Hide" : "Show", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF785B20))),
                            ),
                          ],
                        ),

                        if (_showModelAnswer) ...[
                          SizedBox(height: 8.h),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC8A96B).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFC8A96B).withOpacity(0.3)),
                            ),
                            child: Text(
                              "\"${_generatedCard!.modelAnswer}\"",
                              style: TextStyle(fontSize: 12.sp, fontStyle: FontStyle.italic, color: const Color(0xFF45330D), height: 1.45),
                            ),
                          ),
                        ],

                        SizedBox(height: 12.h),

                        // Key Vocab Tags
                        const Text("High-Yield Collocations:", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
                        SizedBox(height: 6.h),
                        Wrap(
                          spacing: 6.w,
                          runSpacing: 6.h,
                          children: _generatedCard!.keyVocab.map((v) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Text(v, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                          )).toList(),
                        ),

                        SizedBox(height: 16.h),

                        // Start Speaking & Recording Button
                        GestureDetector(
                          onTap: () {
                            Get.to(() => PracticeScreen(
                              title: _generatedCard!.title,
                              cardTitle: _generatedCard!.title,
                              content: "${_generatedCard!.prompt}\n\n"
                                  "You should say:\n${_generatedCard!.bulletPoints.map((b) => "• $b").join("\n")}\n\n"
                                  "Band 8.5+ Model Answer:\n${_generatedCard!.modelAnswer}",
                            ));
                          },
                          child: Container(
                            height: 46.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFC8A96B),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.mic_rounded, color: Colors.white, size: 20),
                                SizedBox(width: 8.w),
                                const Text(
                                  "🎙️ Practice Speaking on This Cue Card",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSubTabButton(String title, int index) {
    final isSelected = _speakingSubTab == index;
    return GestureDetector(
      onTap: () => setState(() => _speakingSubTab = index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00695C) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF00695C) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  // --- LISTENING MODULE ---
  Widget _buildListeningSkillView() {
    final List<Map<String, dynamic>> sections = [
      {
        "section": "Section 1",
        "title": "Hotel Booking & Travel Reservation",
        "type": "Dialogue (2 Speakers)",
        "duration": "6:30 min",
        "questions": "10 Questions (Form Completion)",
        "band": "Band 7.5+",
        "audioUrl": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
        "audioSnippet": "Agent: Good morning, Cambridge Travel Services. How can I help you?\nCaller: Hello, I'd like to inquire about booking accommodation near King's Cross for next weekend...",
      },
      {
        "section": "Section 2",
        "title": "Campus Orientation & Library Facilities",
        "type": "Monologue (1 Speaker)",
        "duration": "7:15 min",
        "questions": "10 Questions (Map & Multiple Choice)",
        "band": "Band 8.0+",
        "audioUrl": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
        "audioSnippet": "Guide: Welcome new postgraduate students to the university library. On your left is the multimedia lab, while research cubicles are located on the second floor...",
      },
      {
        "section": "Section 3",
        "title": "Environmental Science Group Project",
        "type": "Academic Discussion (3 Speakers)",
        "duration": "8:00 min",
        "questions": "10 Questions (Matching & Summary)",
        "band": "Band 8.5+",
        "audioUrl": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3",
        "audioSnippet": "Professor: Let's review your team's fieldwork data on urban rainwater harvesting. Sarah, what were your primary observations regarding filtration efficiency?",
      },
      {
        "section": "Section 4",
        "title": "University Lecture: Renewable Geothermal Energy",
        "type": "Academic Lecture (1 Speaker)",
        "duration": "9:45 min",
        "questions": "10 Questions (Note Completion)",
        "band": "Band 9.0",
        "audioUrl": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3",
        "audioSnippet": "Lecturer: Today we examine the thermodynamic viability of enhanced geothermal systems in non-volcanic geological formations across Northern Europe...",
      },
    ];

    final progressCtrl = Get.find<IeltsProgressController>();

    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sections.length,
      itemBuilder: (context, idx) {
        final sec = sections[idx];
        return Obx(() {
          final prevResult = progressCtrl.getLatestTestResult(sec["title"] as String) ?? progressCtrl.getLatestTestResult(sec["section"] as String);

          return Container(
            margin: EdgeInsets.only(bottom: 18.h),
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: prevResult != null ? const Color(0xFF80CBC4) : const Color(0xFFE2E8F0),
                width: prevResult != null ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 8.w,
                        runSpacing: 6.h,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E6FA0).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              sec["section"],
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF2E6FA0)),
                            ),
                          ),
                          if (prevResult != null)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFA5D6A7)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.check_circle_rounded, size: 13, color: Color(0xFF2E7D32)),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Completed (Band ${prevResult.bandScore})",
                                    style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF2E7D32)),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        sec["band"],
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFFEA580C)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  sec["title"],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                ),
                SizedBox(height: 6.h),
                Text(
                  "${sec["type"]} • ${sec["duration"]} • ${sec["questions"]}",
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF64748B)),
                ),
                SizedBox(height: 16.h),
                GestureDetector(
                  onTap: () {
                    Get.to(() => IeltsListeningPracticeScreen(
                      sectionTitle: sec["title"] as String,
                      sectionNumber: sec["section"] as String,
                      audioSnippet: sec["audioSnippet"] as String,
                      audioUrl: sec["audioUrl"] as String,
                    ));
                  },
                  child: Container(
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: prevResult != null ? const Color(0xFF193B57) : const Color(0xFF2E6FA0),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2E6FA0).withOpacity(0.28),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(prevResult != null ? Icons.replay_rounded : Icons.play_arrow_rounded, color: Colors.white, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          prevResult != null ? "Retake Listening Arena" : "Open Listening Arena & Auto-Score",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  // --- READING MODULE ---
  Widget _buildReadingSkillView() {
    final progressCtrl = Get.find<IeltsProgressController>();

    final List<Map<String, dynamic>> academicPassages = [
      {
        "passage": "Passage 1 (Academic)",
        "title": "The Technological Evolution of Renewable Energy",
        "words": "850 Words",
        "time": "20 Mins",
        "difficulty": "Moderate (Band 7.0)",
        "summary": "This passage explores photovoltaic efficiency leaps, solid-state battery breakthroughs, and grid integration challenges across modern European metropolitan cities. Over the last two decades, solar conversion efficiency has surged from 18% to over 53% in experimental trials.",
      },
      {
        "passage": "Passage 2 (Academic)",
        "title": "Cognitive Neuroscience & Memory Retention",
        "words": "950 Words",
        "time": "20 Mins",
        "difficulty": "Challenging (Band 8.0)",
        "summary": "An examination of synaptic plasticity, spaced repetition paradigms, and sleep-induced neural consolidation in academic learning environments. Neurological scans reveal enhanced myelin sheath deposition around frequently recalled pathways.",
      },
      {
        "passage": "Passage 3 (Academic)",
        "title": "Deep-Sea Biodiversity & Hydrothermal Vent Ecosystems",
        "words": "1,100 Words",
        "time": "20 Mins",
        "difficulty": "Advanced (Band 8.5+)",
        "summary": "Analyzing chemosynthetic organisms, extreme pressure biological adaptations, and deep ocean floor mineral extraction debates along mid-ocean ridge zones.",
      },
    ];

    final List<Map<String, dynamic>> generalPassages = [
      {
        "passage": "Section 1 (General Training)",
        "title": "Workplace Health, Fire Safety & Ergonomic Standards",
        "words": "550 Words",
        "time": "15 Mins",
        "difficulty": "General (Band 7.5)",
        "summary": "Essential safety protocols for office workers, covering emergency evacuation muster points, mandatory fire warden drills, and screen workstation ergonomic adjustments to prevent repetitive strain injury (RSI).",
      },
      {
        "passage": "Section 2 (General Training)",
        "title": "Company Employee Benefits, Maternity & Flexible Leave Policies",
        "words": "680 Words",
        "time": "18 Mins",
        "difficulty": "Workplace (Band 8.0)",
        "summary": "Comprehensive guidelines regarding annual paid leave accrual, core working hours, hybrid telecommuting entitlements, and corporate health insurance claim reimbursements.",
      },
      {
        "passage": "Section 3 (General Training)",
        "title": "The Historical Heritage & Evolution of Public Libraries",
        "words": "920 Words",
        "time": "20 Mins",
        "difficulty": "General Narrative (Band 8.5)",
        "summary": "Tracing the transformation of municipal public libraries from guarded manuscript archives in 19th-century Britain to dynamic digital community literacy centers today.",
      },
    ];

    return Obx(() {
      final isGeneral = progressCtrl.examModule.value == "General Training";
      final passages = isGeneral ? generalPassages : academicPassages;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Module Switcher Header
          Container(
            margin: EdgeInsets.only(bottom: 16.h),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Stream: ${isGeneral ? 'General Training' : 'Academic'}",
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () {
                    progressCtrl.setExamModule(isGeneral ? "Academic" : "General Training");
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF91AE6E),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      isGeneral ? "To Academic" : "To General",
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),

          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: passages.length,
            itemBuilder: (context, idx) {
              final pass = passages[idx];
              return Obx(() {
                final prevResult = progressCtrl.getLatestTestResult(pass["title"] as String);

                return Container(
                  margin: EdgeInsets.only(bottom: 18.h),
                  padding: EdgeInsets.all(18.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: prevResult != null ? const Color(0xFF91AE6E) : const Color(0xFFE2E8F0),
                      width: prevResult != null ? 1.5 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        offset: const Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Wrap(
                              spacing: 8.w,
                              runSpacing: 6.h,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF91AE6E).withOpacity(0.14),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    pass["passage"],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF4A6431),
                                    ),
                                  ),
                                ),
                                if (prevResult != null)
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF91AE6E).withOpacity(0.14),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: const Color(0xFF91AE6E).withOpacity(0.3)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.check_circle_rounded, size: 13, color: Color(0xFF4A6431)),
                                        const SizedBox(width: 4),
                                        Text(
                                          "Completed (Band ${prevResult.bandScore})",
                                          style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF4A6431)),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFF91AE6E).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              pass["difficulty"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF4A6431),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        pass["title"],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "${pass["words"]} • Recommended Time: ${pass["time"]}",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF64748B)),
                      ),
                      SizedBox(height: 16.h),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => IeltsReadingPracticeScreen(
                            passageTitle: pass["title"] as String,
                            passageText: pass["summary"] as String,
                            difficulty: pass["difficulty"] as String,
                          ));
                        },
                        child: Container(
                          height: 44.h,
                          decoration: BoxDecoration(
                            color: prevResult != null ? const Color(0xFF5A7242) : const Color(0xFF91AE6E),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF91AE6E).withOpacity(0.28),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(prevResult != null ? Icons.replay_rounded : Icons.menu_book_rounded, color: Colors.white, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                prevResult != null ? "Retake Reading Arena" : "Open Timed Reading Arena",
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
            },
          ),
        ],
      );
    });
  }

  // --- WRITING MODULE ---
  Widget _buildWritingSkillView() {
    final progressCtrl = Get.find<IeltsProgressController>();

    final List<Map<String, dynamic>> academicEssays = [
      {
        "task": "Task 2 (Academic Essay)",
        "prompt": "Some people believe that artificial intelligence will replace human teachers in the future. To what extent do you agree or disagree?",
        "band": "Band 9.0 Model",
        "structure": "Introduction (Paraphrase + Thesis) -> Body 1 (Adaptive AI algorithms personalized content) -> Body 2 (Irreplaceable human emotional empathy) -> Conclusion (Balanced view)",
        "lexical": "Indispensable, algorithmic personalization, empathetic pedagogy, nuance comprehension, transformative paradigm.",
        "sample": "While artificial intelligence is increasingly capable of delivering hyper-personalized academic instruction, I firmly contend that the fundamental empathetic and moral guidance of human educators remains wholly irreplaceable.",
      },
      {
        "task": "Task 1 (Academic Report)",
        "prompt": "The chart illustrates renewable energy generation across four European countries between 2000 and 2020.",
        "band": "Band 8.5 Model",
        "structure": "Introduction (Paraphrase) -> Overview (Key overall trends) -> Body 1 (Highest vs lowest output) -> Body 2 (Comparative trajectories)",
        "lexical": "Exhibited a pronounced upward trajectory, exponential surge, fluctuated marginally, overtaken by a substantial margin.",
        "sample": "Overall, while fossil fuel consumption exhibited a pronounced downward trajectory across all four nations, renewable generation witnessed an unprecedented exponential surge.",
      },
    ];

    final List<Map<String, dynamic>> generalEssays = [
      {
        "task": "Task 1 (GT Formal Letter)",
        "prompt": "You recently purchased an airline ticket, but due to a technical error you were overcharged. Write a formal letter to the airline customer manager explaining the situation and requesting a refund.",
        "band": "Band 9.0 Letter",
        "structure": "Salutation (Dear Sir/Madam) -> Purpose of letter -> Details of booking & transaction discrepancy -> Desired resolution (Prompt refund) -> Sign-off (Yours faithfully)",
        "lexical": "Discrepancy, booking reference, unwarranted surcharges, rectify the oversight, prompt reimbursement, inconvenience caused.",
        "sample": "Dear Sir or Madam, I am writing to formally request a full refund regarding an unwarranted double transaction on booking ref #GT8921. I trust you will treat this matter with urgency and rectify the billing discrepancy promptly. Yours faithfully, Candidate.",
      },
      {
        "task": "Task 1 (GT Semi-Formal Letter)",
        "prompt": "You have recently moved into a rented apartment and discovered several maintenance issues. Write a letter to your landlord describing the problems and requesting urgent repairs.",
        "band": "Band 8.5 Letter",
        "structure": "Salutation (Dear Mr. Anderson) -> Reason for writing -> Description of plumbing & electrical faults -> Request for contractor visit -> Sign-off (Yours sincerely)",
        "lexical": "Tenancy agreement, persistent plumbing leakage, electrical circuit tripping, uninhabitable conditions, schedule an inspection.",
        "sample": "Dear Mr. Anderson, I am writing regarding apartment 4B to bring urgent maintenance defects to your attention. The kitchen drainage is severely obstructed. Please arrange for a certified technician at your earliest convenience.",
      },
      {
        "task": "Task 2 (GT Opinion Essay)",
        "prompt": "In many modern cities, people spend long hours commuting to work. What are the main causes, and what measures can governments implement to solve this issue?",
        "band": "Band 8.5 Essay",
        "structure": "Introduction -> Causes (Urban sprawl & inadequate transit) -> Solutions (Subsidized public metro & decentralized business hubs) -> Conclusion",
        "lexical": "Urban sprawl, daily congestion, decentralized infrastructure, high-speed transit networks, alleviate commuting stress.",
        "sample": "The protracted daily commute endured by modern urbanites stems largely from rapid suburban expansion and underfunded transit infrastructure. Governments must invest decisively in high-speed rail to alleviate road congestion.",
      },
    ];

    return Obx(() {
      final isGeneral = progressCtrl.examModule.value == "General Training";
      final essays = isGeneral ? generalEssays : academicEssays;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Module Switcher Header
          Container(
            margin: EdgeInsets.only(bottom: 16.h),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Stream: ${isGeneral ? 'General (Letters)' : 'Academic (Reports)'}",
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () {
                    progressCtrl.setExamModule(isGeneral ? "Academic" : "General Training");
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF325E6A),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      isGeneral ? "To Academic" : "To General",
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),

          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: essays.length,
            itemBuilder: (context, idx) {
              final ess = essays[idx];
              return Obx(() {
                final prevResult = progressCtrl.getLatestTestResult(ess["task"] as String) ?? progressCtrl.getLatestTestResult(ess["prompt"] as String);

                return Container(
                  margin: EdgeInsets.only(bottom: 18.h),
                  padding: EdgeInsets.all(18.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: prevResult != null ? const Color(0xFF325E6A) : const Color(0xFFE2E8F0),
                      width: prevResult != null ? 1.5 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        offset: const Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Wrap(
                              spacing: 8.w,
                              runSpacing: 6.h,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF325E6A).withOpacity(0.14),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    ess["task"],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF325E6A),
                                    ),
                                  ),
                                ),
                                if (prevResult != null)
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF325E6A).withOpacity(0.14),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: const Color(0xFF325E6A).withOpacity(0.3)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.check_circle_rounded, size: 13, color: Color(0xFF325E6A)),
                                        const SizedBox(width: 4),
                                        Text(
                                          "Completed (Band ${prevResult.bandScore})",
                                          style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF325E6A)),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFF325E6A).withOpacity(0.14),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              ess["band"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF325E6A)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        ess["prompt"],
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A), height: 1.35),
                      ),
                      SizedBox(height: 16.h),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => IeltsWritingPracticeScreen(
                            taskType: ess["task"] as String,
                            prompt: ess["prompt"] as String,
                            structure: ess["structure"] as String,
                            lexical: ess["lexical"] as String,
                            band9Model: ess["sample"] as String,
                          ));
                        },
                        child: Container(
                          height: 44.h,
                          decoration: BoxDecoration(
                            color: prevResult != null ? const Color(0xFF1E3C45) : const Color(0xFF325E6A),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF325E6A).withOpacity(0.28),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(prevResult != null ? Icons.replay_rounded : Icons.edit_note_rounded, color: Colors.white, size: 20),
                              const SizedBox(width: 6),
                              Text(
                                prevResult != null ? "Retake Essay Arena" : "Open Writing Arena (Word Count & Timer)",
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
            },
          ),
        ],
      );
    });
  }
}

class _CustomCueCardData {
  final String title;
  final String prompt;
  final List<String> bulletPoints;
  final String modelAnswer;
  final String strategy;
  final List<String> keyVocab;

  const _CustomCueCardData({
    required this.title,
    required this.prompt,
    required this.bulletPoints,
    required this.modelAnswer,
    required this.strategy,
    required this.keyVocab,
  });
}

