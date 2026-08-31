import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/data/ielts_data.dart';

class IeltsVocabularyScreen extends StatefulWidget {
  const IeltsVocabularyScreen({super.key});

  @override
  State<IeltsVocabularyScreen> createState() => _IeltsVocabularyScreenState();
}

class _IeltsVocabularyScreenState extends State<IeltsVocabularyScreen> {
  int _selectedTopicIndex = 0;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topics = IeltsData.wordFamilyTopics;
    final currentTopic = topics[_selectedTopicIndex.clamp(0, topics.length - 1)];

    // Filtered words based on search
    final filteredWords = _searchQuery.trim().isEmpty
        ? currentTopic.words
        : currentTopic.words.where((wf) {
            final q = _searchQuery.toLowerCase();
            return wf.noun.toLowerCase().contains(q) ||
                wf.verb.toLowerCase().contains(q) ||
                wf.adjective.toLowerCase().contains(q) ||
                wf.adverb.toLowerCase().contains(q);
          }).toList();

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
          "IELTS Vocabulary Bank",
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
          // 1. Search Bar
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: "Search noun, verb, adjective, adverb...",
                hintStyle: TextStyle(fontSize: 13.sp, color: const Color(0xFF94A3B8)),
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF00695C), size: 22),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18, color: Color(0xFF94A3B8)),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = "");
                        },
                      )
                    : null,
                contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                filled: true,
                fillColor: const Color(0xFFF1F5F9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 2. Horizontal Topic Filter Pills (17 Topics)
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(bottom: 12.h),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: List.generate(topics.length, (index) {
                  final isSelected = _selectedTopicIndex == index;
                  final topic = topics[index];

                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTopicIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF00695C) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF00695C) : const Color(0xFFE2E8F0),
                            width: isSelected ? 1.5 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF00695C).withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          topic.topicName,
                          style: TextStyle(
                            fontSize: 12.5.sp,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            color: isSelected ? Colors.white : const Color(0xFF475569),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // 3. Topic Sub-header Banner
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 10.h),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                colors: [Color(0xFF004D40), Color(0xFF00695C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${currentTopic.topicName} Word Families",
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Noun • Verb • Adjective • Adverb",
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        color: const Color(0xFFB2DFDB),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${filteredWords.length} Sets",
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 4. Cards List
          Expanded(
            child: filteredWords.isEmpty
                ? Center(
                    child: Text(
                      "No matching words found for \"$_searchQuery\"",
                      style: TextStyle(fontSize: 13.sp, color: const Color(0xFF94A3B8)),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
                    itemCount: filteredWords.length,
                    itemBuilder: (context, index) {
                      final wf = filteredWords[index];
                      return _buildWordFamilyCard(wf);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordFamilyCard(IeltsWordFamily wf) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Noun Form (Blue Badge)
              Expanded(
                child: _buildFormCell(
                  label: "Noun",
                  value: wf.noun,
                  badgeBg: const Color(0xFFE0F2FE),
                  badgeColor: const Color(0xFF0369A1),
                ),
              ),
              SizedBox(width: 8.w),
              // Verb Form (Green Badge)
              Expanded(
                child: _buildFormCell(
                  label: "Verb",
                  value: wf.verb,
                  badgeBg: const Color(0xFFD1FAE5),
                  badgeColor: const Color(0xFF047857),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Adjective Form (Amber Badge)
              Expanded(
                child: _buildFormCell(
                  label: "Adjective",
                  value: wf.adjective,
                  badgeBg: const Color(0xFFFEF3C7),
                  badgeColor: const Color(0xFFB45309),
                ),
              ),
              SizedBox(width: 8.w),
              // Adverb Form (Purple Badge)
              Expanded(
                child: _buildFormCell(
                  label: "Adverb",
                  value: wf.adverb,
                  badgeBg: const Color(0xFFEDE9FE),
                  badgeColor: const Color(0xFF6D28D9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormCell({
    required String label,
    required String value,
    required Color badgeBg,
    required Color badgeColor,
  }) {
    String cleanText = value.trim();
    if (cleanText == "-" || cleanText == "—" || cleanText.isEmpty || cleanText.contains("â")) {
      cleanText = "-";
    }
    final isNone = cleanText == "-";

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w800,
                color: badgeColor,
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            cleanText,
            style: TextStyle(
              fontSize: 12.5.sp,
              fontWeight: isNone ? FontWeight.normal : FontWeight.w700,
              color: isNone ? const Color(0xFF94A3B8) : const Color(0xFF0F172A),
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}
