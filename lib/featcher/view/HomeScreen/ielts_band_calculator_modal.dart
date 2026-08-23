import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/data/ielts_data.dart';
import 'package:justtsham/core/widgets/common_text.dart';

class IeltsBandCalculatorModal extends StatefulWidget {
  const IeltsBandCalculatorModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const IeltsBandCalculatorModal(),
    );
  }

  @override
  State<IeltsBandCalculatorModal> createState() => _IeltsBandCalculatorModalState();
}

class _IeltsBandCalculatorModalState extends State<IeltsBandCalculatorModal> {
  double speakingScore = 7.0;
  double listeningScore = 7.5;
  double readingScore = 7.0;
  double writingScore = 6.5;

  double get overallBand => IeltsData.calculateOverallBand(
        speaking: speakingScore,
        listening: listeningScore,
        reading: readingScore,
        writing: writingScore,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            height: 5,
            width: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFD1D5DB),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(height: 16.h),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    title: "IELTS Band Calculator",
                    fSize: 20,
                    fWeight: FontWeight.w800,
                    color: const Color(0xFF111827),
                  ),
                  Text(
                    "Official IELTS score calculation formula",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Get.back(),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Calculated Overall Band Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFF00695C), Color(0xFF00897B)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00897B).withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "PREDICTED OVERALL BAND",
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFB2DFDB),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Target Met for Global Universities",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    overallBand.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF00695C),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // 4 Score Sliders
          _buildScoreSelector("Speaking", speakingScore, (val) => setState(() => speakingScore = val)),
          _buildScoreSelector("Listening", listeningScore, (val) => setState(() => listeningScore = val)),
          _buildScoreSelector("Reading", readingScore, (val) => setState(() => readingScore = val)),
          _buildScoreSelector("Writing", writingScore, (val) => setState(() => writingScore = val)),

          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildScoreSelector(String label, double value, Function(double) onChanged) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF374151),
              ),
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: const Color(0xFF00897B),
                inactiveTrackColor: const Color(0xFFE0E0E0),
                thumbColor: const Color(0xFF00897B),
                overlayColor: const Color(0xFF00897B).withOpacity(0.2),
                trackHeight: 4,
              ),
              child: Slider(
                value: value,
                min: 4.0,
                max: 9.0,
                divisions: 10,
                onChanged: onChanged,
              ),
            ),
          ),
          Container(
            width: 44.w,
            height: 32.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFB2DFDB)),
            ),
            child: Text(
              value.toStringAsFixed(1),
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFF00695C),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
