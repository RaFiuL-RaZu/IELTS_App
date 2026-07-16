
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:justtsham/core/constant/prefs_helper.dart';
import 'package:justtsham/core/services/api_services.dart';
import 'package:justtsham/core/utils/app_urls.dart';
import 'package:justtsham/featcher/model/CommunityModel/weekly_model.dart';

import '../../model/HomeModel/audition_model.dart';

class BoxController extends GetxController {




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
        currentUrl.value = url;
        isPlaying.value = true;

        await player.stop();

        await player.setUrl(url);

        await player.play();
        return;
      }

      if (player.playing) {
        isPlaying.value = false;
        await player.pause();
      } else {
        isPlaying.value = true;
        await player.play();
      }
    } catch (e) {
      isPlaying.value = false;
      currentUrl.value = "";
      debugPrint("Audio Error: $e");
      final msg = e.toString().toLowerCase();
      if (msg.contains('404') || msg.contains('not found') || msg.contains('-1100')) {
        Get.snackbar("Audio Unavailable", "This audio file is no longer available.",
            snackPosition: SnackPosition.TOP, duration: Duration(seconds: 2));
      } else {
        Get.snackbar("Playback Error", "Could not play this audio.",
            snackPosition: SnackPosition.TOP, duration: Duration(seconds: 2));
      }
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

  RxBool isLoading = false.obs;

  RxList<CommunityModel> communityList = <CommunityModel>[].obs;



  /// ================= API =================

  Future<void> getBoxData() async {
    isLoading(true);

    try {
      Map<String, String> header = {
        "token": PrefsHelper.token,
      };

      final response =
      await ApiService.getApi(AppUrl.getCommunityData, header: header);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body['data']['communityList'];

        communityList.value = List<CommunityModel>.from(
          data.map((e) => CommunityModel.fromJson(e)),
        );
      }
    } catch (e, s) {
      debugPrint("Error: $e");
      debugPrint("StackTrace: $s");
    } finally {
      isLoading(false);
    }
  }


  RxBool isInterested=false.obs;
  Future<bool> notInterestedCommunity({required String id, required String action}) async {
    isInterested.value = true;

    try {
      final header = {
        "token": PrefsHelper.token,
      };
      final body = {
        "action": action
      };

      final response = await ApiService.patchApi(
          AppUrl.interestedCommunity(id: id),
          body:body,
          header: header

      );

      if (response.statusCode == 200) {
        communityList.removeWhere((item) => item.id == id);
        return true;
      }

      return false;
    } finally {
      isInterested.value = false;
    }
  }

}