import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/constant/prefs_helper.dart';
import 'package:justtsham/core/services/ielts_local_storage_service.dart';
import 'package:justtsham/core/utils/app_colors.dart';
import 'package:justtsham/core/widgets/coomon_button.dart';
import 'package:justtsham/routes/routes.dart';

class CandidateSetupScreen extends StatefulWidget {
  const CandidateSetupScreen({super.key});

  @override
  State<CandidateSetupScreen> createState() => _CandidateSetupScreenState();
}

class _CandidateSetupScreenState extends State<CandidateSetupScreen> {
  final TextEditingController nameController = TextEditingController();
  final List<double> bandOptions = [6.5, 7.0, 7.5, 8.0, 8.5, 9.0];
  double selectedBand = 8.0;
  String selectedModule = "Academic";
  int selectedDays = 30;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<IeltsProgressController>()) {
      final ctrl = IeltsProgressController.to;
      nameController.text = ctrl.candidateName.value == "IELTS Aspirant" ? "" : ctrl.candidateName.value;
      selectedBand = ctrl.targetBand.value;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> _submitSetup() async {
    if (!formKey.currentState!.validate()) return;

    final name = nameController.text.trim();

    if (Get.isRegistered<IeltsProgressController>()) {
      final ctrl = IeltsProgressController.to;
      await ctrl.updateCandidateName(name);
      ctrl.setTargetBand(selectedBand);
      ctrl.setExamModule(selectedModule);
      ctrl.examDaysRemaining.value = selectedDays;
      await ctrl.saveToLocalStorage();
    }

    await PrefsHelper.setString("candidate_name", name);
    await PrefsHelper.setString("myName", name);
    await PrefsHelper.setString("exam_module", selectedModule);
    await PrefsHelper.setBool("hasSetupCandidate", true);
    await PrefsHelper.setBool("hasSeenOnboard", true);

    Get.offAllNamed(AppRoutes.navBer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Candidate Setup",
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Hero Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF004D40), Color(0xFF00695C), Color(0xFF00897B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00695C).withOpacity(0.25),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 52.h,
                        width: 52.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text("🎯", style: TextStyle(fontSize: 26)),
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Welcome to IELTS Vault",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              "Set your goal to personalize your daily test prep & band analytics.",
                              style: TextStyle(
                                color: Color(0xFFE0F2F1),
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // 1. Candidate Full Name
                const Text(
                  "What is your name?",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: nameController,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                  decoration: InputDecoration(
                    hintText: "Enter your full name (e.g. Sarah Khan)",
                    hintStyle: const TextStyle(fontSize: 13.5, color: Color(0xFF94A3B8)),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.person_outline_rounded, color: Color(0xFF00695C)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFF00695C), width: 1.8),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return "Please enter your name";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 22.h),

                // 2. Target Band Score
                const Text(
                  "Target IELTS Band Score",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                SizedBox(height: 4.h),
                const Text(
                  "Select the score you aim to achieve on test day:",
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: bandOptions.map((band) {
                      final isSelected = selectedBand == band;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedBand = band;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF00695C) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF00695C).withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Band",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? const Color(0xFF80CBC4) : const Color(0xFF94A3B8),
                                ),
                              ),
                              Text(
                                "$band",
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w800,
                                  color: isSelected ? Colors.white : const Color(0xFF334155),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(height: 22.h),

                // 3. Exam Module (Academic vs General Training)
                const Text(
                  "IELTS Exam Module",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectedModule = "Academic"),
                        child: Container(
                          padding: EdgeInsets.all(14.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: selectedModule == "Academic" ? const Color(0xFF00695C) : const Color(0xFFE2E8F0),
                              width: selectedModule == "Academic" ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                selectedModule == "Academic" ? Icons.radio_button_checked : Icons.radio_button_off,
                                color: selectedModule == "Academic" ? const Color(0xFF00695C) : const Color(0xFF94A3B8),
                                size: 20,
                              ),
                              SizedBox(width: 8.w),
                              const Text(
                                "Academic",
                                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectedModule = "General Training"),
                        child: Container(
                          padding: EdgeInsets.all(14.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: selectedModule == "General Training" ? const Color(0xFF00695C) : const Color(0xFFE2E8F0),
                              width: selectedModule == "General Training" ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                selectedModule == "General Training" ? Icons.radio_button_checked : Icons.radio_button_off,
                                color: selectedModule == "General Training" ? const Color(0xFF00695C) : const Color(0xFF94A3B8),
                                size: 20,
                              ),
                              SizedBox(width: 8.w),
                              const Text(
                                "General",
                                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 36.h),

                // Submit Button
                CommonButton(
                  titleText: "Start IELTS Preparation 🚀",
                  buttonRadius: 18,
                  onTap: _submitSetup,
                ),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
