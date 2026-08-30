import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/services/ielts_local_storage_service.dart';
import 'package:justtsham/featcher/controller/AuthController/navber_controller.dart';
import 'package:justtsham/featcher/view/HomeScreen/ielts_band_calculator_modal.dart';
import 'package:justtsham/featcher/view/ScriptScreen/ielts_listening_practice_screen.dart';
import 'package:justtsham/featcher/view/ScriptScreen/ielts_reading_practice_screen.dart';

class AuditionScreen extends StatelessWidget {
  const AuditionScreen({super.key});

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
          "Cambridge Mock Exam Center",
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
        padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 18.h, bottom: 100.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Mock Exam Simulation Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(22.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E1B4B), Color(0xFF312E81), Color(0xFF4338CA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF312E81).withOpacity(0.3),
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
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "⏱️ FULL 2H 45M SIMULATION",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: Color(0xFFA5B4FC),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Academic Test 1",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18.h),
                  const Text(
                    "Official Cambridge Timed Mock",
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  const Text(
                    "Simulate authentic exam conditions: Listening (30m) + Reading (60m) + Writing (60m) + Speaking (15m).",
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFFC7D2FE),
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
                              "Section 1: Listening Test is ready. Time allocated: 30 minutes.",
                              backgroundColor: const Color(0xFF312E81),
                              colorText: Colors.white,
                              snackPosition: SnackPosition.TOP,
                            );
                            Get.to(() => const IeltsListeningPracticeScreen(
                              sectionTitle: "Cambridge Full Mock 1 - Listening",
                              sectionNumber: "Section 1-4 Complete",
                              audioSnippet: "Examiner: You will hear a number of different recordings and you will have to answer questions on what you hear...",
                            ));
                          },
                          child: Container(
                            height: 46.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.play_arrow_rounded, color: Color(0xFF312E81), size: 22),
                                SizedBox(width: 6),
                                Text(
                                  "Start Full Mock Test",
                                  style: TextStyle(color: Color(0xFF312E81), fontWeight: FontWeight.w800, fontSize: 13.5),
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
                            color: Colors.white.withOpacity(0.15),
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

            SizedBox(height: 28.h),

            // Sectional Breakdown
            const Text(
              "Section-by-Section Mock Modules",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
            SizedBox(height: 14.h),

            Obx(() => Column(
              children: [
                _buildSectionTile(
                  icon: Icons.headset_rounded,
                  color: const Color(0xFF00695C),
                  bgColor: const Color(0xFFE0F2F1),
                  title: "Listening Module Test",
                  duration: "30 Minutes • 4 Sections • 40 Questions",
                  bandScore: "Target: Band 8.5",
                  prevResult: progressCtrl.getLatestTestResult("Listening"),
                  onTap: () {
                    Get.to(() => const IeltsListeningPracticeScreen(
                      sectionTitle: "Cambridge Mock Test 1 - Audio Section",
                      sectionNumber: "Listening Test 1",
                      audioSnippet: "Agent: Welcome to Cambridge English Assessment Listening Test 1...",
                    ));
                  },
                ),
                SizedBox(height: 12.h),
                _buildSectionTile(
                  icon: Icons.menu_book_rounded,
                  color: const Color(0xFF6A1B9A),
                  bgColor: const Color(0xFFF3E5F5),
                  title: "Academic Reading Module Test",
                  duration: "60 Minutes • 3 Passages • 40 Questions",
                  bandScore: "Target: Band 8.0",
                  prevResult: progressCtrl.getLatestTestResult("Reading"),
                  onTap: () {
                    Get.to(() => const IeltsReadingPracticeScreen(
                      passageTitle: "Cambridge Mock Test 1 - Academic Passage",
                      passageText: "The Technological Evolution of Renewable Energy grids across European metropolitan centers.",
                      difficulty: "Challenging (Band 8.0)",
                    ));
                  },
                ),
                SizedBox(height: 12.h),
                _buildSectionTile(
                  icon: Icons.edit_note_rounded,
                  color: const Color(0xFFE65100),
                  bgColor: const Color(0xFFFFF3E0),
                  title: "Writing Module Test (Task 1 & 2)",
                  duration: "60 Minutes • 2 Tasks • Min 400 Words",
                  bandScore: "Target: Band 7.5",
                  prevResult: progressCtrl.getLatestTestResult("Writing"),
                  onTap: () => Get.find<NavBarController>().changeTab(1),
                ),
                SizedBox(height: 12.h),
                _buildSectionTile(
                  icon: Icons.mic_rounded,
                  color: const Color(0xFF0284C7),
                  bgColor: const Color(0xFFE0F2FE),
                  title: "Speaking Interview Simulator",
                  duration: "11-14 Minutes • Part 1, 2 & 3",
                  bandScore: "Target: Band 8.0",
                  prevResult: progressCtrl.getLatestTestResult("Speaking"),
                  onTap: () => Get.find<NavBarController>().changeTab(1),
                ),
              ],
            )),

            SizedBox(height: 28.h),

            // Performance History
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Mock Exam Score History",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Obx(() => Text(
                  "${progressCtrl.testHistory.length} Tests Logged",
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                )),
              ],
            ),
            SizedBox(height: 14.h),

            Obx(() {
              final history = progressCtrl.testHistory;
              if (history.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Center(child: Text("No mock tests recorded yet.", style: TextStyle(color: Color(0xFF64748B)))),
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
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.analytics_outlined, color: Color(0xFF312E81), size: 20),
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
                            color: const Color(0xFFE0E7FF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Band ${item.bandScore}",
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF312E81)),
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
            child: Icon(icon, color: color, size: 24),
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
                          "✓ Band ${prevResult.bandScore}",
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
                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}