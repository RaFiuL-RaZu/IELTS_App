
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PrefsHelper extends GetxController {
  static String token = "";
  static bool isLogIn = false;
  static bool isVerify = false;
  static bool hasSeenOnboard = false;
  static bool isNotifications = true;
  static String refreshToken = "";
  static String userId = "";
  static String myImage = "";
  static String myName = "";
  static String userName = "";
  static String myEmail = "";
  static String phone = "";
  static String myRole = "";
  static String mySubscription = "shopping";
  static String localizationLanguageCode = 'en';
  static String localizationCountryCode = 'US';
  static String selectedRole = '';

  ///<<<======================== Get All Data Form Shared Preference ==============>

  static Future<void> getAllPrefData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token") ?? "";
    refreshToken = preferences.getString("refreshToken") ?? "";
    userId = preferences.getString("userId") ?? "";
    myImage = preferences.getString("myImage") ?? "";
    myName = preferences.getString("myName") ?? "";
    myEmail = preferences.getString("myEmail") ?? "";
    phone = preferences.getString("phone") ?? "";
    myRole = preferences.getString("myRole") ?? "";
    isLogIn = preferences.getBool("isLogIn") ?? false;
    isVerify = preferences.getBool("isVerify") ?? false;
    hasSeenOnboard = preferences.getBool("hasSeenOnboard") ?? false;
    isNotifications = preferences.getBool("isNotifications") ?? true;
    mySubscription = preferences.getString("mySubscription") ?? "shopping";
    localizationCountryCode =
        preferences.getString("localizationCountryCode") ?? "US";
    localizationLanguageCode =
        preferences.getString("localizationLanguageCode") ?? "en";
    isLogIn = preferences.getBool("isLogIn") ?? false;
    isNotifications = preferences.getBool("isNotifications") ?? true;
    mySubscription = preferences.getString("mySubscription") ?? "shopping";
    localizationCountryCode = preferences.getString("localizationCountryCode") ?? "US";
    localizationLanguageCode = preferences.getString("localizationLanguageCode") ?? "en";


    if (kDebugMode) {
      print(userId);
    }
  }

  ///<<<======================== Clear User Session & Log Out ============>
  static Future<void> removeAllPrefData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("token", "");
    await preferences.setString("refreshToken", "");
    await preferences.setString("userId", "");
    await preferences.setString("myImage", "");
    await preferences.setString("myName", "");
    await preferences.setString("myEmail", "");
    await preferences.setString("candidate_name", "");
    await preferences.setBool("isLogIn", false);
    await preferences.setBool("isVerify", false);
    await preferences.setBool("isNotifications", true);
    await preferences.setBool("hasSetupCandidate", false);
    await preferences.setString("mySubscription", "free");

    token = "";
    refreshToken = "";
    userId = "";
    myImage = "";
    myName = "";
    myEmail = "";
    isLogIn = false;
    isVerify = false;
    // hasSeenOnboard is intentionally kept — no onboard repeat after logout
  }

  static Future<void> logOut() async {
    await removeAllPrefData();
  }

  ///<<<======================== Get Data Form Shared Preference ==============>

  static Future<String> getString(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(key) ?? "";
  }

  static Future<bool?> getBool(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(key);
  }

  static Future<int> getInt(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt(key) ?? (-1);
  }

  ///<<<=====================Save Data To Shared Preference=====================>

  static Future setString(String key, value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(key, value);
  }

  static Future setBool(String key, bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setBool(key, value);
  }

  static Future setInt(String key, int value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setInt(key, value);
  }

  ///<<<==========================Remove Value==================================>

  static Future remove(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.remove(key);
  }
}