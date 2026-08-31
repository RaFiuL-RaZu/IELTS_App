import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/services/ielts_local_storage_service.dart';

class IeltsExamDateModal {
  static void show(BuildContext context) {
    final progressCtrl = Get.find<IeltsProgressController>();

    DateTime selectedDate = DateTime.now().add(Duration(days: progressCtrl.dynamicDaysRemaining > 0 ? progressCtrl.dynamicDaysRemaining : 30));
    if (progressCtrl.examDateString.value.isNotEmpty) {
      try {
        selectedDate = DateTime.parse(progressCtrl.examDateString.value);
      } catch (_) {}
    }

    String selectedModule = progressCtrl.examModule.value;
    double selectedBand = progressCtrl.targetBand.value;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final examDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
            final daysLeft = examDay.difference(today).inDays;

            final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
            final formattedDate = "${selectedDate.day} ${months[selectedDate.month - 1]} ${selectedDate.year}";

            return Container(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle Bar
                  Center(
                    child: Container(
                      height: 4.h,
                      width: 44.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Modal Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2F1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.event_available_rounded, color: Color(0xFF00695C), size: 22),
                      ),
                      SizedBox(width: 10.w),
                      const Expanded(
                        child: Text(
                          "Set Real IELTS Exam Date",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Countdown Preview Card
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF004D40), Color(0xFF00695C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Selected Exam Date",
                              style: TextStyle(fontSize: 11.5.sp, color: Colors.white.withOpacity(0.8)),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              formattedDate,
                              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, color: Colors.white),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "${daysLeft >= 0 ? daysLeft : 0}",
                                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900, color: const Color(0xFF80CBC4)),
                              ),
                              Text(
                                "Days Left",
                                style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Calendar Date Picker Button
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate.isAfter(DateTime.now()) ? selectedDate : DateTime.now().add(const Duration(days: 30)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 730)),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFF00695C),
                                onPrimary: Colors.white,
                                onSurface: Color(0xFF0F172A),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (picked != null) {
                        setModalState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    child: Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.calendar_month_rounded, color: Color(0xFF00695C), size: 20),
                          SizedBox(width: 8.w),
                          const Text(
                            "Choose from Calendar 📅",
                            style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Module Selection (Academic vs General)
                  const Text(
                    "IELTS Module:",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setModalState(() => selectedModule = "Academic"),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            decoration: BoxDecoration(
                              color: selectedModule == "Academic" ? const Color(0xFF00695C) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                "Academic 📘",
                                style: TextStyle(
                                  fontSize: 12.5.sp,
                                  fontWeight: FontWeight.w700,
                                  color: selectedModule == "Academic" ? Colors.white : const Color(0xFF475569),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setModalState(() => selectedModule = "General Training"),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            decoration: BoxDecoration(
                              color: selectedModule == "General Training" ? const Color(0xFF00695C) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                "General Training 📗",
                                style: TextStyle(
                                  fontSize: 12.5.sp,
                                  fontWeight: FontWeight.w700,
                                  color: selectedModule == "General Training" ? Colors.white : const Color(0xFF475569),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // Save & Update Button
                  GestureDetector(
                    onTap: () async {
                      await progressCtrl.setExamDate(selectedDate);
                      progressCtrl.setExamModule(selectedModule);
                      progressCtrl.setTargetBand(selectedBand);

                      Get.back();

                      Get.snackbar(
                        "Exam Countdown Updated! 🎯",
                        "Your exam is set for $formattedDate ($daysLeft days remaining). Countdown is live!",
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
                      ),
                      child: const Center(
                        child: Text(
                          "Save & Start Countdown",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
