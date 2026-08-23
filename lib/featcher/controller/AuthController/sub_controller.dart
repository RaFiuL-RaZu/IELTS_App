

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/constant/prefs_helper.dart';
import 'package:justtsham/core/services/api_services.dart';
import 'package:justtsham/core/utils/app_urls.dart';
import 'package:justtsham/featcher/controller/AuthController/verify_email_controller.dart';
import 'package:justtsham/featcher/model/ProfileModel/myplan_model.dart';
import 'package:justtsham/featcher/model/ProfileModel/subscription_model.dart';
import 'package:justtsham/featcher/view/SettingScreen/weebview.dart';
import 'package:justtsham/featcher/view/authentication/payment_page.dart';

import '../../view/authentication/navber_screen.dart';

class SubController extends GetxController{
  List<String> planList = [
    "Track up to 25 auditions",
    "Save up to 20 scripts",
    "5 AI script generations per day",
    "Upload up to 3 demos",
    "Basic analytics",
    "Access to community features",
  ];

  List<String> premiumList = [
    "All Pro features included",
    "Advanced career insights and analytics",
    "Priority visibility in community feed",
    "Featured profile and demo placement",
    "Expanded storage and future advanced tools.",
  ];
  List<String> proList = [
    "Unlimited audition tracking",
    "Unlimited scripts and demo uploads",
    "Unlimited AI script generation",
    "Advanced analytics and performance insights",
    "Full community interaction (comments, likes, following)",
  ];
  
  RxBool isLoading=false.obs;

  RxList subList=[].obs;
  RxString planId="".obs;
  void selectPlan(String id) {
    planId.value = id;
  }
  
  Future<void> getSubscription() async {
    isLoading(false);
  }

  Rx<MyPlanModel> myPlanModel = MyPlanModel().obs;
  Future<void> getMyPlan() async {
    isLoading(false);
  }

  var checkOutUrl = '';

  Future<void> getPayment() async {
    isLoading(true);
    await Future.delayed(const Duration(milliseconds: 300));
    Get.offAll(() => NavBarScreen());
    Get.snackbar(
      "Plan Activated! 💎",
      "Your IELTS Pro access is now active.",
      snackPosition: SnackPosition.TOP,
    );
    isLoading(false);
  }
}