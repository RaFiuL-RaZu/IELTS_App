

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/constant/prefs_helper.dart';
import 'package:justtsham/core/services/api_services.dart';
import 'package:justtsham/core/utils/app_urls.dart';

import '../../model/HomeModel/audition_model.dart';

class HomeController extends GetxController{

  final ValueNotifier<bool> isPlaying = ValueNotifier(false);

  RxInt activeCommentIndex = (-1).obs;

  void toggleCommentField(int index) {
    if (activeCommentIndex.value == index) {
      activeCommentIndex.value = -1; // close if same clicked
    } else {
      activeCommentIndex.value = index; // open selected
    }
  }

  void hideCommentField() {
    activeCommentIndex.value = -1;
  }

  void togglePlay() {
    isPlaying.value = !isPlaying.value;
  }

  void dispose() {
    isPlaying.dispose();
  }

  RxInt selectedIndex = 0.obs;

  void selectItem(int index) {
    selectedIndex.value = index;
  }

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
  RxBool isLoading=false.obs;
  RxList<AuditionModel> auditionList = <AuditionModel>[].obs;

  Future<void> getHomeData() async {
    isLoading(true);

    try {
      Map<String, String> header = {
        "token": PrefsHelper.token,
      };

      final response =
      await ApiService.getApi(AppUrl.getHomeAudition, header: header);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body['data']['auditions'];

        auditionList.value = List<AuditionModel>.from(
          data.map((e) => AuditionModel.fromJson(e)),
        );
      }
    } catch (e, s) {
      debugPrint("Error: $e");
      debugPrint("StackTrace: $s");
    } finally {
      isLoading(false);
    }
  }

  TextEditingController commentController=TextEditingController();

  RxBool isComment=false.obs;
  Future<void> postComment({required String id}) async {
    isLoading(true);

    try {
      Map<String, String> header = {
        "token": PrefsHelper.token,
      };

      Map<String,String> body={
        'comment':commentController.text.trim()
      };

      final response =
      await ApiService.postApi(AppUrl.postComment(id: id),body, header: header);

      if (response.statusCode == 200 || response.statusCode == 201) {
        commentController.clear();
        hideCommentField();
        getHomeData();


      }
    } catch (e, s) {
      debugPrint("Error: $e");
      debugPrint("StackTrace: $s");
    } finally {
      isLoading(false);
    }
  }


  Future<void> createLike({required String id}) async {
    isLoading(true);

    try {
      Map<String, String> header = {
        "token": PrefsHelper.token,
      };

      Map<String,String> body={};

      final response =
      await ApiService.postApi(AppUrl.createLike(id: id),body, header: header);

      if (response.statusCode == 200 || response.statusCode == 201) {
        commentController.clear();
        hideCommentField();
        getHomeData();


      }
    } catch (e, s) {
      debugPrint("Error: $e");
      debugPrint("StackTrace: $s");
    } finally {
      isLoading(false);
    }
  }
}