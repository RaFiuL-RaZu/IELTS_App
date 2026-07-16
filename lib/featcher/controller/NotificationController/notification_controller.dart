
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:justtsham/core/constant/prefs_helper.dart';
import 'package:justtsham/core/services/api_services.dart';
import 'package:justtsham/core/utils/app_urls.dart';
import 'package:justtsham/featcher/controller/NotificationController/service.dart';


class NotificationController extends GetxController {
  final NotificationService _service = NotificationService();

  @override
  void onInit() {
    super.onInit();
    _service.init();
  }


  Future<void> addToken() async {

    Map<String, String> header = {
      "token": PrefsHelper.token
    };

    Map<String, dynamic> body = {
      "fcmToken": _service.getToken
    };

    final response = await ApiService.postApi(
      AppUrl.tokenAdd,
      body,
      header: header,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint("Token added successfully");
    } else {
      debugPrint("Failed to add token: ${response.statusCode}");
    }
  }

  Future<void> updateToken(String token) async {
    Map<String, String> header = {
      "token": PrefsHelper.token
    };

    Map<String, dynamic> body = {
      "fcmToken": token
    };

    final response = await ApiService.postApi(
      AppUrl.tokenAdd,
      body,
      header: header,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint("Token updated successfully");
    } else {
      debugPrint("Failed to update token");
    }
  }

}