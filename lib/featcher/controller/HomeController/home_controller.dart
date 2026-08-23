import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:justtsham/core/constant/prefs_helper.dart';
import 'package:justtsham/core/utils/app_urls.dart';
import 'package:justtsham/featcher/model/HomeModel/audition_model.dart';
import 'package:justtsham/featcher/model/HomeModel/comment_model.dart';

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
    "Technology & AI",
    "Work & Study",
    "Environment & Nature",
    "Travel & Culture",
    "People & Society",
    "Events & Experiences",
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
        .replaceAll("&", "")
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

  void _loadDefaultIeltsAuditions() {
    final now = DateTime.now();
    final List<AuditionModel> sampleList = [
      AuditionModel(
        id: "ielts_sample_1",
        title: "AI Tools in Higher Education",
        category: "Technology & AI",
        auditionFile: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
        status: "active",
        isLiked: false,
        likeCount: 42,
        commentCount: 9,
        createdAt: now,
        updatedAt: now,
        creator: Creator(
          id: "creator_1",
          fullName: "Sarah Jenkins",
          profileImage: "",
          createdAt: now,
        ),
      ),
      AuditionModel(
        id: "ielts_sample_2",
        title: "Overcoming Study Milestones",
        category: "Work & Study",
        auditionFile: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
        status: "active",
        isLiked: false,
        likeCount: 38,
        commentCount: 7,
        createdAt: now,
        updatedAt: now,
        creator: Creator(
          id: "creator_2",
          fullName: "Daniel Rahman",
          profileImage: "",
          createdAt: now,
        ),
      ),
      AuditionModel(
        id: "ielts_sample_3",
        title: "Community Reforestation",
        category: "Environment & Nature",
        auditionFile: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3",
        status: "active",
        isLiked: false,
        likeCount: 56,
        commentCount: 14,
        createdAt: now,
        updatedAt: now,
        creator: Creator(
          id: "creator_3",
          fullName: "Elena Rostova",
          profileImage: "",
          createdAt: now,
        ),
      ),
      AuditionModel(
        id: "ielts_sample_4",
        title: "Backpacking Himalayan Journey",
        category: "Travel & Culture",
        auditionFile: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3",
        status: "active",
        isLiked: true,
        likeCount: 89,
        commentCount: 21,
        createdAt: now,
        updatedAt: now,
        creator: Creator(
          id: "creator_4",
          fullName: "Michael Chang",
          profileImage: "",
          createdAt: now,
        ),
      ),
    ];

    auditionList.value = sampleList;
    applyFilter();
  }

  /// ================= API =================

  Future<void> getHomeData() async {
    _loadDefaultIeltsAuditions();
    isLoading(false);
  }

  RxList<CommentModel> commentList = <CommentModel>[].obs;
  RxBool isComment = false.obs;
  Future<void> getComment({required String id}) async {
    isComment(true);

    commentList.value = [
      CommentModel(
        id: "local_c1",
        auditionId: id,
        comment: "Great fluency and lexical coherence! Natural pronunciation.",
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
        user: UserModel(
          id: "local_u1",
          fullName: "David Miller (Band 8.0)",
          profileImage: "",
        ),
      ),
      CommentModel(
        id: "local_c2",
        auditionId: id,
        comment: "Excellent use of complex grammar structures.",
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
        user: UserModel(
          id: "local_u2",
          fullName: "Sophia Chen (Band 8.5)",
          profileImage: "",
        ),
      ),
    ];
    isComment(false);
  }

  RxBool isFavourite = false.obs;
  Future<bool> addBookMark({required String id}) async {
    final index = auditionList.indexWhere((item) => item.id == id);
    if (index != -1) {
      auditionList[index].isFavorite.value = true;
    }
    return true;
  }

  RxBool isUnFav = false.obs;

  Future<bool> deleteBookMark({required String id}) async {
    final index = auditionList.indexWhere((item) => item.id == id);
    if (index != -1) {
      auditionList[index].isFavorite.value = false;
    }
    return true;
  }

  RxBool isInterested = false.obs;
  Future<bool> notInterested({required String id}) async {
    filteredList.removeWhere((item) => item.id == id);
    return true;
  }

  RxBool isBlock=false.obs;
  Future<bool> userBlock({required String id}) async {
    filteredList.removeWhere((item) => item.creator.id == id);
    Get.snackbar("Blocked", "User has been blocked successfully.");
    return true;
  }

  Future<bool> deleteComment({required String id}) async {
    commentList.removeWhere((item) => item.id == id);
    return true;
  }

  Future<void> postComment({required String id}) async {
    final text = commentController.text.trim();
    if (text.isEmpty) return;

    // Add locally
    commentList.insert(
      0,
      CommentModel(
        id: "local_${DateTime.now().millisecondsSinceEpoch}",
        auditionId: id,
        comment: text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        user: UserModel(
          id: "me",
          fullName: PrefsHelper.myName.isEmpty ? "You" : PrefsHelper.myName,
          profileImage: "",
        ),
      ),
    );

    final index = auditionList.indexWhere((item) => item.id == id);
    if (index != -1) {
      auditionList[index].commentCount++;
      auditionList.refresh();
    }

    commentController.clear();
    hideCommentField();
  }

  RxBool isLiked = false.obs;
  Future<void> createLike({required String id}) async {
    final index = auditionList.indexWhere((item) => item.id == id);

    if (index != -1) {
      final item = auditionList[index];
      final newLikedState = !item.isLiked.value;
      item.isLiked.value = newLikedState;

      if (newLikedState) {
        item.likeCount++;
      } else {
        if (item.likeCount > 0) item.likeCount--;
      }
      auditionList.refresh();
    }
  }
}
