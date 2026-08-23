import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/data/ielts_data.dart';
import 'package:justtsham/core/widgets/common_text.dart';

class IeltsBandDescriptorsScreen extends StatelessWidget {
  const IeltsBandDescriptorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF00897B), size: 20),
          onPressed: () => Get.back(),
        ),
        title: CommonText(
          title: "Official IELTS Band Descriptors",
          fSize: 18,
          fWeight: FontWeight.w700,
          color: const Color(0xFF00897B),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        itemCount: IeltsData.bandDescriptors.length,
        itemBuilder: (context, index) {
          final item = IeltsData.bandDescriptors[index];
          return Container(
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                initiallyExpanded: index == 0,
                tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                leading: Container(
                  width: 48.w,
                  height: 48.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2F1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF80CBC4)),
                  ),
                  child: Text(
                    "Band ${item.band}",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF00695C),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                title: Text(
                  item.level,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),
                subtitle: const Text(
                  "Tap to view detailed assessment criteria",
                  style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(color: Color(0xFFE5E7EB)),
                        SizedBox(height: 8.h),
                        _buildCriteriaBlock("Fluency & Coherence", item.fluency, Icons.record_voice_over),
                        SizedBox(height: 10.h),
                        _buildCriteriaBlock("Lexical Resource (Vocabulary)", item.lexical, Icons.menu_book),
                        SizedBox(height: 10.h),
                        _buildCriteriaBlock("Grammatical Range & Accuracy", item.grammar, Icons.spellcheck),
                        SizedBox(height: 10.h),
                        _buildCriteriaBlock("Pronunciation", item.pronunciation, Icons.volume_up),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCriteriaBlock(String title, String description, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: const Color(0xFF00897B)),
            SizedBox(width: 6.w),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF00897B),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          description,
          style: const TextStyle(
            fontSize: 12,
            height: 1.4,
            color: Color(0xFF4B5563),
          ),
        ),
      ],
    );
  }
}
