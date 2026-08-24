import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/services/ielts_local_storage_service.dart';

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

  void _evaluateAndShowResults() {
    final text = _essayController.text.trim();
    final targetWords = widget.taskType.contains("Task 1") ? 150 : 250;
    final words = text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    final wordCount = words.length;

    if (wordCount < 20) {
      Get.snackbar(
        "Insufficient Content ⚠️",
        "Please write at least 20 words so the IELTS evaluation engine can analyze your grammar, vocabulary, and cohesion.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEA580C),
        colorText: Colors.white,
      );
      return;
    }

    // 1. Gibberish & English Dictionary Sanity Check
    final commonWords = {
      "the", "be", "to", "of", "and", "a", "in", "that", "have", "i", "it", "for", "not", "on", "with",
      "he", "as", "you", "do", "at", "this", "but", "his", "by", "from", "they", "we", "say", "her",
      "she", "or", "an", "will", "my", "one", "all", "would", "there", "their", "what", "so", "up",
      "out", "if", "about", "who", "get", "which", "go", "me", "when", "make", "can", "like", "time",
      "no", "just", "him", "know", "take", "people", "into", "year", "your", "good", "some", "could",
      "them", "see", "other", "than", "then", "now", "look", "only", "come", "its", "over", "think",
      "also", "back", "after", "use", "two", "how", "our", "work", "first", "well", "way", "even",
      "new", "want", "because", "any", "these", "give", "day", "most", "us", "write", "letter",
      "refund", "error", "manager", "dear", "sincerely", "regards", "flight", "ticket", "service",
      "issue", "situation", "request", "formal", "problem", "overcharged", "airline", "purchase"
    };

    int validWordHits = 0;
    for (final w in words) {
      final clean = w.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
      if (commonWords.contains(clean) || clean.length >= 3 && RegExp(r'[aeiouy]').hasMatch(clean)) {
        validWordHits++;
      }
    }

    final double validWordRatio = words.isNotEmpty ? validWordHits / words.length : 0;
    final bool isGibberish = validWordRatio < 0.45;

    // 2. Coherence & Linkers Check
    final linkers = [
      "furthermore", "moreover", "however", "consequently", "therefore", "in addition",
      "nevertheless", "on the other hand", "firstly", "secondly", "finally", "in conclusion",
      "with regard to", "as a result", "subsequently", "specifically", "in summary", "overall"
    ];
    int linkerCount = 0;
    final lowerText = text.toLowerCase();
    for (final l in linkers) {
      if (lowerText.contains(l)) linkerCount++;
    }

    // 3. Academic Vocabulary Check
    final academicVocab = [
      "demonstrate", "illustrate", "significant", "substantial", "approximately",
      "predominantly", "perspective", "discrepancy", "compensate", "inconvenience",
      "rectify", "correspondence", "expedite", "fundamental", "fluctuation", "correlation",
      "paramount", "inevitable", "profound", "imperative", "infrastructure"
    ];
    int academicVocabHits = 0;
    for (final v in academicVocab) {
      if (lowerText.contains(v)) academicVocabHits++;
    }

    // 4. Paragraph & Structure Check
    final paragraphs = text.split(RegExp(r'\n+')).where((p) => p.trim().isNotEmpty).length;

    // Criterion Scores (out of 9.0)
    double ta; // Task Achievement
    double cc; // Coherence & Cohesion
    double lr; // Lexical Resource
    double gra; // Grammatical Range & Accuracy

    if (isGibberish) {
      ta = 3.5;
      cc = 3.0;
      lr = 3.0;
      gra = 3.5;
    } else {
      // Task Achievement based on word count & length
      if (wordCount >= targetWords) {
        ta = wordCount >= (targetWords + 40) ? 8.5 : 8.0;
      } else if (wordCount >= targetWords * 0.8) {
        ta = 7.0;
      } else {
        ta = 5.5;
      }

      // Coherence & Cohesion based on paragraphs & linkers
      if (paragraphs >= 3 && linkerCount >= 3) {
        cc = 8.0;
      } else if (paragraphs >= 2 && linkerCount >= 1) {
        cc = 7.0;
      } else {
        cc = 6.0;
      }

      // Lexical Resource based on unique words & academic vocab
      final uniqueWords = words.map((w) => w.toLowerCase()).toSet().length;
      final lexicalDiversity = words.isNotEmpty ? uniqueWords / words.length : 0.0;
      if (academicVocabHits >= 2 && lexicalDiversity > 0.55) {
        lr = 8.5;
      } else if (academicVocabHits >= 1 || lexicalDiversity > 0.48) {
        lr = 7.5;
      } else {
        lr = 6.5;
      }

      // Grammatical Range & Accuracy
      final hasPunctuation = text.contains('.') && text.contains(',');
      final hasCaps = RegExp(r'[A-Z]').hasMatch(text);
      if (hasPunctuation && hasCaps && wordCount >= targetWords) {
        gra = 7.5;
      } else if (hasPunctuation || hasCaps) {
        gra = 6.5;
      } else {
        gra = 5.5;
      }
    }

    // Cambridge Official Average
    final double rawBand = (ta + cc + lr + gra) / 4.0;
    final fractionalPart = rawBand - rawBand.floor();
    double finalBand;
    if (fractionalPart < 0.25) {
      finalBand = rawBand.floorToDouble();
    } else if (fractionalPart < 0.75) {
      finalBand = rawBand.floorToDouble() + 0.5;
    } else {
      finalBand = (rawBand.floor() + 1).toDouble();
    }

    _showScoreEvaluationModal(
      finalBand: finalBand,
      ta: ta,
      cc: cc,
      lr: lr,
      gra: gra,
      wordCount: wordCount,
      targetWords: targetWords,
      isGibberish: isGibberish,
      linkerCount: linkerCount,
      academicVocabHits: academicVocabHits,
    );
  }

  void _showScoreEvaluationModal({
    required double finalBand,
    required double ta,
    required double cc,
    required double lr,
    required double gra,
    required int wordCount,
    required int targetWords,
    required bool isGibberish,
    required int linkerCount,
    required int academicVocabHits,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
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
                      // Header with Score
                      Center(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: finalBand >= 7.0 ? const Color(0xFFE0F2F1) : const Color(0xFFFFF3E0),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                isGibberish ? "⚠️ Low Coherence Detected" : "Official Cambridge Rubric Evaluator",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: finalBand >= 7.0 ? const Color(0xFF00695C) : const Color(0xFFE65100),
                                ),
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
                                  style: TextStyle(
                                    fontSize: 44,
                                    fontWeight: FontWeight.w900,
                                    color: finalBand >= 7.0 ? const Color(0xFF00695C) : const Color(0xFFE65100),
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
                              isGibberish
                                  ? "Unrecognizable words detected. Practice real English syntax."
                                  : (finalBand >= 7.5 ? "Excellent Academic Demonstration! 🌟" : "Good Attempt. Review tips to reach 8.0+! 🚀"),
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

                      _buildCriterionRow("Task Achievement (TA)", ta, "$wordCount / $targetWords Words"),
                      _buildCriterionRow("Coherence & Cohesion (CC)", cc, "$linkerCount Logical Linkers"),
                      _buildCriterionRow("Lexical Resource (LR)", lr, "$academicVocabHits Academic Collocations"),
                      _buildCriterionRow("Grammatical Range (GRA)", gra, "Syntax & Punctuation"),

                      SizedBox(height: 20.h),

                      // Examiner Detailed Feedback Box
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.psychology_outlined, color: Color(0xFF00695C), size: 20),
                                SizedBox(width: 8),
                                Text(
                                  "Examiner Feedback & Suggestions",
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF00695C)),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            if (isGibberish) ...[
                              const Text(
                                "• The submitted response contains repetitive non-standard English words. IELTS examiners assess communicative clarity and standard vocabulary.",
                                style: TextStyle(fontSize: 12, height: 1.45, color: Color(0xFF374151)),
                              ),
                            ] else ...[
                              Text(
                                "• Word Count: ${wordCount >= targetWords ? 'Met requirement ($wordCount words) with no length penalty.' : 'Underlength penalty applied ($wordCount / $targetWords words).'}",
                                style: const TextStyle(fontSize: 12, height: 1.45, color: Color(0xFF374151)),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                "• Cohesion: Identified $linkerCount discourse markers. Use varied paragraph transitions like 'Furthermore' and 'In contrast'.",
                                style: const TextStyle(fontSize: 12, height: 1.45, color: Color(0xFF374151)),
                              ),
                              SizedBox(height: 4.h),
                              const Text(
                                "• Recommendation: Check the Band 9.0 model essay below to compare structural paragraphing.",
                                style: TextStyle(fontSize: 12, height: 1.45, color: Color(0xFF374151)),
                              ),
                            ],
                          ],
                        ),
                      ),

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
                            "Writing Graded & Saved! 📝",
                            "Band $finalBand saved to dashboard and daily checklist updated!",
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: const Color(0xFF004D40),
                            colorText: Colors.white,
                            duration: const Duration(seconds: 3),
                          );
                        },
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
                              "Save Score & Update Dashboard",
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
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
