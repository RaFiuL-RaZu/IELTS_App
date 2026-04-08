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
}

class ChartData {
  final int x;
  final double y;

  ChartData(this.x, this.y);
}