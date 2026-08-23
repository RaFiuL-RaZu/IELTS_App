


import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:justtsham/core/constant/prefs_helper.dart';
import 'package:justtsham/core/services/api_services.dart';
import 'package:justtsham/core/utils/app_urls.dart';
import 'package:justtsham/featcher/model/HomeModel/notify_model.dart';

class NotifyController extends GetxController{

  NotifyModel notifyModel=NotifyModel();
  RxBool isLoading=false.obs;

  RxList<NotifyModel> notifyList=<NotifyModel>[].obs;

  void _loadDefaultNotifications() {
    final now = DateTime.now();
    notifyList.value = [
      NotifyModel(
        sId: "n_1",
        type: "practice_reminder",
        isRead: false,
        createdAt: now.subtract(const Duration(minutes: 45)).toIso8601String(),
        message: Message(
          title: "Daily Cue Card Practice 🎯",
          body: "Complete today's 2-minute cue card challenge on 'Technology & AI' to keep your 5-day streak!",
        ),
      ),
      NotifyModel(
        sId: "n_2",
        type: "feedback",
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 3)).toIso8601String(),
        message: Message(
          title: "Peer Feedback Received 💬",
          body: "Sarah Jenkins commented on your recent Speaking Part 2 model response.",
        ),
      ),
      NotifyModel(
        sId: "n_3",
        type: "band_update",
        isRead: true,
        createdAt: now.subtract(const Duration(days: 1)).toIso8601String(),
        message: Message(
          title: "Target Band Progress 📈",
          body: "Your Speaking mock test has reached Band 7.5+. Check your latest analytics.",
        ),
      ),
    ];
  }

  Future<void> getNotify() async {
    _loadDefaultNotifications();
    isLoading(false);
  }
}