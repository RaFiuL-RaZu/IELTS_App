import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/services/ielts_local_storage_service.dart';
import 'package:justtsham/featcher/view/HomeScreen/ielts_band_calculator_modal.dart';
import 'package:justtsham/featcher/view/SkillsPracticeScreen/ielts_listening_practice_screen.dart';
import 'package:justtsham/featcher/view/SkillsPracticeScreen/ielts_reading_practice_screen.dart';
import 'package:justtsham/featcher/view/MockExamScreen/ielts_mock_writing_screen.dart';
import 'package:justtsham/featcher/view/MockExamScreen/ielts_mock_speaking_screen.dart';

class _MockTestItem {
  final int testNumber;
  final String bookSeries;
  final String shortTitle;
  final String heroTitle;
  final String testTag;
  final String listeningTitle;
  final String listeningSection;
  final String listeningAudio;
  final String readingTitle;
  final String readingPassage;
  final String readingDifficulty;

  const _MockTestItem({
    required this.testNumber,
    required this.bookSeries,
    required this.shortTitle,
    required this.heroTitle,
    required this.testTag,
    required this.listeningTitle,
    required this.listeningSection,
    required this.listeningAudio,
    required this.readingTitle,
    required this.readingPassage,
    required this.readingDifficulty,
  });
}

class MockExamScreen extends StatefulWidget {
  const MockExamScreen({super.key});

  @override
  State<MockExamScreen> createState() => _MockExamScreenState();
}

class _MockExamScreenState extends State<MockExamScreen> {
  int _selectedMockTestIndex = 0;

