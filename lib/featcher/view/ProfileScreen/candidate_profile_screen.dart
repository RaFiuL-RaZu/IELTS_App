import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/constant/prefs_helper.dart';
import 'package:justtsham/core/services/ielts_local_storage_service.dart';
import 'package:justtsham/featcher/view/ProfileScreen/ielts_band_descriptors_screen.dart';
import 'package:justtsham/featcher/view/ProfileScreen/ielts_question_bank_screen.dart';
import 'package:justtsham/featcher/view/ProfileScreen/ielts_study_plan_screen.dart';
import 'package:justtsham/featcher/view/authentication/candidate_setup_screen.dart';

class CandidateProfileScreen extends StatelessWidget {
  const CandidateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progressCtrl = Get.find<IeltsProgressController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 65.h,
        title: const Text(
          "Profile & Analytics",
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Color(0xFFDC2626), size: 22),
            tooltip: "Log Out",
            onPressed: () => _showLogoutDialog(context, progressCtrl),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 18.h, bottom: 100.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Candidate Profile Card
            Obx(() => Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFE2E8F0)),
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
                  Container(
                    height: 58.h,
                    width: 58.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF004D40), Color(0xFF00796B)],
                      ),
                    ),
                    child: const Center(
                      child: Text("🎓", style: TextStyle(fontSize: 28)),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                progressCtrl.candidateName.value,
                                style: const TextStyle(
                                  fontSize: 17.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _showEditNameDialog(context, progressCtrl),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.edit_outlined, size: 16, color: Color(0xFF00695C)),
                              ),
                            ),
                          ],
                        ),
                        if (PrefsHelper.myEmail.isNotEmpty) ...[
                          SizedBox(height: 2.h),
                          Text(
                            PrefsHelper.myEmail,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                        SizedBox(height: 3.h),
                        Text(
                          "Target: Band ${progressCtrl.targetBand.value} • ${progressCtrl.examModule.value}",
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF00695C),
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          "${progressCtrl.examDaysRemaining.value} Days Remaining to Official Test",
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),

            SizedBox(height: 28.h),

            // Performance Analytics
            const Text(
              "Skill-by-Skill Performance",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
            SizedBox(height: 14.h),

            Obx(() => Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  _buildSkillProgressRow("🗣️ Speaking", progressCtrl.speakingBand.value, progressCtrl.speakingAccuracy.value, const Color(0xFFC8A96B)),
                  const Divider(height: 24),
                  _buildSkillProgressRow("🎧 Listening", progressCtrl.listeningBand.value, progressCtrl.listeningAccuracy.value, const Color(0xFF2E6FA0)),
                  const Divider(height: 24),
                  _buildSkillProgressRow("📖 Reading", progressCtrl.readingBand.value, progressCtrl.readingAccuracy.value, const Color(0xFF91AE6E)),
                  const Divider(height: 24),
                  _buildSkillProgressRow("✍️ Writing", progressCtrl.writingBand.value, progressCtrl.writingAccuracy.value, const Color(0xFF325E6A)),
                ],
              ),
            )),

            SizedBox(height: 28.h),

            // Resources & Utilities
            const Text(
              "Tools & Official Guidelines",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
            SizedBox(height: 14.h),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  _buildMenuTile(
                    icon: Icons.insights_rounded,
                    title: "Personalized Study Plan & Progress",
                    onTap: () => Get.to(() => const IeltsStudyPlanScreen()),
                  ),
                  const Divider(height: 1),
                  _buildMenuTile(
                    icon: Icons.quiz_outlined,
                    title: "IELTS Practice Question Bank",
                    onTap: () => Get.to(() => const IeltsQuestionBankScreen()),
                  ),
                  const Divider(height: 1),
                  _buildMenuTile(
                    icon: Icons.description_outlined,
                    title: "Official IELTS Band Descriptors",
                    onTap: () => Get.to(() => const IeltsBandDescriptorsScreen()),
                  ),
                ],
              ),
            ),

            SizedBox(height: 28.h),

            // Account & Practice Data Management
            const Text(
              "Account & Data Management",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
            SizedBox(height: 14.h),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  // Reset Practice History Only
                  ListTile(
                    onTap: () => _showResetHistoryConfirmation(context, progressCtrl),
                    leading: Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.cleaning_services_rounded, color: Color(0xFFD97706), size: 20),
                    ),
                    title: const Text(
                      "Reset Practice Tests & Scores",
                      style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                    ),
                    subtitle: const Text(
                      "Wipes test logs and resets score history to 0",
                      style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF94A3B8), size: 14),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                  ),
                  const Divider(height: 1),

                  // Log Out Candidate Account & Switch Profile
                  ListTile(
                    onTap: () => _showLogoutDialog(context, progressCtrl),
                    leading: Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.logout_rounded, color: Color(0xFFDC2626), size: 20),
                    ),
                    title: const Text(
                      "Log Out / Switch Account",
                      style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFFDC2626)),
                    ),
                    subtitle: const Text(
                      "Safely log out and switch to another candidate profile",
                      style: TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFFFCA5A5), size: 14),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillProgressRow(String name, double band, double accuracy, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 110.w,
          child: Text(
            name,
            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: accuracy / 100.0,
              minHeight: 7,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        SizedBox(width: 14.w),
        Text(
          "Band $band",
          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: color),
        ),
        SizedBox(width: 6.w),
        Text(
          "($accuracy%)",
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF94A3B8)),
        ),
      ],
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color(0xFF00695C), size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF94A3B8), size: 14),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
    );
  }

  void _showEditNameDialog(BuildContext context, IeltsProgressController controller) {
    final textController = TextEditingController(text: controller.candidateName.value);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Edit Candidate Profile Name",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 6),
            const Text(
              "Your name will be displayed on your dashboard, scores, and test certificates.",
              style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: textController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Enter your full name",
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF00695C), width: 1.5)),
              ),
            ),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: () {
                final newName = textController.text.trim();
                if (newName.isNotEmpty) {
                  controller.updateCandidateName(newName);
                  Navigator.pop(ctx);
                  Get.snackbar(
                    "Profile Updated!",
                    "Candidate name changed to $newName",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: const Color(0xFF00695C),
                    colorText: Colors.white,
                  );
                }
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF00695C),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text(
                    "Save Changes",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  void _showResetHistoryConfirmation(BuildContext context, IeltsProgressController progressCtrl) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.cleaning_services_rounded, color: Color(0xFFD97706), size: 24),
            SizedBox(width: 10),
            Text(
              "Reset Test Scores?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
            ),
          ],
        ),
        content: const Text(
          "This will clear all logged practice tests, score history, and skill accuracy stats for this account, allowing you to start fresh. Your profile details will remain intact.",
          style: TextStyle(fontSize: 13.5, color: Color(0xFF475569)),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w700)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD97706),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await progressCtrl.resetPracticeHistory();
              Get.snackbar(
                "History Cleared! 🧹",
                "Your test logs and practice stats have been reset to 0.",
                snackPosition: SnackPosition.TOP,
                backgroundColor: const Color(0xFFD97706),
                colorText: Colors.white,
              );
            },
            child: const Text("Clear History", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, IeltsProgressController progressCtrl) {
    final candidateName = progressCtrl.candidateName.value;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.logout_rounded, color: Color(0xFFDC2626), size: 22),
            ),
            const SizedBox(width: 10),
            const Text(
              "Log Out Account?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to log out of '$candidateName'?\n\nYour test scores, analytics, and history will remain securely preserved on this device. You can log back in anytime by picking your name.",
          style: const TextStyle(fontSize: 13.5, color: Color(0xFF475569), height: 1.5),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w700)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await progressCtrl.saveToLocalStorage();
              await PrefsHelper.setBool("hasSetupCandidate", false);
              Get.offAll(() => const CandidateSetupScreen(isNewAccount: true));
            },
            child: const Text("Log Out", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}
