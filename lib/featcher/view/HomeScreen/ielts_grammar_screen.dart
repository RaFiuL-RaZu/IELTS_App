import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/data/ielts_data.dart';

class IeltsGrammarScreen extends StatefulWidget {
  const IeltsGrammarScreen({super.key});

  @override
  State<IeltsGrammarScreen> createState() => _IeltsGrammarScreenState();
}

class _IeltsGrammarScreenState extends State<IeltsGrammarScreen> {
  String _selectedCategory = "All Topics";
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();
  final Set<int> _expandedTopicIds = {};

  final List<String> _categories = [
    "All Topics",
    "Foundation",
    "Tense & Verb",
    "Advanced Sentence",
    "IELTS Writing & Speaking",
  ];

  @override
  void initState() {
    super.initState();
    // Expand first 2 topics by default for instant reading
    _expandedTopicIds.addAll([1, 2]);
  }

  void _toggleTopic(int id) {
    setState(() {
      if (_expandedTopicIds.contains(id)) {
        _expandedTopicIds.remove(id);
      } else {
        _expandedTopicIds.add(id);
      }
    });
  }

  void _toggleExpandAll(List<GrammarTopicItem> topics) {
    setState(() {
      if (_expandedTopicIds.length == topics.length) {
        _expandedTopicIds.clear();
      } else {
        _expandedTopicIds.addAll(topics.map((t) => t.id));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final allTopics = IeltsData.specificGrammarTopics;

    final filteredTopics = allTopics.where((topic) {
      bool matchesCategory = true;
      if (_selectedCategory != "All Topics") {
        matchesCategory = topic.category == _selectedCategory;
      }

      final query = _searchQuery.toLowerCase();
      if (query.isEmpty) return matchesCategory;

      final matchesTopic = topic.title.toLowerCase().contains(query) ||
          topic.category.toLowerCase().contains(query);

      final matchesSubItems = topic.subItems.any((sub) =>
          sub.name.toLowerCase().contains(query) ||
          sub.rule.toLowerCase().contains(query) ||
          sub.examples.any((ex) => ex.toLowerCase().contains(query)));

      return matchesCategory && (matchesTopic || matchesSubItems);
    }).toList();

    final isAllExpanded = filteredTopics.isNotEmpty &&
        filteredTopics.every((t) => _expandedTopicIds.contains(t.id));

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 65.h,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "IELTS Grammar Rules",
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: filteredTopics.isEmpty ? null : () => _toggleExpandAll(filteredTopics),
            icon: Icon(
              isAllExpanded ? Icons.unfold_less_rounded : Icons.unfold_more_rounded,
              size: 18,
              color: const Color(0xFF00695C),
            ),
            label: Text(
              isAllExpanded ? "Collapse" : "Expand",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Color(0xFF00695C),
              ),
            ),
          ),
          SizedBox(width: 8.w),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header Search & Category Filter Section
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 10.h, bottom: 12.h),
            child: Column(
              children: [
                // Search Input
                Container(
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val.trim();
                        if (_searchQuery.isNotEmpty) {
                          _expandedTopicIds.addAll(filteredTopics.map((t) => t.id));
                        }
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Search topics, Noun, Pronoun, Tenses, Rules...",
                      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                      prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18, color: Color(0xFF64748B)),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = "";
                                });
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

                // Category Selector Pills
                SizedBox(
                  height: 38.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (context, index) => SizedBox(width: 8.w),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = _selectedCategory == cat;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = cat;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF00695C) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF004D40) : const Color(0xFFE2E8F0),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              cat,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                color: isSelected ? Colors.white : const Color(0xFF475569),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Topics List
          Expanded(
            child: filteredTopics.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 70.h,
                          width: 70.h,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF1F5F9),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(Icons.menu_book_outlined, color: Color(0xFF94A3B8), size: 32),
                          ),
                        ),
                        SizedBox(height: 14.h),
                        const Text(
                          "No grammar topics found",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF334155)),
                        ),
                        SizedBox(height: 4.h),
                        const Text(
                          "Try searching for another topic keyword.",
                          style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    itemCount: filteredTopics.length,
                    itemBuilder: (context, index) {
                      final topic = filteredTopics[index];
                      final isExpanded = _expandedTopicIds.contains(topic.id);

                      return Container(
                        margin: EdgeInsets.only(bottom: 16.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isExpanded ? const Color(0xFF00695C).withOpacity(0.4) : const Color(0xFFE2E8F0),
                            width: isExpanded ? 1.5 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isExpanded ? const Color(0xFF00695C).withOpacity(0.06) : Colors.black.withOpacity(0.02),
                              offset: const Offset(0, 4),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Topic Header (Clickable Accordion)
                            InkWell(
                              onTap: () => _toggleTopic(topic.id),
                              borderRadius: BorderRadius.circular(20),
                              child: Padding(
                                padding: EdgeInsets.all(16.w),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFE0F2F1),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  topic.category,
                                                  style: const TextStyle(
                                                    fontSize: 10.5,
                                                    fontWeight: FontWeight.w800,
                                                    color: Color(0xFF00695C),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8.w),
                                              Text(
                                                "${topic.subItems.length} items",
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF94A3B8),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8.h),
                                          Text(
                                            topic.title,
                                            style: TextStyle(
                                              fontSize: 17.sp,
                                              fontWeight: FontWeight.w800,
                                              color: const Color(0xFF0F172A),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 32.h,
                                      width: 32.h,
                                      decoration: BoxDecoration(
                                        color: isExpanded ? const Color(0xFF00695C) : const Color(0xFFF1F5F9),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                                        color: isExpanded ? Colors.white : const Color(0xFF475569),
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Sub-items List (When Expanded)
                            if (isExpanded) ...[
                              const Divider(height: 1, color: Color(0xFFE2E8F0)),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.all(16.w),
                                itemCount: topic.subItems.length,
                                separatorBuilder: (context, idx) => SizedBox(height: 16.h),
                                itemBuilder: (context, idx) {
                                  final item = topic.subItems[idx];

                                  return Container(
                                    padding: EdgeInsets.all(14.w),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF8FAFC),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: const Color(0xFFE2E8F0)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Sub-Item Title
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF00695C),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            item.name,
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                              height: 1.3,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10.h),

                                        // Rule
                                        RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              color: const Color(0xFF334155),
                                              height: 1.4,
                                            ),
                                            children: [
                                              const TextSpan(
                                                text: "Rule: ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  color: Color(0xFF0F172A),
                                                ),
                                              ),
                                              TextSpan(text: item.rule),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10.h),

                                        // Examples Box
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(12.w),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: const Color(0xFFE2E8F0)),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Examples:",
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w800,
                                                  color: Color(0xFF00695C),
                                                ),
                                              ),
                                              SizedBox(height: 6.h),
                                              ...item.examples.map(
                                                (ex) => Padding(
                                                  padding: const EdgeInsets.only(bottom: 4),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        ex.startsWith("❌") || ex.startsWith("✅") ? "" : "• ",
                                                        style: const TextStyle(
                                                          color: Color(0xFF00695C),
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          ex,
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                            color: ex.startsWith("❌")
                                                                ? const Color(0xFFDC2626)
                                                                : const Color(0xFF1E293B),
                                                            fontWeight: ex.startsWith("❌") || ex.startsWith("✅")
                                                                ? FontWeight.w700
                                                                : FontWeight.w500,
                                                            height: 1.35,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