  final List<_MockTestItem> _mockTests = const [
    _MockTestItem(
      testNumber: 1,
      bookSeries: "Set 1",
      shortTitle: "Mock Test 1",
      heroTitle: "Full Length Mock Test 1",
      testTag: "Academic Test 1",
      listeningTitle: "Mock Test 1 - Campus Accommodation",
      listeningSection: "Listening Test 1",
      listeningAudio: "Examiner: Welcome to the IELTS Assessment Listening Test 1. You will hear an accommodation officer explaining residential hall facilities...",
      readingTitle: "Mock Test 1 - Academic Passage",
      readingPassage: "The Technological Evolution of Renewable Energy grids across European metropolitan centers.",
      readingDifficulty: "Challenging (Band 8.0)",
    ),
    _MockTestItem(
      testNumber: 2,
      bookSeries: "Set 2",
      shortTitle: "Mock Test 2",
      heroTitle: "Full Length Mock Test 2",
      testTag: "Academic Test 2",
      listeningTitle: "Mock Test 2 - Library Orientation",
      listeningSection: "Listening Test 2",
      listeningAudio: "Examiner: Good morning and welcome to the university central library orientation for postgraduates and doctoral researchers...",
      readingTitle: "Mock Test 2 - Cognitive Neuroscience",
      readingPassage: "Cognitive Neuroscience: The Mechanics of Memory Consolidation and Synaptic Plasticity in Spaced Repetition.",
      readingDifficulty: "Advanced (Band 8.5)",
    ),
    _MockTestItem(
      testNumber: 3,
      bookSeries: "Set 3",
      shortTitle: "Mock Test 3",
      heroTitle: "Full Length Mock Test 3",
      testTag: "Academic Test 3",
      listeningTitle: "Mock Test 3 - Climate Telemetry",
      listeningSection: "Listening Test 3",
      listeningAudio: "Examiner: Welcome to our research tutorial on satellite telemetry dataset analysis and Monte Carlo climate algorithms...",
      readingTitle: "Mock Test 3 - Hydrothermal Vents",
      readingPassage: "Chemosynthetic Biodiversity: Deep-Sea Hydrothermal Vents and Abyssal Mineral Extraction in Oceanic Ridges.",
      readingDifficulty: "Challenging (Band 8.0)",
    ),
    _MockTestItem(
      testNumber: 4,
      bookSeries: "Set 4",
      shortTitle: "Mock Test 4",
      heroTitle: "Full Length Mock Test 4",
      testTag: "Academic Test 4",
      listeningTitle: "Mock Test 4 - Cognitive Lecture",
      listeningSection: "Listening Test 4",
      listeningAudio: "Examiner: Today we examine cognitive linguistics and cerebral syntax parsing across multilingual adult demographics...",
      readingTitle: "Mock Test 4 - Workplace Ergonomics",
      readingPassage: "Workplace Ergonomics and Occupational Safety Regulations across Modern Industrial Environments.",
      readingDifficulty: "Moderate (Band 7.5)",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final progressCtrl = Get.find<IeltsProgressController>();
    final currentTest = _mockTests[_selectedMockTestIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 65.h,
        title: const Text(
          "IELTS Mock Exam Center",
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
          // Mock Exam Compact Segmented Bar (Matching Skill Screen)
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
              child: Row(
                children: [
                  _buildMockTab("Mock 1", 0),
                  _buildMockTab("Mock 2", 1),
                  _buildMockTab("Mock 3", 2),
                  _buildMockTab("Mock 4", 3),
                ],
              ),
            ),
          ),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 16.h, bottom: 100.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Mock Exam Simulation Card with Premium Teal Gradient
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(22.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF004D40), Color(0xFF00695C), Color(0xFF0D9488)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00695C).withOpacity(0.32),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
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
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  "⏱️ FULL 2H 45M SIMULATION",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.6,
                                    color: Color(0xFFB2DFDB),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                currentTest.testTag,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 18.h),
                        Text(
                          currentTest.heroTitle,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        const Text(
                          "Simulate authentic exam conditions: Listening (30m) + Reading (60m) + Writing (60m) + Speaking (15m).",
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFFE0F2F1),
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Get.snackbar(
                                    "Full Mock Exam Started! ⏱️",
                                    "Starting ${currentTest.shortTitle}. Section 1: Listening Test is ready!",
                                    backgroundColor: const Color(0xFF00695C),
                                    colorText: Colors.white,
                                    snackPosition: SnackPosition.TOP,
                                  );
                                  Get.to(() => IeltsListeningPracticeScreen(
                                    sectionTitle: currentTest.listeningTitle,
                                    sectionNumber: currentTest.listeningSection,
                                    audioSnippet: currentTest.listeningAudio,
                                  ));
                                },
                                child: Container(
                                  height: 46.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.play_arrow_rounded, color: Color(0xFF00695C), size: 22),
                                      SizedBox(width: 6),
                                      Text(
                                        "Start Full Mock Test",
                                        style: TextStyle(color: Color(0xFF00695C), fontWeight: FontWeight.w800, fontSize: 13.5),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            GestureDetector(
                              onTap: () => IeltsBandCalculatorModal.show(context),
                              child: Container(
                                height: 46.h,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.18),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                                ),
                                child: const Center(
                                  child: Icon(Icons.calculate_outlined, color: Colors.white, size: 22),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 26.h),

                  // Sectional Breakdown
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Section-by-Section Mock Modules",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2F1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "Test ${currentTest.testNumber}",
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF00695C)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),

                  Obx(() => Column(
                    children: [
                      _buildSectionTile(
                        icon: Icons.mic_rounded,
                        color: const Color(0xFFC8A96B),
                        bgColor: const Color(0xFFC8A96B).withOpacity(0.16),
                        title: "Speaking Interview Simulator",
                        duration: "11-14 Minutes • 3 Parts with AI Voice",
                        bandScore: "Band 8.0 Target",
                        prevResult: progressCtrl.getLatestMockResult("Speaking", testQuery: "Mock Test ${currentTest.testNumber}"),
                        onTap: () => Get.to(() => IeltsMockSpeakingScreen(testNumber: currentTest.testNumber)),
                      ),
                      SizedBox(height: 12.h),
                      _buildSectionTile(
                        icon: Icons.headset_rounded,
                        color: const Color(0xFF2E6FA0),
                        bgColor: const Color(0xFF2E6FA0).withOpacity(0.12),
                        title: "Listening Module Test",
                        duration: "30 Minutes • 4 Sections • 40 Questions",
                        bandScore: "Band 8.0 Target",
                        prevResult: progressCtrl.getLatestMockResult("Listening", testQuery: "Mock Test ${currentTest.testNumber}"),
                        onTap: () => Get.to(() => IeltsListeningPracticeScreen(
                          sectionTitle: currentTest.listeningTitle,
                          sectionNumber: currentTest.listeningSection,
                          audioSnippet: currentTest.listeningAudio,
                        )),
                      ),
                      SizedBox(height: 12.h),
                      _buildSectionTile(
                        icon: Icons.menu_book_rounded,
                        color: const Color(0xFF91AE6E),
                        bgColor: const Color(0xFF91AE6E).withOpacity(0.16),
                        title: "Academic Reading Module Test",
                        duration: "60 Minutes • 3 Passages • 40 Questions",
                        bandScore: "Band 7.5 Target",
                        prevResult: progressCtrl.getLatestMockResult("Reading", testQuery: "Mock Test ${currentTest.testNumber}"),
                        onTap: () => Get.to(() => IeltsReadingPracticeScreen(
                          passageTitle: currentTest.readingTitle,
                          passageText: currentTest.readingPassage,
                          difficulty: currentTest.readingDifficulty,
                        )),
                      ),
                      SizedBox(height: 12.h),
                      _buildSectionTile(
                        icon: Icons.edit_note_rounded,
                        color: const Color(0xFF325E6A),
                        bgColor: const Color(0xFF325E6A).withOpacity(0.14),
                        title: "Writing Module Test (Task 1 & 2)",
                        duration: "60 Minutes • 2 Tasks • Min 400 Words",
                        bandScore: "Band 7.5 Target",
                        prevResult: progressCtrl.getLatestMockResult("Writing", testQuery: "Mock Test ${currentTest.testNumber}"),
                        onTap: () => Get.to(() => IeltsMockWritingScreen(testNumber: currentTest.testNumber)),
                      ),
                    ],
                  )),

                  SizedBox(height: 28.h),

                  // Mock Test History Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Mock Exam Score Log",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      Obx(() => Text(
                        "${progressCtrl.mockTestHistory.length} Recorded",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF00695C)),
                      )),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  Obx(() {
                    final history = progressCtrl.mockTestHistory;
                    if (history.isEmpty) {
                      return Container(
                        padding: EdgeInsets.all(24.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF1F5F9),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.history_toggle_off_rounded, color: Color(0xFF94A3B8), size: 28),
                            ),
                            SizedBox(height: 10.h),
                            const Text(
                              "No mock tests recorded yet.",
                              style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF475569), fontSize: 13.5),
                            ),
                            SizedBox(height: 4.h),
                            const Text(
                              "Complete any of the mock test modules above to view your official score log.",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11.5),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final item = history[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 12.h),
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
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE0F2F1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.analytics_outlined, color: Color(0xFF00695C), size: 20),
                              ),
                              SizedBox(width: 14.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.testName,
                                      style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 3.h),
                                    Text(
                                      "${item.date} • ${item.score}/${item.totalQuestions} Marks (${item.accuracy}%)",
                                      style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE0F2F1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "Band ${item.bandScore.toStringAsFixed(1)}",
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF00695C)),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMockTab(String title, int index) {
    final isSelected = _selectedMockTestIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedMockTestIndex = index;
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

  Widget _buildSectionTile({
    required IconData icon,
    required Color color,
    required Color bgColor,
    required String title,
    required String duration,
    required String bandScore,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
    IeltsTestResult? prevResult,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
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
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor ?? color, size: 24),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (prevResult != null) ...[
                      SizedBox(width: 6.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFA5D6A7)),
                        ),
                        child: Text(
                          "✓ Band ${prevResult.bandScore.toStringAsFixed(1)}",
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF2E7D32)),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 3.h),
                Text(
                  duration,
                  style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: prevResult != null ? const Color(0xFF004D40) : color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                prevResult != null ? "Retake" : "Take Test",
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: prevResult != null
                      ? Colors.white
                      : (textColor ?? (color.computeLuminance() > 0.55 ? const Color(0xFF5A3B00) : Colors.white)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}