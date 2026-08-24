import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/services/ielts_local_storage_service.dart';
import 'package:justtsham/core/widgets/common_text.dart';
import 'package:justtsham/featcher/controller/AuthController/navber_controller.dart';
import 'package:justtsham/featcher/view/HomeScreen/ielts_band_calculator_modal.dart';
import 'package:justtsham/featcher/view/HomeScreen/ielts_grammar_screen.dart';
import 'package:justtsham/featcher/view/HomeScreen/ielts_vocabulary_screen.dart';
import 'package:justtsham/featcher/view/HomeScreen/notification_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 4 && hour < 12) return "Good Morning";
    if (hour >= 12 && hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  @override
  Widget build(BuildContext context) {
    final progressCtrl = Get.find<IeltsProgressController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70.h,
        titleSpacing: 20.w,
        title: Row(
          children: [
            Container(
              height: 46.h,
              width: 46.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF004D40), Color(0xFF00796B)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00796B).withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Text("🎓", style: TextStyle(fontSize: 22)),
              ),
            ),
            SizedBox(width: 14.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
                SizedBox(height: 2.h),
                Obx(() => Text(
                  progressCtrl.candidateName.value,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                )),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: IconButton(
              onPressed: () => Get.to(() => const NotificationScreen()),
              icon: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.notifications_none_rounded, color: Color(0xFF0F172A), size: 22),
                  ),
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      height: 8,
                      width: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE53935),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 18.h, bottom: 100.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Goal & Predicted Band Card
            Obx(() {
              final overallBand = progressCtrl.overallBand.value;
              final targetBand = progressCtrl.targetBand.value;
              final days = progressCtrl.examDaysRemaining.value;
              final accuracy = progressCtrl.overallAccuracy.value;

              return Container(
                width: double.infinity,
                padding: EdgeInsets.all(22.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00382E), Color(0xFF005A4E), Color(0xFF00796B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF004D40).withOpacity(0.28),
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
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "🎯 Target: Band $targetBand",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "⏳ $days Days Left",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF80CBC4),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Predicted Band",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFB2DFDB),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    overallBand.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontSize: 38,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: -1,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    "/ 9.0",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF80CBC4),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                "Overall Accuracy: $accuracy%",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFE0F2F1),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => IeltsBandCalculatorModal.show(context),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withOpacity(0.35)),
                            ),
                            child: Column(
                              children: const [
                                Icon(Icons.calculate_rounded, color: Colors.white, size: 24),
                                SizedBox(height: 4),
                                Text(
                                  "Calculator",
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),

            SizedBox(height: 26.h),

            // 2. Four-Skill Performance Breakdown (Clean 2x2 Grid)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    "Skill Band & Accuracy",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.find<NavBarController>().changeTab(1),
                  child: const Text(
                    "View All Practice",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF00695C)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),

            // 2x2 Spacious Skill Cards
            Obx(() => Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildSpaciousSkillCard(
                        title: "Listening",
                        icon: Icons.headset_rounded,
                        band: progressCtrl.listeningBand.value,
                        accuracy: progressCtrl.listeningAccuracy.value,
                        color: const Color(0xFF00695C),
                        bgColor: const Color(0xFFE0F2F1),
                        onTap: () => Get.find<NavBarController>().changeTab(1),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildSpaciousSkillCard(
                        title: "Reading",
                        icon: Icons.menu_book_rounded,
                        band: progressCtrl.readingBand.value,
                        accuracy: progressCtrl.readingAccuracy.value,
                        color: const Color(0xFF6A1B9A),
                        bgColor: const Color(0xFFF3E5F5),
                        onTap: () => Get.find<NavBarController>().changeTab(1),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildSpaciousSkillCard(
                        title: "Writing",
                        icon: Icons.edit_note_rounded,
                        band: progressCtrl.writingBand.value,
                        accuracy: progressCtrl.writingAccuracy.value,
                        color: const Color(0xFFE65100),
                        bgColor: const Color(0xFFFFF3E0),
                        onTap: () => Get.find<NavBarController>().changeTab(1),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildSpaciousSkillCard(
                        title: "Speaking",
                        icon: Icons.mic_rounded,
                        band: progressCtrl.speakingBand.value,
                        accuracy: progressCtrl.speakingAccuracy.value,
                        color: const Color(0xFF0284C7),
                        bgColor: const Color(0xFFE0F2FE),
                        onTap: () => Get.find<NavBarController>().changeTab(1),
                      ),
                    ),
                  ],
                ),
              ],
            )),

            SizedBox(height: 28.h),

            // 3. Today's Study Checklist (Spacious & Clean)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    "Today's Study Checklist",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
                Obx(() {
                  final completed = [
                    progressCtrl.speakingTaskDone.value,
                    progressCtrl.listeningTaskDone.value,
                    progressCtrl.readingTaskDone.value,
                    progressCtrl.writingTaskDone.value,
                  ].where((d) => d).length;

                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2F1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "$completed / 4 Completed",
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF00695C),
                      ),
                    ),
                  );
                }),
              ],
            ),
            SizedBox(height: 14.h),

            Obx(() => Column(
              children: [
                _buildChecklistTile(
                  icon: Icons.mic_rounded,
                  iconColor: const Color(0xFF00695C),
                  iconBg: const Color(0xFFE0F2F1),
                  title: "Speaking: Part 2 Cue Card",
                  subtitle: "1-min prep timer with voice recording",
                  isDone: progressCtrl.speakingTaskDone.value,
                  onToggle: () => progressCtrl.toggleSpeakingTask(),
                  onAction: () => Get.find<NavBarController>().changeTab(1),
                ),
                SizedBox(height: 10.h),
                _buildChecklistTile(
                  icon: Icons.headset_rounded,
                  iconColor: const Color(0xFF2E7D32),
                  iconBg: const Color(0xFFE8F5E9),
                  title: "Listening: Cambridge Section 2",
                  subtitle: "Dialogue listening test with instant auto-scoring",
                  isDone: progressCtrl.listeningTaskDone.value,
                  onToggle: () => progressCtrl.toggleListeningTask(),
                  onAction: () => Get.find<NavBarController>().changeTab(1),
                ),
                SizedBox(height: 10.h),
                _buildChecklistTile(
                  icon: Icons.menu_book_rounded,
                  iconColor: const Color(0xFF6A1B9A),
                  iconBg: const Color(0xFFF3E5F5),
                  title: "Reading: 20-Min Timed Passage",
                  subtitle: "Passage 1: Renewable Tech & True/False/NG",
                  isDone: progressCtrl.readingTaskDone.value,
                  onToggle: () => progressCtrl.toggleReadingTask(),
                  onAction: () => Get.find<NavBarController>().changeTab(1),
                ),
                SizedBox(height: 10.h),
                _buildChecklistTile(
                  icon: Icons.edit_note_rounded,
                  iconColor: const Color(0xFFE65100),
                  iconBg: const Color(0xFFFFF3E0),
                  title: "Writing: Task 2 Essay Arena",
                  subtitle: "Opinion blueprint with live word counter",
                  isDone: progressCtrl.writingTaskDone.value,
                  onToggle: () => progressCtrl.toggleWritingTask(),
                  onAction: () => Get.find<NavBarController>().changeTab(1),
                ),
              ],
            )),

            SizedBox(height: 28.h),

            // 4. IELTS Mastery Powerbanks
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    "IELTS Mastery Powerbanks",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Band 8.5+ Boosters",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF2E7D32)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),

            Row(
              children: [
                // Vocab Card
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.to(() => const IeltsVocabularyScreen()),
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF004D40), Color(0xFF00695C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00695C).withOpacity(0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("📚", style: TextStyle(fontSize: 24)),
                          SizedBox(height: 10.h),
                          const Text(
                            "Vocabulary Bank",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                          SizedBox(height: 4.h),
                          const Text(
                            "Collocations & Lexical sets",
                            style: TextStyle(fontSize: 11, color: Color(0xFF80CBC4), fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                // Grammar Card
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.to(() => const IeltsGrammarScreen()),
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4A148C), Color(0xFF6A1B9A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6A1B9A).withOpacity(0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("📐", style: TextStyle(fontSize: 24)),
                          SizedBox(height: 10.h),
                          const Text(
                            "Grammar Range",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                          SizedBox(height: 4.h),
                          const Text(
                            "Band 9 Complex formulas",
                            style: TextStyle(fontSize: 11, color: Color(0xFFE1BEE7), fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 28.h),

            // 5. Recent Practice Activity Log (From Local Storage)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    "Recent Practice History",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
                const Text(
                  "Saved locally",
                  style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                ),
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
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.history_rounded, size: 36, color: Colors.grey.shade400),
                      SizedBox(height: 8.h),
                      const Text(
                        "No Practice Tests Yet",
                        style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF475569)),
                      ),
                      SizedBox(height: 4.h),
                      const Text(
                        "Complete a Listening, Reading, or Writing test to see your history here.",
                        style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: history.length > 5 ? 5 : history.length,
                itemBuilder: (context, index) {
                  final item = history[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 10.h),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
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
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            item.skill == "Listening"
                                ? Icons.headset_rounded
                                : (item.skill == "Reading" ? Icons.menu_book_rounded : Icons.edit_note_rounded),
                            color: const Color(0xFF00695C),
                            size: 22,
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.testName,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                "${item.date} • ${item.score}/${item.totalQuestions} marks (${item.accuracy}%)",
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
                            "Band ${item.bandScore}",
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
    );
  }

  Widget _buildSpaciousSkillCard({
    required String title,
    required IconData icon,
    required double band,
    required double accuracy,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
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
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Band $band",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: color),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
            ),
            SizedBox(height: 4.h),
            Text(
              "Accuracy: $accuracy%",
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
            ),
            SizedBox(height: 8.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: accuracy / 100.0,
                minHeight: 5,
                backgroundColor: const Color(0xFFF1F5F9),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required bool isDone,
    required VoidCallback onToggle,
    required VoidCallback onAction,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDone ? const Color(0xFF80CBC4) : const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 26.h,
              width: 26.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone ? const Color(0xFF00695C) : Colors.transparent,
                border: Border.all(
                  color: isDone ? const Color(0xFF00695C) : const Color(0xFFCBD5E1),
                  width: 2,
                ),
              ),
              child: isDone ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
            ),
          ),
          SizedBox(width: 14.w),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                    decoration: isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: onAction,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Start",
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF00695C)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
