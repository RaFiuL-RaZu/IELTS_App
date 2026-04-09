import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuditionController extends GetxController {
  RxList<ChartData> chartData = <ChartData>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {
    chartData.assignAll([
      ChartData(1, 28),
      ChartData(2, 29),
      ChartData(3, 25),
      ChartData(4, 27),
      ChartData(5, 23),
      ChartData(6, 26),
      ChartData(7, 28),
      ChartData(8, 24),
      ChartData(9, 22),
      ChartData(10, 30),
    ]);
  }

  List<Map<String, String>> historyList = [
    {
      "title": "Oasis Promo",
      "action": "Callback",
    },
    {
      "title": "Local Bank",
      "action": "Rejected",
    },
    {
      "title": "Space Vanguard",
      "action": "Submitted",
    },
  ];

  RxBool isCallbackDropdownOpen = false.obs;

  List<String> callbackList = [
    "Submitted",
    "Call Backed",
    "Booked",
    "Rejected",
  ];

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
}

class ChartData {
  final int x;
  final double y;

  ChartData(this.x, this.y);
}