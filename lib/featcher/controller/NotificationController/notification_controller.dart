
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
    debugPrint("Local FCM token registered: ${_service.getToken}");
  }

  Future<void> updateToken(String token) async {
    debugPrint("Local FCM token updated: $token");
  }

}