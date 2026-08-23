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
              onTap: () {
                if (_wordCount < targetWords) {
                  Get.snackbar(
                    "Word Count Notice ⚠️",
                    "Your essay currently has $_wordCount words. Aim for at least $targetWords words to avoid Task Achievement penalties.",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: const Color(0xFFEA580C),
                    colorText: Colors.white,
                  );
                } else {
                  final double band = _wordCount >= 260 ? 8.0 : 7.0;
                  if (Get.isRegistered<IeltsProgressController>()) {
                    IeltsProgressController.to.addTestResult(
                      skill: "Writing",
                      testName: widget.taskType,
                      score: _wordCount,
                      totalQuestions: targetWords,
                      bandScore: band,
                    );
                  }
                  Get.snackbar(
                    "Essay Submitted! 🎉",
                    "Word count: $_wordCount words • Band $band saved to dashboard!",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: const Color(0xFF00695C),
                    colorText: Colors.white,
                  );
                }
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
