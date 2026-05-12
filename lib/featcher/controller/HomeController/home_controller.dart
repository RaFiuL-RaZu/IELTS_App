
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:justtsham/core/constant/prefs_helper.dart';
import 'package:justtsham/core/services/api_services.dart';
import 'package:justtsham/core/utils/app_urls.dart';

import '../../model/HomeModel/audition_model.dart';

class HomeController extends GetxController {


  final AudioPlayer player = AudioPlayer();

  RxString currentUrl = "".obs;
  RxBool isPlaying = false.obs;

  Rx<Duration> position = Duration.zero.obs;
  Rx<Duration> duration = Duration.zero.obs;

  RxDouble progress = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _initAudioListener();
  }

  void _initAudioListener() {
    player.positionStream.listen((pos) {
      position.value = pos;
      updateProgress();
    });

    player.durationStream.listen((dur) {
      if (dur != null) {
        duration.value = dur;
      }
    });
  }

  void updateProgress() {
    if (duration.value.inMilliseconds == 0) return;

    progress.value =
        position.value.inMilliseconds / duration.value.inMilliseconds;
  }

  Future<void> togglePlay(String url) async {
    try {
      debugPrint("url : $url");
      if (currentUrl.value != url) {
        await player.stop();
        currentUrl.value = url;
        await player.setUrl(url);
        await player.play();
        isPlaying.value = true;
        return;
      }

      if (player.playing) {
        await player.pause();
        isPlaying.value = false;
      } else {
        await player.play();
        isPlaying.value = true;
      }
    } catch (e) {
      debugPrint("Audio Error: $e");
    }
  }

  String formatTime(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final m = two(d.inMinutes.remainder(60));
    final s = two(d.inSeconds.remainder(60));
    return "$m:$s";
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }


  /// ================= UI STATES =================

  RxInt activeCommentIndex = (-1).obs;

  void toggleCommentField(int index) {
    activeCommentIndex.value =
    activeCommentIndex.value == index ? -1 : index;
  }

  void hideCommentField() {
    activeCommentIndex.value = -1;
  }

  TextEditingController commentController = TextEditingController();

  /// ================= FILTER =================

  RxInt selectedIndex = 0.obs;

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

  void selectItem(int index) {
    selectedIndex.value = index;
    applyFilter();
  }

  RxBool isLoading = false.obs;

  RxList<AuditionModel> auditionList = <AuditionModel>[].obs;
  RxList<AuditionModel> filteredList = <AuditionModel>[].obs;

  String normalize(String text) {
    return text
        .toUpperCase()
        .replaceAll("-", "")
        .replaceAll("_", "")
        .replaceAll(" ", "")
        .trim();
  }

  void applyFilter() {
    final selected = items[selectedIndex.value];

    if (selected == "All") {
      filteredList.value = auditionList;
      return;
    }

    filteredList.value = auditionList.where((e) {
      return normalize(e.category ?? "") == normalize(selected);
    }).toList();
  }

  /// ================= API =================

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

        applyFilter();
      }
    } catch (e, s) {
      debugPrint("Error: $e");
      debugPrint("StackTrace: $s");
    } finally {
      isLoading(false);
    }
  }

  Future<void> postComment({required String id}) async {
    isLoading(true);

    try {
      Map<String, String> header = {
        "token": PrefsHelper.token,
      };

      Map<String, String> body = {
        'comment': commentController.text.trim()
      };

      final response = await ApiService.postApi(
        AppUrl.postComment(id: id),
        body,
        header: header,
      );

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
    try {
      Map<String, String> header = {
        "token": PrefsHelper.token,
      };

      await ApiService.postApi(
        AppUrl.createLike(id: id),
        {},
        header: header,
      );

      getHomeData();
    } catch (e) {
      debugPrint("Like Error: $e");
    }
  }
}