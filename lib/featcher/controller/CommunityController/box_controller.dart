
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
    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _handlePlaybackComplete();
      } else if (!state.playing &&
          state.processingState != ProcessingState.buffering &&
          state.processingState != ProcessingState.loading) {
        isPlaying.value = false;
      }
    });

    player.positionStream.listen((pos) {
      position.value = pos;
      updateProgress();

      if (duration.value > Duration.zero &&
          pos >= duration.value &&
          duration.value.inMilliseconds > 0) {
        _handlePlaybackComplete();
      }
    });

    player.durationStream.listen((dur) {
      if (dur != null) {
        duration.value = dur;
      }
    });
  }

  void _handlePlaybackComplete() {
    isPlaying.value = false;
    progress.value = 0.0;
    position.value = Duration.zero;
    player.pause();
    player.seek(Duration.zero);
  }

  void updateProgress() {
    if (duration.value.inMilliseconds == 0) return;

    progress.value =
        position.value.inMilliseconds / duration.value.inMilliseconds;
  }

  Future<void> togglePlay(String rawUrl) async {
    try {
      final url = AppUrl.getFullUrl(rawUrl);
      if (url.isEmpty) return;

      // 1. Switching to a new audio track
      if (currentUrl.value != url) {
        currentUrl.value = url;
        isPlaying.value = true;
        progress.value = 0.0;
        position.value = Duration.zero;

        await player.stop();
        await player.setUrl(url);
        player.play();
        return;
      }

      // 2. If finished, replay immediately from beginning
      if (player.processingState == ProcessingState.completed ||
          (duration.value > Duration.zero && position.value >= duration.value)) {
        isPlaying.value = true;
        progress.value = 0.0;
        position.value = Duration.zero;
        await player.seek(Duration.zero);
        player.play();
        return;
      }

      // 3. Instant toggle for current track (0ms UI latency)
      if (isPlaying.value) {
        isPlaying.value = false;
        player.pause();
      } else {
        isPlaying.value = true;
        player.play();
      }
    } catch (e) {
      isPlaying.value = false;
      currentUrl.value = "";
      debugPrint("Audio Error: $e");
      final msg = e.toString().toLowerCase();
      if (msg.contains('404') || msg.contains('not found') || msg.contains('-1100')) {
        Get.snackbar("Audio Unavailable", "This audio file is no longer available.",
            snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 2));
      } else {
        Get.snackbar("Playback Error", "Could not play this audio.",
            snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 2));
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
    "Technology & AI",
    "Work & Study",
    "Environment & Nature",
    "Travel & Culture",
    "People & Society",
    "Events & Experiences",
  ];

  RxBool isLoading = false.obs;

  RxList<CommunityModel> communityList = <CommunityModel>[].obs;

  /// ================= LOCAL DATA =================

  void _loadDefaultCommunity() {
    final now = DateTime.now();
    communityList.value = [
      CommunityModel(
        id: "comm_1",
        category: "Technology & AI",
        duration: "02:15",
        toneStyle: "Band 8.5 Academic",
        content: "Describe an AI tool you find useful - Comprehensive response focusing on natural language processing.",
        audioFile: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
        createdAt: now.subtract(const Duration(hours: 3)),
        updatedAt: now,
        user: UserModel(
          id: "u_1",
          fullName: "Sarah Jenkins (Band 8.5)",
          profileImage: "",
        ),
      ),
      CommunityModel(
        id: "comm_2",
        category: "Work & Study",
        duration: "01:58",
        toneStyle: "Band 8.0 Fluent",
        content: "Describe an ambitious career goal - Discussion on sustainable engineering.",
        audioFile: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
        createdAt: now.subtract(const Duration(hours: 8)),
        updatedAt: now,
        user: UserModel(
          id: "u_2",
          fullName: "Daniel Rahman (Band 8.0)",
          profileImage: "",
        ),
      ),
      CommunityModel(
        id: "comm_3",
        category: "Travel & Culture",
        duration: "02:20",
        toneStyle: "Band 9.0 Native-like",
        content: "Describe an unforgettable journey - Backpacking through the high passes of the Himalayas.",
        audioFile: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3",
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now,
        user: UserModel(
          id: "u_3",
          fullName: "Michael Chang (Band 9.0)",
          profileImage: "",
        ),
      ),
    ];
  }

  /// ================= API =================

  Future<void> getBoxData() async {
    _loadDefaultCommunity();
    isLoading(false);
  }

  RxBool isInterested=false.obs;
  Future<bool> notInterestedCommunity({required String id, required String action}) async {
    communityList.removeWhere((item) => item.id == id);
    return true;
  }

}