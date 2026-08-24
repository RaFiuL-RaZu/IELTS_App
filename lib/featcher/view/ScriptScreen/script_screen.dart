import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/data/ielts_data.dart';
import 'package:justtsham/core/services/ielts_local_storage_service.dart';
import 'package:justtsham/featcher/view/ScriptScreen/ielts_listening_practice_screen.dart';
import 'package:justtsham/featcher/view/ScriptScreen/ielts_reading_practice_screen.dart';
import 'package:justtsham/featcher/view/ScriptScreen/ielts_writing_practice_screen.dart';
import 'package:justtsham/featcher/view/ScriptScreen/practice_screen.dart';

class ScriptScreen extends StatefulWidget {
  const ScriptScreen({super.key});

  @override
  State<ScriptScreen> createState() => _ScriptScreenState();
}

class _ScriptScreenState extends State<ScriptScreen> {
  int _activeSkillIndex = 0; // 0: Speaking, 1: Listening, 2: Reading, 3: Writing
  int _speakingSubTab = 0; // 0: Cue Cards, 1: Part 1 Topics, 2: Generator
  String _selectedCategory = "Technology & AI";
  final TextEditingController _customTopicController = TextEditingController();
  String _generatedCueCard = "";

  final List<String> _categories = [
    "Technology & AI",
    "Environment & Nature",
    "Education & School",
    "Travel & Culture",
    "Work & Career",
    "Hometown & Daily Life",
  ];

  void _generateCustomCueCard() {
    final topic = _customTopicController.text.trim().isNotEmpty
        ? _customTopicController.text.trim()
        : _selectedCategory;

    setState(() {
      _generatedCueCard =
          "Describe a significant development in $topic that has impacted your community.\n\n"
          "You should say:\n"
          "• What this development is\n"
          "• When and where it happened\n"
          "• How people in your society responded to it\n"
          "• And explain why you consider it to be of paramount importance for the future.\n\n"
          "Band 9 Model Strategy:\n"
          "Start by framing the societal context, utilize complex inversion structures ('Not only did this innovation...'), and conclude with a nuanced perspective.";
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
          // 4-Skill Segmented Bar
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Container(
              height: 52.h,
              padding: EdgeInsets.all(5.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(26),
              ),
              child: Row(
                children: [
                  _buildSkillTab("Speaking", 0, Icons.mic_rounded),
                  _buildSkillTab("Listening", 1, Icons.headset_rounded),
                  _buildSkillTab("Reading", 2, Icons.menu_book_rounded),
                  _buildSkillTab("Writing", 3, Icons.edit_note_rounded),
                ],
              ),
            ),
          ),

          // Main Practice Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 18.h, bottom: 100.h),
              child: _buildActiveSkillView(progressCtrl),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillTab(String title, int index, IconData icon) {
    final isSelected = _activeSkillIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _activeSkillIndex = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF00695C) : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF00695C).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 17,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
              ),
              SizedBox(width: 5.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveSkillView(IeltsProgressController progressCtrl) {
    switch (_activeSkillIndex) {
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
              _buildSubTabButton("Cambridge Cue Cards", 0),
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
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              card.topicCategory,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF004D40),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => progressCtrl.toggleCueCardBookmark(card.id),
                            child: Icon(
                              isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                              color: isBookmarked ? const Color(0xFF00695C) : Colors.grey.shade400,
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
                            const Text("• ", style: TextStyle(color: Color(0xFF00695C), fontWeight: FontWeight.w800, fontSize: 14)),
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
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF00695C)),
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
                          ));
                        },
                        child: Container(
                          height: 44.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00695C),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.mic_none_rounded, color: Colors.white, size: 18),
                              SizedBox(width: 6),
                              Text(
                                "Start 1-Min Prep & Record",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
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
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Generate Custom IELTS Cue Card", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                SizedBox(height: 14.h),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: "Select Category",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                  items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _selectedCategory = v);
                  },
                ),
                SizedBox(height: 14.h),
                TextField(
                  controller: _customTopicController,
                  decoration: InputDecoration(
                    hintText: "Or type specific topic (e.g. Electric Cars)...",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
                SizedBox(height: 16.h),
                GestureDetector(
                  onTap: _generateCustomCueCard,
                  child: Container(
                    height: 46.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00695C),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(
                      child: Text("Generate Prompt & Model Answer", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
                if (_generatedCueCard.isNotEmpty) ...[
                  SizedBox(height: 18.h),
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2F1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF80CBC4)),
                    ),
                    child: Text(_generatedCueCard, style: const TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF004D40))),
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

    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sections.length,
      itemBuilder: (context, idx) {
        final sec = sections[idx];
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
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      sec["section"],
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF2E7D32)),
                    ),
                  ),
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
                    color: const Color(0xFF00695C),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
                      SizedBox(width: 6),
                      Text("Open Listening Arena & Auto-Score", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
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
                      color: isGeneral ? const Color(0xFF00695C) : const Color(0xFF6A1B9A),
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
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: isGeneral ? const Color(0xFFE0F2F1) : const Color(0xFFF3E5F5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              pass["passage"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isGeneral ? const Color(0xFF004D40) : const Color(0xFF6A1B9A),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: isGeneral ? const Color(0xFFF1F5F9) : const Color(0xFFEDE7F6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              pass["difficulty"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isGeneral ? const Color(0xFF0F172A) : const Color(0xFF4A148C),
                              ),
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
                          color: isGeneral ? const Color(0xFF00695C) : const Color(0xFF6A1B9A),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.menu_book_rounded, color: Colors.white, size: 18),
                            SizedBox(width: 6),
                            Text("Open Timed Reading Arena", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
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
                      color: isGeneral ? const Color(0xFF00695C) : const Color(0xFFE65100),
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
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: isGeneral ? const Color(0xFFE0F2F1) : const Color(0xFFFFF3E0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              ess["task"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isGeneral ? const Color(0xFF004D40) : const Color(0xFFE65100),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0F2F1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              ess["band"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF00695C)),
                            ),
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
                          color: isGeneral ? const Color(0xFF00695C) : const Color(0xFFE65100),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.edit_note_rounded, color: Colors.white, size: 20),
                            SizedBox(width: 6),
                            Text("Open Writing Arena (Word Count & Timer)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      );
    });
  }
}
