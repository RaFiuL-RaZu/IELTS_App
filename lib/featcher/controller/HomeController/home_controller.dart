import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:justtsham/core/constant/prefs_helper.dart';
import 'package:justtsham/core/services/api_services.dart';
import 'package:justtsham/core/utils/app_urls.dart';
import 'package:justtsham/featcher/model/HomeModel/comment_model.dart';

import '../../model/HomeModel/audition_model.dart';

class HomeController extends GetxController {
  final AudioPlayer player = AudioPlayer();

  RxString currentUrl = "".obs;
  RxBool isPlaying = false.obs;

  Rx<Duration> position = Duration.zero.obs;
  Rx<Duration> duration = Duration.zero.obs;

  RxDouble progress = 0.0.obs;
  var expandedIndex = (-1).obs;

  void toggleExpand(int index) {
    if (expandedIndex.value == index) {
      expandedIndex.value = -1;
    } else {
      expandedIndex.value = index;
    }
  }

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
    activeCommentIndex.value = activeCommentIndex.value == index ? -1 : index;
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

  // Track liked items
  RxSet<String> likedItemIds = <String>{}.obs;

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
      Map<String, String> header = {"token": PrefsHelper.token};

      final response = await ApiService.getApi(
        AppUrl.getHomeAudition,
        header: header,
      );

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

  RxList<CommentModel> commentList = <CommentModel>[].obs;
  RxBool isComment = false.obs;
  Future<void> getComment({required String id}) async {
    isComment(true);

    try {
      Map<String, String> header = {"token": PrefsHelper.token};

      final response = await ApiService.getApi(
        AppUrl.getComment(id: id),
        header: header,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body['data']['comment'];

        commentList.value = List<CommentModel>.from(
          data.map((e) => CommentModel.fromJson(e)),
        );

        applyFilter();
      }
    } catch (e, s) {
      debugPrint("Error: $e");
      debugPrint("StackTrace: $s");
    } finally {
      isComment(false);
    }
  }

  RxBool isFavourite = false.obs;
  Future<bool> addBookMark({required String id}) async {
    isFavourite.value = true;

    try {
      final header = {"token": PrefsHelper.token};

      final body = {"auditionId": id};

      final response = await ApiService.postApi(
        AppUrl.createFav,
        body,
        header: header,
      );

      return response.statusCode == 200;
    } finally {
      isFavourite.value = false;
    }
  }

  RxBool isUnFav = false.obs;

  Future<bool> deleteBookMark({required String id}) async {
    isUnFav.value = true;

    try {
      final header = {"token": PrefsHelper.token};

      final body = {"auditionId": id};

      final response = await ApiService.deleteApi(
        AppUrl.deleteFav,
        header: header,
        body: body,
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    } finally {
      isUnFav.value = false;
    }
  }

  RxBool isInterested = false.obs;
  Future<bool> notInterested({required String id}) async {
    isInterested.value = true;

    try {
      final header = {"token": PrefsHelper.token};
      final body = {"action": "notInterested"};

      final response = await ApiService.patchApi(
        AppUrl.interested(id: id),
        body: body,
        header: header,
      );

      if (response.statusCode == 200) {
        filteredList.removeWhere((item) => item.id == id);
        return true;
      }

      return false;
    } finally {
      isInterested.value = false;
    }
  }

  Future<bool> deleteComment({required String id}) async {
    isInterested.value = true;

    try {
      final header = {"token": PrefsHelper.token};
      Map<String, String> body = {};

      final response = await ApiService.deleteApi(
        AppUrl.deleteComment(id: id),
        body: body,
        header: header,
      );

      if (response.statusCode == 200) {
        commentList.removeWhere((item) => item.id == id);
        return true;
      }

      return false;
    } finally {
      isInterested.value = false;
    }
  }

  Future<void> postComment({required String id}) async {
    try {
      Map<String, String> header = {"token": PrefsHelper.token};

      Map<String, String> body = {'comment': commentController.text.trim()};

      final response = await ApiService.postApi(
        AppUrl.postComment(id: id),
        body,
        header: header,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        commentController.clear();
        hideCommentField();

        final index = auditionList.indexWhere((item) => item.id == id);
        if (index != -1) {
          final updatedItem = AuditionModel(
            id: auditionList[index].id,
            creator: auditionList[index].creator,
            title: auditionList[index].title,
            category: auditionList[index].category,
            reminderDate: auditionList[index].reminderDate,
            status: auditionList[index].status,
            auditionFile: auditionList[index].auditionFile,
            likeCount: auditionList[index].likeCount,
            commentCount: auditionList[index].commentCount + 1,
            createdAt: auditionList[index].createdAt,
            updatedAt: auditionList[index].updatedAt,
            isLiked: auditionList[index].isLiked.value,
            isFavorite: auditionList[index].isFavorite.value,
          );
          auditionList[index] = updatedItem;
          applyFilter();
        }
      }
    } catch (e, s) {
      debugPrint("Error: $e");
      debugPrint("StackTrace: $s");
    }
  }

  RxBool isLiked = false.obs;
  Future<void> createLike({required String id}) async {
    try {
      final response = await ApiService.postApi(
        AppUrl.createLike(id: id),
        {},
        header: {"token": PrefsHelper.token},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body['data'];
        final liked = data?['liked'] ?? false;

        final index = auditionList.indexWhere((item) => item.id == id);

        if (index != -1) {
          final item = auditionList[index];

          item.isLiked.value = liked;

          if (liked) {
            item.likeCount++;
          } else {
            if (item.likeCount > 0) item.likeCount--;
          }

          auditionList.refresh();
        }
      }
    } catch (e) {
      debugPrint("Like Error: $e");
    }
  }
}
