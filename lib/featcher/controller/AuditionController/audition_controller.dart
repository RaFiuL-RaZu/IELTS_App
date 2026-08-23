import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:justtsham/featcher/model/AuditionModel/my_audition_model.dart';

import '../../../core/constant/prefs_helper.dart';
import '../../../core/services/api_services.dart';
import '../../../core/utils/app_urls.dart';
import '../../model/AuditionModel/activity_model.dart';
import 'package:file_picker/file_picker.dart';

class AuditionController extends GetxController {
  File? selectedAudioFile;
  RxString audioFileName = "".obs;
  Future<void> pickAudioFile() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav'],
    );

    if (result != null && result.files.single.path != null) {
      selectedAudioFile = File(result.files.single.path!);
      audioFileName.value = result.files.single.name;
    }
  }

  RxList<ChartData> chartData = <ChartData>[].obs;
  RxString selectedChartType = 'Booked'.obs;

  Rxn<ActivityModel> activityModel = Rxn<ActivityModel>();

  void setChartFromModel(ActivityModel model) {
    _applyChart(model, selectedChartType.value);
  }

  void switchChart(String type) {
    selectedChartType.value = type;
    if (activityModel.value != null) {
      _applyChart(activityModel.value!, type);
    }
  }

  void _applyChart(ActivityModel model, String type) {
    final m = type == 'Callback'
        ? (model.callbackMonthlyActivity ?? model.bookedMonthlyActivity)
        : (model.bookedMonthlyActivity ?? model.monthlyActivity);

    chartData.assignAll([
      ChartData(1, (m?.jan ?? 0).toDouble()),
      ChartData(2, (m?.feb ?? 0).toDouble()),
      ChartData(3, (m?.mar ?? 0).toDouble()),
      ChartData(4, (m?.apr ?? 0).toDouble()),
      ChartData(5, (m?.may ?? 0).toDouble()),
      ChartData(6, (m?.jun ?? 0).toDouble()),
      ChartData(7, (m?.jul ?? 0).toDouble()),
      ChartData(8, (m?.aug ?? 0).toDouble()),
      ChartData(9, (m?.sep ?? 0).toDouble()),
      ChartData(10, (m?.oct ?? 0).toDouble()),
      ChartData(11, (m?.nov ?? 0).toDouble()),
      ChartData(12, (m?.dec ?? 0).toDouble()),
    ]);
  }

  List<Map<String, String>> historyList = [
    {"title": "Oasis Promo", "action": "Callback"},
    {"title": "Local Bank", "action": "Rejected"},
    {"title": "Space Vanguard", "action": "Submitted"},
  ];

  RxBool isCallbackDropdownOpen = false.obs;

  List<String> callbackList = [
    "Band 8.0 - 9.0 (Expert)",
    "Band 7.0 - 7.5 (Good)",
    "Band 6.0 - 6.5 (Competent)",
    "Under Evaluation",
    "Practice Completed",
  ];

  RxBool isRoleDropdownOpen = false.obs;

  List<String> roleList = [
    "Speaking Part 1",
    "Speaking Part 2 (Cue Card)",
    "Speaking Part 3 (Discussion)",
    "Full Mock Speaking Test",
    "Listening Practice Test",
    "Reading Academic Test",
    "Writing Task 1 & 2",
  ];

  RxString selectedRole = "".obs;

  void toggleRoleDropdown() {
    isRoleDropdownOpen.value = !isRoleDropdownOpen.value;
  }

  void selectRole(String value) {
    selectedRole.value = value;
    isRoleDropdownOpen.value = false;
  }

  RxString selectedCallback = "".obs;

  void toggleCallbackDropdown() {
    isCallbackDropdownOpen.value = !isCallbackDropdownOpen.value;
  }

  void selectCallback(String value) {
    selectedCallback.value = value;
    isCallbackDropdownOpen.value = false;
  }

  RxString selectedDate = "Jun 15, 2026".obs;

  Future<void> pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      selectedDate.value =
          "${pickedDate.month}/${pickedDate.day}/${pickedDate.year}";
    }
  }

  RxBool isLoading = false.obs;

  Future<void> getActivity() async {
    isLoading(true);

    chartData.assignAll([
      ChartData(1, 6.0),
      ChartData(2, 6.5),
      ChartData(3, 6.5),
      ChartData(4, 7.0),
      ChartData(5, 7.0),
      ChartData(6, 7.5),
      ChartData(7, 7.5),
      ChartData(8, 8.0),
      ChartData(9, 8.0),
      ChartData(10, 8.5),
      ChartData(11, 8.5),
      ChartData(12, 8.5),
    ]);

    isLoading(false);
  }

  TextEditingController projectController = TextEditingController();
  TextEditingController roleController = TextEditingController();

  Future<void> createAudition() async {
    isLoading(true);

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final now = DateTime.now();

      final newItem = MyAuditionModel(
        id: "mock_${now.millisecondsSinceEpoch}",
        creatorId: PrefsHelper.userId,
        title: projectController.text.trim().isNotEmpty
            ? projectController.text.trim()
            : "Cambridge Practice Test",
        category: selectedRole.value.isNotEmpty
            ? selectedRole.value
            : "Full Mock Speaking Test",
        reminderDate: now,
        status: selectedCallback.value.isNotEmpty
            ? selectedCallback.value
            : "Band 7.5 - 8.0 (Good)",
        auditionFile: selectedAudioFile?.path ?? "",
        likeCount: 1,
        commentCount: 0,
        createdAt: now,
        updatedAt: now,
      );

      myHistoryList.insert(0, newItem);
      projectController.clear();
      roleController.clear();
      audioFileName.value = "";
      selectedAudioFile = null;

      Get.back();
      Get.snackbar(
        "Mock Test Logged",
        "Your IELTS test session has been recorded successfully.",
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      debugPrint("Create Audition Local Error: $e");
    } finally {
      isLoading(false);
    }
  }

  RxList<MyAuditionModel> myHistoryList = <MyAuditionModel>[].obs;

  void _loadDefaultHistory() {
    final now = DateTime.now();
    myHistoryList.value = [
      MyAuditionModel(
        id: "mock_1",
        creatorId: "u_1",
        title: "Cambridge 18 - Speaking Test 1",
        category: "Full Mock Speaking Test",
        reminderDate: now.subtract(const Duration(days: 2)),
        status: "Band 7.5 (Good)",
        auditionFile: "",
        likeCount: 3,
        commentCount: 1,
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      MyAuditionModel(
        id: "mock_2",
        creatorId: "u_1",
        title: "Cue Card: Technological Innovation",
        category: "Speaking Part 2 (Cue Card)",
        reminderDate: now.subtract(const Duration(days: 5)),
        status: "Band 8.0 (Expert)",
        auditionFile: "",
        likeCount: 5,
        commentCount: 2,
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      MyAuditionModel(
        id: "mock_3",
        creatorId: "u_1",
        title: "Writing Task 2: AI & Employment",
        category: "Writing Task 1 & 2",
        reminderDate: now.subtract(const Duration(days: 9)),
        status: "Band 7.0 (Good)",
        auditionFile: "",
        likeCount: 2,
        commentCount: 0,
        createdAt: now.subtract(const Duration(days: 9)),
        updatedAt: now.subtract(const Duration(days: 9)),
      ),
    ];
  }

  Future<void> getMyHistory() async {
    isLoading(true);
    _loadDefaultHistory();
    isLoading(false);
  }

  double get chartMaxY {
    if (chartData.isEmpty) return 10;
    final max = chartData.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    final rounded = ((max / 10).ceil() * 10).toDouble();
    return rounded < 10 ? 10 : rounded;
  }
  RxBool isInterested = false.obs;
  Future<bool> notInterested({required String id}) async {
    myHistoryList.removeWhere((item) => item.id == id);
    return true;
  }
}

class ChartData {
  final int x;
  final double y;

  ChartData(this.x, this.y);
}
