import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/services/ielts_local_storage_service.dart';
import 'package:justtsham/featcher/view/HomeScreen/ielts_band_calculator_modal.dart';
import 'package:justtsham/featcher/view/SettingScreen/ielts_band_descriptors_screen.dart';
import 'package:justtsham/featcher/view/SettingScreen/privacy_screen.dart';
import 'package:justtsham/featcher/view/SettingScreen/terms_conditions.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

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
          "Candidate Profile & Analytics",
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
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
                        SizedBox(height: 3.h),
                        Text(
                          "Target: Band ${progressCtrl.targetBand.value} • Academic Module",
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
                  _buildSkillProgressRow("🎧 Listening", progressCtrl.listeningBand.value, progressCtrl.listeningAccuracy.value, const Color(0xFF00695C)),
                  const Divider(height: 24),
                  _buildSkillProgressRow("📖 Reading", progressCtrl.readingBand.value, progressCtrl.readingAccuracy.value, const Color(0xFF6A1B9A)),
                  const Divider(height: 24),
                  _buildSkillProgressRow("✍️ Writing", progressCtrl.writingBand.value, progressCtrl.writingAccuracy.value, const Color(0xFFE65100)),
                  const Divider(height: 24),
                  _buildSkillProgressRow("🗣️ Speaking", progressCtrl.speakingBand.value, progressCtrl.speakingAccuracy.value, const Color(0xFF0284C7)),
                ],
              ),
            )),

            SizedBox(height: 28.h),

            // Target Band Setting
            const Text(
              "Goal & Target Band Settings",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
            SizedBox(height: 14.h),

            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Select Desired Target Band:", style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                  SizedBox(height: 14.h),
                  Obx(() {
                    final current = progressCtrl.targetBand.value;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [6.5, 7.0, 7.5, 8.0, 8.5, 9.0].map((b) {
                        final isSel = current == b;
                        return GestureDetector(
                          onTap: () => progressCtrl.setTargetBand(b),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                            decoration: BoxDecoration(
                              color: isSel ? const Color(0xFF00695C) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              "$b",
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                                color: isSel ? Colors.white : const Color(0xFF475569),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }),
                ],
              ),
            ),

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
                    icon: Icons.calculate_outlined,
                    title: "Cambridge Band Score Calculator",
                    onTap: () => IeltsBandCalculatorModal.show(context),
                  ),
                  const Divider(height: 1),
                  _buildMenuTile(
                    icon: Icons.description_outlined,
                    title: "Official IELTS Band Descriptors",
                    onTap: () => Get.to(() => const IeltsBandDescriptorsScreen()),
                  ),
                  const Divider(height: 1),
                  _buildMenuTile(
                    icon: Icons.privacy_tip_outlined,
                    title: "Privacy Policy",
                    onTap: () => Get.to(() => const PrivacyScreen()),
                  ),
                  const Divider(height: 1),
                  _buildMenuTile(
                    icon: Icons.article_outlined,
                    title: "Terms & Conditions",
                    onTap: () => Get.to(() => const TermsOfUseScreen()),
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
}
