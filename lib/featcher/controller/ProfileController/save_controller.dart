
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:justtsham/core/constant/prefs_helper.dart';
import 'package:justtsham/core/services/api_services.dart';
import 'package:justtsham/core/utils/app_urls.dart';
import 'package:justtsham/featcher/model/CommunityModel/weekly_model.dart';

import '../../model/ProfileModel/favourite_model.dart';


class SaveController extends GetxController {




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

  RxList<FavouriteModel> faveList = <FavouriteModel>[].obs;

  /// ================= LOCAL DATA =================

  void _loadDefaultFavorites() {
    final now = DateTime.now();
    faveList.value = [
      FavouriteModel(
        id: "fav_1",
        userId: PrefsHelper.userId,
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now,
        audition: AuditionModel(
          id: "ielts_sample_1",
          title: "AI Tools in Higher Education",
          category: "Technology & AI",
          auditionFile: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
          status: "Band 8.5 Model Answer",
          isLiked: true,
          likeCount: 42,
          commentCount: 9,
          createdAt: now,
          updatedAt: now,
          creator: Creator(
            id: "c_1",
            fullName: "Sarah Jenkins",
            profileImage: "",
          ),
        ),
      ),
      FavouriteModel(
        id: "fav_2",
        userId: PrefsHelper.userId,
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now,
        audition: AuditionModel(
          id: "ielts_sample_4",
          title: "Backpacking Himalayan Journey",
          category: "Travel & Culture",
          auditionFile: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3",
          status: "Band 9.0 Model Answer",
          isLiked: true,
          likeCount: 89,
          commentCount: 21,
          createdAt: now,
          updatedAt: now,
          creator: Creator(
            id: "c_4",
            fullName: "Michael Chang",
            profileImage: "",
          ),
        ),
      ),
    ];
  }

  /// ================= API =================

  Future<void> getFavourite() async {
    _loadDefaultFavorites();
    isLoading(false);
  }

}