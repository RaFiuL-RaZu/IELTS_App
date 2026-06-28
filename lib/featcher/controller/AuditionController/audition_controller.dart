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
    "Submitted",
    "Call Backed",
    "Booked",
    "Rejected",
  ];

  RxBool isRoleDropdownOpen = false.obs;

  List<String> roleList = [
    "E-Learning",
    "Character",
    "Narration",
    "Video Game",
    "Animation",
    "Commercial",
    "Announcer",
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

    try {
      Map<String, String> header = {"token": PrefsHelper.token};

      final response = await ApiService.getApi(
        AppUrl.getActivity,
        header: header,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body['data'];
        activityModel.value = ActivityModel.fromJson(data);
        setChartFromModel(activityModel.value!);
      }
    } catch (e, s) {
      debugPrint("Error: $e");
      debugPrint("StackTrace: $s");
    } finally {
      isLoading(false);
    }
  }

  TextEditingController projectController = TextEditingController();
  TextEditingController roleController = TextEditingController();

  Future<void> createAudition() async {
    isLoading(true);

    try {
      final localDate = DateFormat("MM/dd/yyyy").parse(selectedDate.value);
      final utcDate = localDate.toUtc().toIso8601String();

      debugPrint("saveAudition :");
      Map<String, String> header = {
        "token": PrefsHelper.token,
        "Content-Type":"application/json"
      };
      debugPrint("saveAudition2 :");

     Map<String,dynamic> body = {
        'data':jsonEncode({
          "title": projectController.text.trim(),
          "category": selectedRole.value,
          "reminderDate": utcDate,
          "status": selectedCallback.value,
        })
      };
      debugPrint("saveAudition3 :");

      final response = await ApiService.audioFileUpload(
        url: AppUrl.createAudition,
        body: body,
        header: header,
        method: "POST",
        filePath: selectedAudioFile?.path ?? "",
        fileField: "auditionFile",
      );
      debugPrint("saveAudition4 :");
      debugPrint("Response: ${response.body}");
      debugPrint("Response: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Response: ${response.body}");
        debugPrint("Response: ${response.statusCode}");
        Get.back();
        getActivity();
        getMyHistory();
      }
    } catch (e, s) {
      debugPrint("Error: $e");
      debugPrint("StackTrace: $s");
    } finally {
      isLoading(false);
    }
  }

  RxList<MyAuditionModel> myHistoryList = <MyAuditionModel>[].obs;

  Future<void> getMyHistory() async {
    isLoading(true);

    try {
      debugPrint("history");
      Map<String, String> header = {
        "token": PrefsHelper.token,
      };

      final response =
      await ApiService.getApi(AppUrl.getMyHistory, header: header);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body['data']['auditions'];

        myHistoryList.value = List<MyAuditionModel>.from(
          data.map((e) => MyAuditionModel.fromJson(e)),
        );
      }
    } catch (e, s) {
      debugPrint("Error: $e");
      debugPrint("StackTrace: $s");
    } finally {
      isLoading(false);
    }
  }

  double get chartMaxY {
    if (chartData.isEmpty) return 10;
    final max = chartData.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    final rounded = ((max / 10).ceil() * 10).toDouble();
    return rounded < 10 ? 10 : rounded;
  }
}

class ChartData {
  final int x;
  final double y;

  ChartData(this.x, this.y);
}
