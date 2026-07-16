import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/constant/prefs_helper.dart';
import 'package:justtsham/core/services/api_services.dart';
import 'package:justtsham/core/utils/app_urls.dart';
import 'package:justtsham/featcher/model/CommunityModel/community_model.dart';
import 'package:waveform_flutter/waveform_flutter.dart';

class CommunityController extends GetxController {

  static CommunityController get instance=>Get.put(CommunityController());


  var expandedIndex = (-1).obs;

  void toggleExpand(int index) {
    if (expandedIndex.value == index) {
      expandedIndex.value = -1;
    } else {
      expandedIndex.value = index;
    }
  }

  final ValueNotifier<bool> isPlaying = ValueNotifier(false);

  void togglePlay() {
    isPlaying.value = !isPlaying.value;
  }

  void dispose() {
    isPlaying.dispose();
  }

  RxInt selectedIndex = (-1).obs;

  void selectItem(int index) {
    if (selectedIndex.value == index) {
      selectedIndex.value = -1;
    } else {
      selectedIndex.value = index;
    }
  }
  // Recording state
  var isRecording = false.obs;

  // Timer
  var seconds = 0.obs;
  Timer? timer;

  // Mic stream
  late Stream<Amplitude> micStream;

  @override
  void onInit() {
    super.onInit();
  }

  /// Start Recording
  void startRecording() {
    isRecording.value = true;
    seconds.value = 0;

    // 🔥 important: new stream each time
    micStream = createRandomAmplitudeStream();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      seconds.value++;
    });
  }

  /// Stop Recording
  void stopRecording() {
    isRecording.value = false;
    timer?.cancel();
  }

  /// Toggle
  void toggleRecording() {
    if (isRecording.value) {
      stopRecording();
    } else {
      startRecording();
    }
  }

  String get formattedTime {
    final minutes = (seconds.value ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds.value % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }
  RxBool isLoading=false.obs;

  WeeklyModel? weeklyModel;

  Future<void> getCommunity() async {
    isLoading(true);

    try {
      Map<String, String> header = {
        'token': PrefsHelper.token
      };

      final response =
      await ApiService.getApi(AppUrl.weeklyScript, header: header);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;

        if (body['data'] != null) {
          weeklyModel = WeeklyModel.fromJson(body['data']);
        } else {
          debugPrint("API returned null data");

          weeklyModel = null;
        }
      }
    } catch (e, s) {
      debugPrint("Error Handling : $e");
      debugPrint("SnackTrack Error : $s");
    } finally {
      isLoading(false);
    }
  }






  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}