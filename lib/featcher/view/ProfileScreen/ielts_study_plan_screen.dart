import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/services/ielts_local_storage_service.dart';

class IeltsStudyPlanScreen extends StatefulWidget {
  const IeltsStudyPlanScreen({super.key});

  @override
  State<IeltsStudyPlanScreen> createState() => _IeltsStudyPlanScreenState();
}

class _IeltsStudyPlanScreenState extends State<IeltsStudyPlanScreen> {
  int _selectedPlanDuration = 30; // 14, 30, or 60 days
  int _selectedWeekIndex = 0;

  @override
  Widget build(BuildContext context) {
    final progressCtrl = Get.find<IeltsProgressController>();

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
          "Personalized Study Plan 📊",
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Candidate Target & Countdown Hero Card
            _buildHeroCountdownCard(progressCtrl),

            SizedBox(height: 18.h),

            // 2. Study Plan Duration Switcher (14 Days / 30 Days / 60 Days)
            _buildPlanDurationSelector(),

            SizedBox(height: 20.h),

            // 3. AI Skill Readiness & Weakness Radar
            _buildSkillReadinessSection(progressCtrl),

            SizedBox(height: 22.h),

            // 4. 4-Week Milestone Guidance
            _buildMilestonesSection(),

            SizedBox(height: 22.h),

            // 5. Daily Habit & Study Streak Card
            _buildStudyStreakCard(progressCtrl),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  // 1. Hero Card: Target Band vs Current Estimated Band + Countdown
  Widget _buildHeroCountdownCard(IeltsProgressController progressCtrl) {
    return Obx(() {
      final currentBand = progressCtrl.overallBand.value;
      final target = progressCtrl.targetBand.value;
      final days = progressCtrl.examDaysRemaining.value;
      final gap = (target - currentBand);

      return Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF004D40), Color(0xFF00695C), Color(0xFF00897B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF004D40).withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
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
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.timer_outlined, color: Colors.white, size: 15),
                      SizedBox(width: 5.w),
                      Text(
                        "$days Days to Exam",
                        style: TextStyle(color: Colors.white, fontSize: 11.5.sp, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    progressCtrl.examModule.value,
                    style: TextStyle(color: const Color(0xFFB45309), fontSize: 11.5.sp, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Target Goal",
                        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12.sp),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "Band ${target.toStringAsFixed(1)}",
                        style: TextStyle(color: Colors.white, fontSize: 26.sp, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 40.h,
                  width: 1,
                  color: Colors.white.withOpacity(0.25),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Current Readiness",
                        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12.sp),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "Band ${currentBand.toStringAsFixed(1)}",
                        style: TextStyle(color: const Color(0xFF80CBC4), fontSize: 26.sp, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 40.h,
                  width: 1,
                  color: Colors.white.withOpacity(0.25),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Score Gap",
                        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12.sp),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        gap > 0 ? "+${gap.toStringAsFixed(1)}" : "Achieved 🎯",
                        style: TextStyle(
                          color: gap > 0 ? const Color(0xFFFDE047) : const Color(0xFF6EE7B7),
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 14.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.bolt_rounded, color: Color(0xFFFDE047), size: 18),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      "Recommended Effort: 1.5 - 2.0 hours daily to bridge the +${gap > 0 ? gap.toStringAsFixed(1) : "0.0"} gap.",
                      style: TextStyle(color: Colors.white, fontSize: 11.5.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // 2. Study Plan Duration Switcher
  Widget _buildPlanDurationSelector() {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _buildDurationTab("14-Day Fast Sprint", 14),
          _buildDurationTab("30-Day Intensive", 30),
          _buildDurationTab("60-Day Foundation", 60),
        ],
      ),
    );
  }

  Widget _buildDurationTab(String label, int days) {
    final isSelected = _selectedPlanDuration == days;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPlanDuration = days),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2))]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11.5.sp,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? const Color(0xFF00695C) : const Color(0xFF64748B),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 3. AI Skill Readiness & Weakness Radar
  Widget _buildSkillReadinessSection(IeltsProgressController progressCtrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.analytics_outlined, color: Color(0xFF00695C), size: 20),
            SizedBox(width: 8.w),
            const Text(
              "Skill Readiness & Diagnostic",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        Obx(() {
          final listening = progressCtrl.listeningBand.value;
          final reading = progressCtrl.readingBand.value;
          final writing = progressCtrl.writingBand.value;
          final speaking = progressCtrl.speakingBand.value;

          return Column(
            children: [
              _buildSkillBar(
                skill: "Speaking",
                band: speaking,
                readiness: ((speaking / 9.0) * 100).toInt(),
                status: speaking >= 7.0 ? "Good" : "Needs Fluency",
                color: const Color(0xFFC8A96B),
                icon: Icons.mic_rounded,
                weaknessTip: "Practice speaking for a full 2 minutes on Part 2 cue cards without hesitations.",
              ),
              SizedBox(height: 10.h),
              _buildSkillBar(
                skill: "Listening",
                band: listening,
                readiness: ((listening / 9.0) * 100).toInt(),
                status: listening >= 7.5 ? "Strong" : "Needs Practice",
                color: const Color(0xFF2E6FA0),
                icon: Icons.headset_rounded,
                weaknessTip: "Focus on Section 4 fast lectures & spelling accuracy in Form Filling.",
              ),
              SizedBox(height: 10.h),
              _buildSkillBar(
                skill: "Reading",
                band: reading,
                readiness: ((reading / 9.0) * 100).toInt(),
                status: reading >= 7.5 ? "Strong" : "Needs Focus",
                color: const Color(0xFF91AE6E),
                icon: Icons.menu_book_rounded,
                weaknessTip: "Improve speed on True/False/Not Given and Heading Matching paragraphs.",
              ),
              SizedBox(height: 10.h),
              _buildSkillBar(
                skill: "Writing",
                band: writing,
                readiness: ((writing / 9.0) * 100).toInt(),
                status: writing >= 7.0 ? "Good" : "High Priority",
                color: const Color(0xFF325E6A),
                icon: Icons.edit_note_rounded,
                weaknessTip: "Boost Task 2 lexical cohesion and avoid overly simple sentences.",
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildSkillBar({
    required String skill,
    required double band,
    required int readiness,
    required String status,
    required Color color,
    required IconData icon,
    required String weaknessTip,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
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
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              SizedBox(width: 10.w),
              Text(
                skill,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: color),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                "Band ${band.toStringAsFixed(1)}",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: color),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: readiness / 100.0,
              minHeight: 6.h,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              const Icon(Icons.info_outline_rounded, size: 13, color: Color(0xFF94A3B8)),
              SizedBox(width: 5.w),
              Expanded(
                child: Text(
                  weaknessTip,
                  style: TextStyle(fontSize: 11.sp, color: const Color(0xFF64748B)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 4. 4-Week Milestone Guidance Section
  Widget _buildMilestonesSection() {
    final weeks = [
      {
        "week": "Week 1",
        "title": "Foundation & Diagnostic Accuracy",
        "objective": "Identify weak question types and build core academic vocabulary.",
        "tasks": [
          "Complete 2 Full Listening section drills (focus on Section 1 & 2)",
          "Master 30 Essential Topic Vocabulary (Education & Tech)",
          "Analyze 3 Band 9 Model Essays for Task 2 Structure",
          "Record 3 Part 1 Speaking Interviews",
        ],
        "color": const Color(0xFF0284C7),
      },
      {
        "week": "Week 2",
        "title": "Lexical Expansion & Grammar Range",
        "objective": "Upgrade sentence complexity (Conditionals, Inversion) and collocations.",
        "tasks": [
          "Practice 3 Reading Passages (True/False/Not Given mastery)",
          "Write 2 Full Task 2 Essays with 40-minute timer",
          "Practice 5 Part 2 Cue Cards with 1-min preparation notes",
          "Review 18 Essential Grammar Rules & Common Errors",
        ],
        "color": const Color(0xFF059669),
      },
      {
        "week": "Week 3",
        "title": "Speed, Timing & Section 3/4 Drills",
        "objective": "Tackle challenging accents in Listening and Academic Reading speed.",
        "tasks": [
          "Complete 2 Timed Academic Reading Tests (60 mins limit)",
          "Master Task 1 Graph & Chart Overview sentences",
          "Simulate full Speaking Part 1, 2, and 3 interview flow",
          "Learn 40 Advanced Collocations (Environment & Society)",
        ],
        "color": const Color(0xFFD97706),
      },
      {
        "week": "Week 4",
        "title": "Full Exam Conditioning & Polish",
        "objective": "Replicate real test day stamina and review final band descriptors.",
        "tasks": [
          "Take 2 Complete Full Mock Tests (Listening + Reading + Writing)",
          "Conduct Final Error Audit on frequent spelling mistakes",
          "Review Band 9 Descriptors for Speaking Fluency",
          "Rest well and solidify positive exam mindset",
        ],
        "color": const Color(0xFF7C3AED),
      },
    ];

    final currentWeek = weeks[_selectedWeekIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.flag_outlined, color: Color(0xFF00695C), size: 20),
            SizedBox(width: 8.w),
            const Text(
              "Curated Study Milestones",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // Week Selector Tabs
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(weeks.length, (idx) {
              final isSelected = _selectedWeekIndex == idx;
              return GestureDetector(
                onTap: () => setState(() => _selectedWeekIndex = idx),
                child: Container(
                  margin: EdgeInsets.only(right: 8.w),
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF00695C) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF00695C) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Text(
                    weeks[idx]["week"] as String,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? Colors.white : const Color(0xFF475569),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),

        SizedBox(height: 14.h),

        // Week Detail Card
        Container(
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (currentWeek["color"] as Color).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      currentWeek["week"] as String,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: currentWeek["color"] as Color),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      currentWeek["title"] as String,
                      style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                "Goal: ${currentWeek["objective"]}",
                style: TextStyle(fontSize: 12.sp, color: const Color(0xFF64748B), fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 12.h),
              const Divider(height: 1),
              SizedBox(height: 12.h),
              const Text(
                "Recommended Action Items:",
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
              ),
              SizedBox(height: 8.h),
              ...(currentWeek["tasks"] as List<String>).map((task) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("✓ ", style: TextStyle(color: Color(0xFF00695C), fontWeight: FontWeight.bold, fontSize: 13)),
                    Expanded(
                      child: Text(
                        task,
                        style: TextStyle(fontSize: 12.sp, color: const Color(0xFF334155), height: 1.35),
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

  // 5. Daily Habit & Study Streak Card
  Widget _buildStudyStreakCard(IeltsProgressController progressCtrl) {
    return Obx(() {
      final testsLogged = progressCtrl.testHistory.length;
      final totalHours = (testsLogged * 0.5).toStringAsFixed(1);

      return Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFDE68A)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 28),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Study Consistency & Habits",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF92400E)),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "$testsLogged Practice Tests Logged (~$totalHours Total Hours)",
                    style: TextStyle(fontSize: 12.sp, color: const Color(0xFFB45309), fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Daily consistency is the #1 predictor of Band 7.5+ success.",
                    style: TextStyle(fontSize: 11.sp, color: const Color(0xFF78350F)),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
