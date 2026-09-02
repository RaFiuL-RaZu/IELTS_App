import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/data/ielts_data.dart';
import 'package:justtsham/featcher/view/SkillsPracticeScreen/ielts_writing_practice_screen.dart';
import 'package:justtsham/featcher/view/SkillsPracticeScreen/practice_screen.dart';

class IeltsQuestionBankScreen extends StatefulWidget {
  const IeltsQuestionBankScreen({super.key});

  @override
  State<IeltsQuestionBankScreen> createState() => _IeltsQuestionBankScreenState();
}

class _IeltsQuestionBankScreenState extends State<IeltsQuestionBankScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
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
        title: const Text(
          "IELTS Question Bank 📝",
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(115.h),
          child: Column(
            children: [
              // Search Field
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                child: Container(
                  height: 42.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    style: TextStyle(fontSize: 13.sp),
                    decoration: InputDecoration(
                      hintText: "Search question types, topics, tasks...",
                      hintStyle: TextStyle(fontSize: 12.5.sp, color: const Color(0xFF94A3B8)),
                      prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF00695C), size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 16, color: Color(0xFF94A3B8)),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = "");
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                    ),
                  ),
                ),
              ),

              // 4-Skill Compact Segmented Pill Bar (Matching other screens!)
              Padding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 4.h, bottom: 8.h),
                child: Container(
                  height: 42.h,
                  padding: EdgeInsets.all(3.5.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(21),
                  ),
                  child: Row(
                    children: [
                      _buildSkillTab("Speaking", 0),
                      _buildSkillTab("Listening", 1),
                      _buildSkillTab("Reading", 2),
                      _buildSkillTab("Writing", 3),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSpeakingBank(),
          _buildListeningBank(),
          _buildReadingBank(),
          _buildWritingBank(),
        ],
      ),
    );
  }

  Widget _buildSkillTab(String title, int index) {
    final isSelected = _tabController.index == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _tabController.animateTo(index);
          });
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

  // --- 1. SPEAKING QUESTION BANK ---
  Widget _buildSpeakingBank() {
    final part1Topics = [
      {
        "topic": "Hometown & City Life",
        "questions": [
          "Where is your hometown located?",
          "What do you like most about living in your city?",
          "Has your hometown changed significantly in recent years?",
          "Would you prefer to live in a bustling city or the quiet countryside?",
        ],
        "strategy": "Answer directly, give 2-3 supporting sentences, and showcase colloquial fluency."
      },
      {
        "topic": "Technology & Social Media",
        "questions": [
          "How often do you use social media apps daily?",
          "Do you think artificial intelligence will replace human jobs?",
          "What is your favorite technological gadget?",
          "Did you use computers frequently when you were a child?",
        ],
        "strategy": "Use precise vocabulary (e.g. 'indispensable', 'algorithmic feeds', 'streamline workflow')."
      },
      {
        "topic": "Work & Higher Studies",
        "questions": [
          "Are you currently studying or working?",
          "What motivated you to choose your current field of specialization?",
          "What are the major challenges you encounter in your daily routine?",
          "Do you plan to pursue further qualifications overseas?",
        ],
        "strategy": "Use present perfect continuous and modal verbs to talk about career trajectories."
      },
      {
        "topic": "Leisure, Sports & Health",
        "questions": [
          "What activities do you enjoy during your downtime?",
          "How important is maintaining physical fitness in modern lifestyle?",
          "Did you participate in team sports when attending school?",
          "Do you prefer outdoor adventures or relaxing indoor pastimes?",
        ],
        "strategy": "Demonstrate varied leisure collocations like 'unwind', 'recharge batteries', 'sedentary habits'."
      },
    ];

    final cueCards = IeltsData.cueCardPool;

    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        _buildSectionHeader("Part 1: IELTS Topic Drills", Icons.forum_rounded, const Color(0xFF8A6B32)),
        SizedBox(height: 10.h),
        ...part1Topics.where((t) {
          final q = _searchQuery.toLowerCase();
          return t["topic"].toString().toLowerCase().contains(q) ||
              (t["questions"] as List<String>).any((item) => item.toLowerCase().contains(q));
        }).map((t) => _buildPart1Card(t)),

        SizedBox(height: 20.h),
        _buildSectionHeader("Part 2 & 3: High-Yield Cue Cards", Icons.mic_rounded, const Color(0xFF8A6B32)),
        SizedBox(height: 10.h),
        ...cueCards.where((c) {
          final q = _searchQuery.toLowerCase();
          return c.title.toLowerCase().contains(q) ||
              c.topicCategory.toLowerCase().contains(q) ||
              c.bulletPoints.any((b) => b.toLowerCase().contains(q));
        }).map((c) => _buildCueCardBankItem(c)),
      ],
    );
  }

  Widget _buildPart1Card(Map<String, dynamic> data) {
    final questions = data["questions"] as List<String>;
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
                  color: const Color(0xFFC8A96B).withOpacity(0.16),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text("Part 1", style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF8A6B32))),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  data["topic"] as String,
                  style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          ...questions.map((q) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("• ", style: TextStyle(color: Color(0xFF8A6B32), fontWeight: FontWeight.bold)),
                Expanded(child: Text(q, style: TextStyle(fontSize: 12.5.sp, color: const Color(0xFF334155), height: 1.35))),
              ],
            ),
          )),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline_rounded, color: Color(0xFFC8A96B), size: 16),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    "Band 8 Strategy: ${data["strategy"]}",
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

  Widget _buildCueCardBankItem(IeltsCueCardItem card) {
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
                  color: const Color(0xFFC8A96B).withOpacity(0.16),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(card.topicCategory, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF8A6B32))),
              ),
              const Spacer(),
              const Text("Band 8.5 Model", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF8A6B32))),
            ],
          ),
          SizedBox(height: 8.h),
          Text(card.title, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
          SizedBox(height: 8.h),
          ...card.bulletPoints.map((b) => Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text("• $b", style: TextStyle(fontSize: 12.sp, color: const Color(0xFF475569))),
          )),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () {
              Get.to(() => PracticeScreen(
                title: card.title,
                cardTitle: card.title,
                content: "${card.title}\n\n"
                    "You should say:\n${card.bulletPoints.map((b) => "• $b").join("\n")}\n\n"
                    "Band 8.5+ Model Answer:\n${card.sampleAnswer}",
              ));
            },
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                color: const Color(0xFFC8A96B),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFC8A96B).withOpacity(0.28),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Center(
                child: Text("🎙️ Practice Speaking on this Cue Card", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12.5)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. WRITING PROMPT BANK ---
  Widget _buildWritingBank() {
    final essayPrompts = [
      {
        "task": "Task 2: Opinion (Agree/Disagree)",
        "topic": "Education & Online Learning",
        "prompt": "Some people believe that universities should focus only on preparing students for careers, while others believe that the primary goal should be providing access to knowledge regardless of employment opportunities. Discuss both views and give your opinion.",
        "type": "Discussion + Opinion",
        "sample": "It is frequently debated whether tertiary education institutions should operate primarily as career training grounds or as centers of broader intellectual enrichment...",
        "structure": "Introduction (Paraphrase + Thesis) → Body 1 (Career focus arguments) → Body 2 (Knowledge enrichment) → Conclusion",
        "lexical": "Tertiary education, intellectual enrichment, utilitarian perspective, pragmatic competencies, holistic academia"
      },
      {
        "task": "Task 2: Problem & Solution",
        "topic": "Urban Overpopulation & Housing",
        "prompt": "In many metropolitan areas worldwide, affordable housing has become increasingly scarce, forcing many residents into substandard living conditions. What are the causes of this issue, and what viable solutions can municipal authorities implement?",
        "type": "Causes & Solutions",
        "sample": "The acute shortage of affordable housing in global megacities represents one of the most pressing socio-economic challenges of our time...",
        "structure": "Introduction → Body 1 (Root causes: urbanization, real estate speculation) → Body 2 (Solutions: zoning laws, subsidies) → Conclusion",
        "lexical": "Acute shortage, metropolitan density, socio-economic divide, municipal subsidies, sustainable infrastructure"
      },
      {
        "task": "Task 2: Advantages vs Disadvantages",
        "topic": "Remote Working & Automation",
        "prompt": "An increasing number of employees now work remotely from home rather than commuting to physical offices. Do the advantages of this trend outweigh the disadvantages?",
        "type": "Outweigh Essay",
        "sample": "The paradigm shift toward remote work has transformed corporate culture globally. While it presents minor communicative barriers, the benefits clearly outweigh the drawbacks...",
        "structure": "Introduction → Body 1 (Disadvantages: isolation, blurred work-life balance) → Body 2 (Major Advantages: productivity, flexibility) → Conclusion",
        "lexical": "Paradigm shift, corporate decentralization, telecommuting, autonomous scheduling, communicative friction"
      },
      {
        "task": "Task 1: Academic Line Graph / Chart",
        "topic": "Renewable Energy Consumption (2000 - 2025)",
        "prompt": "The graph below shows the proportion of energy generated from solar, wind, and nuclear sources in four European countries between 2000 and 2025.",
        "type": "Trend Description",
        "sample": "The line graph delineates the comparative trajectory of clean energy generation across four European nations over a quarter of a century...",
        "structure": "Introduction & Overview (Main upward trajectory) → Detail Paragraph 1 (Solar & Wind leaders) → Detail Paragraph 2 (Nuclear stabilization)",
        "lexical": "Delineates trajectory, exponential surge, eclipsed fossil fuels, leveled off, marginal fluctuations"
      },
    ];

    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        _buildSectionHeader("Writing Task 1 & Task 2 Pool", Icons.edit_note_rounded, const Color(0xFF325E6A)),
        SizedBox(height: 10.h),
        ...essayPrompts.where((e) {
          final q = _searchQuery.toLowerCase();
          return e["task"]!.toLowerCase().contains(q) ||
              e["topic"]!.toLowerCase().contains(q) ||
              e["prompt"]!.toLowerCase().contains(q);
        }).map((e) => Container(
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
                      color: const Color(0xFF325E6A).withOpacity(0.14),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(e["type"]!, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF325E6A))),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      e["topic"]!,
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(e["task"]!, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
              SizedBox(height: 8.h),
              Text(e["prompt"]!, style: TextStyle(fontSize: 12.5.sp, color: const Color(0xFF334155), height: 1.4)),
              SizedBox(height: 12.h),
              GestureDetector(
                onTap: () {
                  Get.to(() => IeltsWritingPracticeScreen(
                    taskType: e["task"]!,
                    prompt: e["prompt"]!,
                    band9Model: e["sample"]!,
                    structure: e["structure"]!,
                    lexical: e["lexical"]!,
                  ));
                },
                child: Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF325E6A),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF325E6A).withOpacity(0.28),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text("✍️ Open Writing Arena & Model Essay", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12.5)),
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  // --- 3. READING QUESTION BANK ---
  Widget _buildReadingBank() {
    final readingQuestions = [
      {
        "type": "True / False / Not Given",
        "tip": "TRUE = matches passage exactly. FALSE = directly contradicts. NOT GIVEN = passage neither confirms nor denies.",
        "samplePassage": "The introduction of drip irrigation in arid regions has reduced agricultural water loss by up to 60% compared to flood methods.",
        "question": "Drip irrigation requires more energy than traditional irrigation systems.",
        "answer": "NOT GIVEN (The text discusses water efficiency, but makes no mention of energy consumption)."
      },
      {
        "type": "Matching Headings",
        "tip": "Read the first and last sentences of each paragraph to identify main theme before scanning details.",
        "samplePassage": "Paragraph A explores early meteorological inventions in the 17th century that allowed scientists to track atmospheric pressure.",
        "question": "Choose the correct heading for Paragraph A.",
        "answer": "Historical milestones in atmospheric measurement devices."
      },
      {
        "type": "Sentence / Summary Completion",
        "tip": "Check word limit (e.g. 'NO MORE THAN TWO WORDS') and ensure grammar matches the gap.",
        "samplePassage": "Archaeologists discovered that ancient ceramic vessels were sealed with natural resin to prevent oxidation.",
        "question": "Ancient ceramic containers were coated with [ ______ ] to protect contents from air exposure.",
        "answer": "natural resin"
      },
    ];

    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        _buildSectionHeader("Reading Question Types & Strategies", Icons.menu_book_rounded, const Color(0xFF91AE6E)),
        SizedBox(height: 10.h),
        ...readingQuestions.map((r) => Container(
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF91AE6E).withOpacity(0.14),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(r["type"]!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF4A6431))),
              ),
              SizedBox(height: 10.h),
              Text("Rule & Strategy: ${r["tip"]}", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A), height: 1.35)),
              SizedBox(height: 10.h),
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Passage Snippet: \"${r["samplePassage"]}\"", style: TextStyle(fontSize: 11.5.sp, fontStyle: FontStyle.italic, color: const Color(0xFF475569))),
                    SizedBox(height: 6.h),
                    Text("Question: ${r["question"]}", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A))),
                    SizedBox(height: 4.h),
                    Text("Answer Explanation: ${r["answer"]}", style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF4A6431))),
                  ],
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  // --- 4. LISTENING QUESTION BANK ---
  Widget _buildListeningBank() {
    final listeningTypes = [
      {
        "type": "Form / Table / Note Completion",
        "tip": "Predict word types (name, date, telephone number, price) before the audio starts playing.",
        "example": "Student Registration: Name: John [ ______ ] | Course code: ENG-402 | Fee: \$[ ______ ]",
      },
      {
        "type": "Multiple Choice Questions",
        "tip": "Beware of distractors! Speakers will often mention all options before confirming the final choice.",
        "example": "Why did Sarah miss the morning lecture? A) Traffic delay  B) Medical appointment  C) Overslept",
      },
      {
        "type": "Map / Diagram Labelling",
        "tip": "Identify reference points ('north entrance', 'crossroads', 'opposite the library') and follow directions.",
        "example": "Locate the science laboratory: Follow the main corridor and turn left past the cafeteria.",
      },
    ];

    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        _buildSectionHeader("Listening Question Types & Traps", Icons.headset_rounded, const Color(0xFF2E6FA0)),
        SizedBox(height: 10.h),
        ...listeningTypes.map((l) => Container(
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E6FA0).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(l["type"]!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF2E6FA0))),
              ),
              SizedBox(height: 10.h),
              Text("Key Exam Strategy: ${l["tip"]}", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A), height: 1.35)),
              SizedBox(height: 8.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(10)),
                child: Text("Format Drill: ${l["example"]}", style: TextStyle(fontSize: 11.5.sp, color: const Color(0xFF334155))),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, [Color? iconColor]) {
    return Row(
      children: [
        Icon(icon, color: iconColor ?? const Color(0xFF00695C), size: 20),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
          ),
        ),
      ],
    );
  }
}
