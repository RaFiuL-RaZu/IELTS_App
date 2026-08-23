

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:justtsham/featcher/model/ProfileModel/help_model.dart';

import '../../../core/constant/prefs_helper.dart';
import '../../../core/services/api_services.dart';
import '../../../core/utils/app_urls.dart';

class HelpController extends GetxController{



  RxBool isLoading=false.obs;

  Rx<HelpModel> helpModel = HelpModel().obs;


  Future<void> getHelp() async {
    isLoading(false);
    helpModel.value = HelpModel(
      id: "help_1",
      email: "support@ieltsmaster.com",
      phone: "+44 20 7946 0991",
      location: "Cambridge Assessment Center, London, UK",
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );
  }
}