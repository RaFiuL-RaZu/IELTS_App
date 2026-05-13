

import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:justtsham/core/constant/prefs_helper.dart';
import 'package:justtsham/core/services/api_services.dart';
import 'package:justtsham/core/utils/app_urls.dart';
import 'package:justtsham/featcher/model/ScriptModel/script_model.dart';

class ScriptController extends GetxController{

  static ScriptController get instance=>Get.put(ScriptController());

  RxList<ScriptModel> filteredScriptList = <ScriptModel>[].obs;
  TextEditingController searchController = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    filteredScriptList.value = scriptList;
  }


  void searchScripts(String query) {
    String selectedCategory = items[selectedTab.value];

    List<ScriptModel> tempList = scriptList;

    if (selectedCategory != "All") {
      tempList = tempList.where((script) {
        return script.category
            ?.toLowerCase()
            .trim() ==
            selectedCategory.toLowerCase().trim();
      }).toList();
    }

    if (query.isNotEmpty) {
      tempList = tempList.where((script) {
        return (script.title ?? "")
            .toLowerCase()
            .contains(query.toLowerCase()) ||
            (script.category ?? "")
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            (script.content ?? "")
                .toLowerCase()
                .contains(query.toLowerCase());
      }).toList();
    }

    filteredScriptList.value = tempList;
  }
  void filterScriptsByCategory(int index) {
    selectedTab.value = index;

    searchScripts(searchController.text);
  }

  RxInt selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }


  RxInt selectedTab = 0.obs;

  void selectItem(int index) {
    selectedTab.value = index;
  }
  RxInt selectedSecond = 0.obs;
  RxString selectedTime = "15 sec".obs;

  void selectTimeItem(int index) {
    selectedSecond.value = index;
    selectedTime.value = timeList[index];
  }


  List<String> timeList = [
    "15 sec",
    "30 sec",
    "45 sec",
    "1 minute",
  ];

  List<String> items = [
    "All",
    "E-Learning",
    "Character",
    "Narration",
    "Video Game",
    "Animation",
    "Commercial",
    "Sports",
  ];

  RxBool isDropdownOpen = false.obs;

  List<String> categories = [
    "E-Learning",
    "Character",
    "Narration",
    "Video Game",
    "Animation",
    "Commercial",
    "Sports",
  ];

  RxString selectedCategory = "".obs;

  void toggleDropdown() {
    isDropdownOpen.value = !isDropdownOpen.value;
  }

  void selectCategory(String value) {
    selectedCategory.value = value;
    isDropdownOpen.value = false;
  }

  RxBool isToneDropdownOpen = false.obs;

  List<String> toneList = [
    "Energetic",
    "Dramatic",
    "Conversational",
    "Authoritative",
    "Quirky",
  ];

  RxString selectedTone = "".obs;

  void toggleToneDropdown() {
    isToneDropdownOpen.value = !isToneDropdownOpen.value;
  }

  void selectTone(String value) {
    selectedTone.value = value;
    isToneDropdownOpen.value = false;
  }
  RxBool isLoading=false.obs;

  RxList<ScriptModel> scriptList=<ScriptModel>[].obs;

  Future<void> getScript() async {
    debugPrint("GetScript");

    isLoading(true);

    try {
      Map<String, String> header = {
        "token": PrefsHelper.token
      };

      final response =
      await ApiService.getApi(AppUrl.getScript, header: header);

      if (response.statusCode == 200 || response.statusCode == 201) {

        final data = response.body['data']['result'];

        if (data is List) {
          scriptList.value =
              data.map((e) => ScriptModel.fromJson(e)).toList();
          filteredScriptList.value=scriptList;
        }
        debugPrint("API FULL RESPONSE: ${response.body}");
        debugPrint("SCRIPT LIST LENGTH: ${scriptList.length}");
        debugPrint("FILTER LIST LENGTH: ${filteredScriptList.length}");
      }
    } catch (e, s) {
      debugPrint("Error: $e");
      debugPrint("Stack: $s");
    } finally {
      isLoading(false);
    }
  }






  var script="".obs;
  Future<void> createScript()async{
    isLoading(true);
    try{

      Map<String,String> header={
        "token":PrefsHelper.token
      };

      Map<String,dynamic> body={
        "category": selectedCategory.value,
        "tone": selectedTone.value,
        "duration": selectedTime.value
      };

      debugPrint("Script: $body");


      final response= await ApiService.postApi(AppUrl.createScript,body,header: header);

      if(response.statusCode==200 || response.statusCode==201) {
        final data = response.body['data'];
        script.value=data;

      }


    }catch(e,s){
      debugPrint("DebugPrint : $e");
      debugPrint("SnackTrack : $s");
    }finally{
      isLoading(false);
    }


  }

  }