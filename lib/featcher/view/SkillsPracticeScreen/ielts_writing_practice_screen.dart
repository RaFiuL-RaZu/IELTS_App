import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/services/ielts_local_storage_service.dart';
import 'package:justtsham/core/services/ielts_gemini_ai_service.dart';

class IeltsWritingPracticeScreen extends StatefulWidget {
  final String taskType;
  final String prompt;
  final String band9Model;
  final String structure;
  final String lexical;

  const IeltsWritingPracticeScreen({
    super.key,
    required this.taskType,
    required this.prompt,
    required this.band9Model,
    required this.structure,
    required this.lexical,
  });

  @override
  State<IeltsWritingPracticeScreen> createState() => _IeltsWritingPracticeScreenState();
}

class _IeltsWritingPracticeScreenState extends State<IeltsWritingPracticeScreen> {
  final TextEditingController _essayController = TextEditingController();
  int _wordCount = 0;
  int _secondsRemaining = 2400; // 40 mins
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _essayController.dispose();
    super.dispose();
  }

  void _calculateWords(String text) {
    final words = text.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    setState(() {
      _wordCount = words.length;
    });
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  Future<void> _evaluateAndShowResults() async {
    final text = _essayController.text.trim();
    final targetWords = widget.taskType.contains("Task 1") ? 150 : 250;
    final words = text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    final wordCount = words.length;

    if (wordCount < 20) {
      Get.snackbar(
        "Insufficient Content ⚠️",
        "Please write at least 20 words so Gemini AI can analyze your grammar, vocabulary, and cohesion.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEA580C),
        colorText: Colors.white,
      );
      return;
    }

    // Show AI Evaluator Loading Dialog
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF325E6A).withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Color(0xFF325E6A),
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                "🤖 Gemini AI Senior Examiner",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A)),
              ),
              SizedBox(height: 8.h),
              Text(
                "Analyzing Task Response, Cohesion, Lexical Resource & Grammar Accuracy...",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.5.sp, color: const Color(0xFF64748B), height: 1.45),
              ),
            ],
          ),
        ),
      ),
    );

    // Call Gemini AI
    final aiResult = await IeltsGeminiAiService.evaluateWriting(
      taskType: widget.taskType,
      prompt: widget.prompt,
      userEssay: text,
    );

    // Close loading dialog
    if (Get.isDialogOpen == true) {
      Get.back();
    }

    _showScoreEvaluationModal(
      aiResult: aiResult,
      wordCount: wordCount,
      targetWords: targetWords,
    );
  }

  void _showScoreEvaluationModal({
    required IeltsWritingAiResult aiResult,
    required int wordCount,
    required int targetWords,
  }) {
    final finalBand = aiResult.overallBand;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.88,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              Container(
                width: 44.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with Score & AI Badge
                      Center(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFF325E6A).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.auto_awesome, color: Color(0xFF325E6A), size: 14),
                                  SizedBox(width: 6.w),
                                  const Text(
                                    "Evaluated by Gemini 3.6 Flash AI",
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF325E6A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  finalBand.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 46,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF325E6A),
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  "/ 9.0 Band",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                            Text(
                              finalBand >= 7.5 ? "Excellent Academic Demonstration! 🌟" : "Good Attempt. Review AI feedback to reach 8.0+! 🚀",
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF4B5563)),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // 4 Criteria Breakdown Grid
                      const Text(
                        "Assessment Criteria Breakdown",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF111827)),
                      ),
                      SizedBox(height: 12.h),

                      _buildCriterionRow("Task Achievement (TA)", aiResult.taskAchievement, "$wordCount / $targetWords Words"),
                      _buildCriterionRow("Coherence & Cohesion (CC)", aiResult.coherenceCohesion, "Structure & Flow"),
                      _buildCriterionRow("Lexical Resource (LR)", aiResult.lexicalResource, "Academic Collocations"),
                      _buildCriterionRow("Grammatical Range (GRA)", aiResult.grammarAccuracy, "Syntax & Variety"),

                      SizedBox(height: 18.h),

                      // AI Examiner Summary
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFF325E6A).withOpacity(0.06),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF325E6A).withOpacity(0.18)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.psychology_rounded, color: Color(0xFF325E6A), size: 20),
                                SizedBox(width: 8),
                                Text(
                                  "Examiner Evaluation Summary",
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF325E6A)),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              aiResult.examinerSummary,
                              style: const TextStyle(fontSize: 12.5, height: 1.45, color: Color(0xFF1E293B)),
                            ),
                          ],
                        ),
                      ),

                      // Grammar & Sentence Corrections
                      if (aiResult.grammarCorrections.isNotEmpty) ...[
                        SizedBox(height: 14.h),
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFBEB),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFFDE68A)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.spellcheck_rounded, color: Color(0xFFD97706), size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    "Grammar & Sentence Corrections",
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFFB45309)),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              ...aiResult.grammarCorrections.map((g) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("• ", style: TextStyle(color: Color(0xFFD97706), fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                        g,
                                        style: const TextStyle(fontSize: 12, height: 1.4, color: Color(0xFF78350F)),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          ),
                        ),
                      ],

                      // Academic Vocabulary Upgrades
                      if (aiResult.vocabularyUpgrades.isNotEmpty) ...[
                        SizedBox(height: 14.h),
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFBBF7D0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.auto_stories_rounded, color: Color(0xFF16A34A), size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    "Band 8.5+ Academic Vocabulary Upgrades",
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF15803D)),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              ...aiResult.vocabularyUpgrades.map((v) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("• ", style: TextStyle(color: Color(0xFF16A34A), fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                        v,
                                        style: const TextStyle(fontSize: 12, height: 1.4, color: Color(0xFF14532D)),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          ),
                        ),
                      ],

                      // Actionable Improvement Tips
                      if (aiResult.actionableTips.isNotEmpty) ...[
                        SizedBox(height: 14.h),
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.tips_and_updates_outlined, color: Color(0xFF325E6A), size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    "Actionable Tips to Increase Score",
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF325E6A)),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              ...aiResult.actionableTips.map((t) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("• ", style: TextStyle(color: Color(0xFF325E6A), fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                        t,
                                        style: const TextStyle(fontSize: 12, height: 1.4, color: Color(0xFF334155)),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          ),
                        ),
                      ],

                      SizedBox(height: 24.h),

                      // Action Button
                      GestureDetector(
                        onTap: () {
                          if (Get.isRegistered<IeltsProgressController>()) {
                            final ctrl = IeltsProgressController.to;
                            ctrl.writingTaskDone.value = true;
                            ctrl.writingBand.value = finalBand;
                            ctrl.addTestResult(
                              skill: "Writing",
                              testName: widget.taskType,
                              score: wordCount,
                              totalQuestions: targetWords,
                              bandScore: finalBand,
                            );
                            ctrl.saveToLocalStorage();
                          }
                          Navigator.pop(ctx);
                          Get.back();
                          Get.snackbar(
                            "AI Evaluation Saved! 🤖",
                            "Band ${finalBand.toStringAsFixed(1)} saved to dashboard and daily checklist updated!",
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: const Color(0xFF325E6A),
                            colorText: Colors.white,
                            duration: const Duration(seconds: 3),
                          );
                        },
                        child: Container(
                          height: 48.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF325E6A),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF325E6A).withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              "Save Score & Update Dashboard",
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(height: 10.h),
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

  Widget _buildCriterionRow(String label, double score, String detail) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1F2937))),
              Text("Band ${score.toStringAsFixed(1)}", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF00695C))),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: score / 9.0,
                    minHeight: 6,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      score >= 7.5 ? const Color(0xFF00695C) : (score >= 6.0 ? const Color(0xFF0284C7) : const Color(0xFFEA580C)),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Text(detail, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.grey.shade600)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final targetWords = widget.taskType.contains("Task 1") ? 150 : 250;
    final isTargetMet = _wordCount >= targetWords;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF111827), size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          widget.taskType,
          style: const TextStyle(
            color: Color(0xFF111827),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status & Timer Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.timer_outlined, size: 18, color: Color(0xFFE65100)),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        _formatTime(_secondsRemaining),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFE65100),
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: isTargetMet ? const Color(0xFFE0F2F1) : const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "$_wordCount / $targetWords Words ${isTargetMet ? '✅' : ''}",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isTargetMet ? const Color(0xFF00695C) : const Color(0xFFE65100),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Prompt Card
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    offset: const Offset(0, 3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.assignment_outlined, color: Color(0xFFE65100), size: 18),
                      SizedBox(width: 6),
                      Text(
                        "Official Essay Prompt",
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFFE65100)),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    widget.prompt,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111827),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Writing Text Area
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    offset: const Offset(0, 3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: TextField(
                controller: _essayController,
                onChanged: _calculateWords,
                maxLines: 14,
                style: const TextStyle(fontSize: 14, height: 1.55, color: Color(0xFF1F2937)),
                decoration: InputDecoration(
                  hintText: "Type your introductory paragraph, body arguments, and conclusion here...",
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16.w),
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Band 9 Architecture & Model Answer Collapsible
            ExpansionTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Color(0xFFE5E7EB))),
              collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Color(0xFFE5E7EB))),
              backgroundColor: Colors.white,
              collapsedBackgroundColor: Colors.white,
              title: const Text(
                "💡 View Band 9 Architecture & Model Essay",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF00695C)),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("📐 Structural Blueprint:", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF111827))),
                      SizedBox(height: 4.h),
                      Text(widget.structure, style: const TextStyle(fontSize: 12, color: Color(0xFF4B5563), height: 1.4)),
                      SizedBox(height: 12.h),
                      const Text("✨ Key Lexical Collocations:", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF00695C))),
                      SizedBox(height: 4.h),
                      Text(widget.lexical, style: const TextStyle(fontSize: 12, color: Color(0xFF00695C), fontStyle: FontStyle.italic)),
                      SizedBox(height: 12.h),
                      const Text("📝 Band 9.0 Sample Essay:", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF111827))),
                      SizedBox(height: 6.h),
                      Text(widget.band9Model, style: const TextStyle(fontSize: 13, color: Color(0xFF374151), height: 1.5)),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Submit Button
            GestureDetector(
              onTap: _evaluateAndShowResults,
              child: Container(
                height: 48.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF00695C),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00695C).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    "Save & Evaluate Essay",
                    style: TextStyle(
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
}
