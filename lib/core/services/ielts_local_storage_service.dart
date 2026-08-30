import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IeltsTestResult {
  final String id;
  final String skill; // Listening, Reading, Writing, Speaking
  final String testName;
  final int score;
  final int totalQuestions;
  final double accuracy;
  final double bandScore;
  final String date;

  IeltsTestResult({
    required this.id,
    required this.skill,
    required this.testName,
    required this.score,
    required this.totalQuestions,
    required this.accuracy,
    required this.bandScore,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'skill': skill,
    'testName': testName,
    'score': score,
    'totalQuestions': totalQuestions,
    'accuracy': accuracy,
    'bandScore': bandScore,
    'date': date,
  };

  factory IeltsTestResult.fromJson(Map<String, dynamic> json) => IeltsTestResult(
    id: json['id'] ?? '',
    skill: json['skill'] ?? '',
    testName: json['testName'] ?? '',
    score: (json['score'] ?? 0) as int,
    totalQuestions: (json['totalQuestions'] ?? 0) as int,
    accuracy: (json['accuracy'] ?? 0.0).toDouble(),
    bandScore: (json['bandScore'] ?? 0.0).toDouble(),
    date: json['date'] ?? '',
  );
}

class IeltsProgressController extends GetxController {
  static IeltsProgressController get to => Get.find<IeltsProgressController>();

  // Candidate Profile State
  var candidateName = "IELTS Aspirant".obs;
  var targetBand = 8.0.obs;
  var examDaysRemaining = 28.obs;
  var examModule = "Academic".obs; // Academic vs General Training
  var overallBand = 7.5.obs;
  var overallAccuracy = 84.5.obs;

  double get overallBandScore => overallBand.value;

  // Individual Skill Bands
  var listeningBand = 8.0.obs;
  var readingBand = 7.5.obs;
  var writingBand = 7.0.obs;
  var speakingBand = 7.5.obs;

  // Individual Skill Accuracies
  var listeningAccuracy = 88.0.obs;
  var readingAccuracy = 82.0.obs;
  var writingAccuracy = 78.0.obs;
  var speakingAccuracy = 85.0.obs;

  // Daily Study Routine Checkboxes
  var speakingTaskDone = false.obs;
  var listeningTaskDone = false.obs;
  var readingTaskDone = false.obs;
  var writingTaskDone = false.obs;

  // Test History Log
  var testHistory = <IeltsTestResult>[].obs;

  // Bookmarks
  var savedCueCardIds = <String>{}.obs;
  var savedVocabWords = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadFromLocalStorage();
  }

  Future<void> loadFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      candidateName.value = prefs.getString('candidate_name') ?? prefs.getString('myName') ?? "IELTS Aspirant";
      targetBand.value = prefs.getDouble('target_band') ?? 8.0;
      examDaysRemaining.value = prefs.getInt('exam_days_remaining') ?? 28;
      examModule.value = prefs.getString('exam_module') ?? "Academic";

      listeningBand.value = prefs.getDouble('listening_band') ?? 8.0;
      readingBand.value = prefs.getDouble('reading_band') ?? 7.5;
      writingBand.value = prefs.getDouble('writing_band') ?? 7.0;
      speakingBand.value = prefs.getDouble('speaking_band') ?? 7.5;

      listeningAccuracy.value = prefs.getDouble('listening_acc') ?? 88.0;
      readingAccuracy.value = prefs.getDouble('reading_acc') ?? 82.0;
      writingAccuracy.value = prefs.getDouble('writing_acc') ?? 78.0;
      speakingAccuracy.value = prefs.getDouble('speaking_acc') ?? 85.0;

      speakingTaskDone.value = prefs.getBool('speaking_task_done') ?? true;
      listeningTaskDone.value = prefs.getBool('listening_task_done') ?? true;
      readingTaskDone.value = prefs.getBool('reading_task_done') ?? false;
      writingTaskDone.value = prefs.getBool('writing_task_done') ?? false;

      final historyJson = prefs.getString('test_history');
      if (historyJson != null) {
        final List decoded = jsonDecode(historyJson);
        testHistory.value = decoded.map((e) => IeltsTestResult.fromJson(e)).toList();
      } else {
        // Seed default high-quality initial practice history
        testHistory.value = [
          IeltsTestResult(
            id: "1",
            skill: "Listening",
            testName: "Cambridge 18 - Section 1 Hotel Booking",
            score: 9,
            totalQuestions: 10,
            accuracy: 90.0,
            bandScore: 8.0,
            date: "Today, 10:30 AM",
          ),
          IeltsTestResult(
            id: "2",
            skill: "Reading",
            testName: "Academic Passage 1 - Renewable Tech",
            score: 11,
            totalQuestions: 13,
            accuracy: 84.6,
            bandScore: 7.5,
            date: "Yesterday, 04:15 PM",
          ),
          IeltsTestResult(
            id: "3",
            skill: "Speaking",
            testName: "Cue Card - Artificial Intelligence in Higher Ed",
            score: 8,
            totalQuestions: 9,
            accuracy: 88.0,
            bandScore: 7.5,
            date: "2 days ago",
          ),
        ];
      }

      final savedCards = prefs.getStringList('saved_cue_cards');
      if (savedCards != null) {
        savedCueCardIds.value = savedCards.toSet();
      }

      final savedWords = prefs.getStringList('saved_vocab');
      if (savedWords != null) {
        savedVocabWords.value = savedWords.toSet();
      }

      _recalculateStats();
    } catch (e) {
      debugPrint("Error loading IELTS local storage: $e");
    }
  }

  Future<void> saveToLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('candidate_name', candidateName.value);
      await prefs.setDouble('target_band', targetBand.value);
      await prefs.setInt('exam_days_remaining', examDaysRemaining.value);
      await prefs.setString('exam_module', examModule.value);

      await prefs.setDouble('listening_band', listeningBand.value);
      await prefs.setDouble('reading_band', readingBand.value);
      await prefs.setDouble('writing_band', writingBand.value);
      await prefs.setDouble('speaking_band', speakingBand.value);

      await prefs.setDouble('listening_acc', listeningAccuracy.value);
      await prefs.setDouble('reading_acc', readingAccuracy.value);
      await prefs.setDouble('writing_acc', writingAccuracy.value);
      await prefs.setDouble('speaking_acc', speakingAccuracy.value);

      await prefs.setBool('speaking_task_done', speakingTaskDone.value);
      await prefs.setBool('listening_task_done', listeningTaskDone.value);
      await prefs.setBool('reading_task_done', readingTaskDone.value);
      await prefs.setBool('writing_task_done', writingTaskDone.value);

      final historyJson = jsonEncode(testHistory.map((e) => e.toJson()).toList());
      await prefs.setString('test_history', historyJson);

      await prefs.setStringList('saved_cue_cards', savedCueCardIds.toList());
      await prefs.setStringList('saved_vocab', savedVocabWords.toList());
    } catch (e) {
      debugPrint("Error saving IELTS local storage: $e");
    }
  }

  void addTestResult({
    required String skill,
    required String testName,
    required int score,
    required int totalQuestions,
    required double bandScore,
  }) {
    final accuracy = totalQuestions > 0 ? (score / totalQuestions) * 100 : 0.0;
    final newResult = IeltsTestResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      skill: skill,
      testName: testName,
      score: score,
      totalQuestions: totalQuestions,
      accuracy: double.parse(accuracy.toStringAsFixed(1)),
      bandScore: bandScore,
      date: "Just now",
    );

    testHistory.insert(0, newResult);
    testHistory.refresh();
    _recalculateStats();
    saveToLocalStorage();
  }

  IeltsTestResult? getLatestTestResult(String query) {
    final cleanQuery = query.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), ' ').trim();
    if (cleanQuery.isEmpty) return null;

    for (var t in testHistory) {
      final cleanName = t.testName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), ' ').trim();
      if (cleanName == cleanQuery) {
        return t;
      }
      if (cleanQuery.length >= 15 && cleanName.contains(cleanQuery)) {
        return t;
      }
      if (cleanName.length >= 15 && cleanQuery.contains(cleanName)) {
        return t;
      }
    }
    return null;
  }

  void toggleSpeakingTask() {
    speakingTaskDone.value = !speakingTaskDone.value;
    saveToLocalStorage();
  }

  void toggleListeningTask() {
    listeningTaskDone.value = !listeningTaskDone.value;
    saveToLocalStorage();
  }

  void toggleReadingTask() {
    readingTaskDone.value = !readingTaskDone.value;
    saveToLocalStorage();
  }

  void toggleWritingTask() {
    writingTaskDone.value = !writingTaskDone.value;
    saveToLocalStorage();
  }

  void toggleCueCardBookmark(String cardId) {
    if (savedCueCardIds.contains(cardId)) {
      savedCueCardIds.remove(cardId);
    } else {
      savedCueCardIds.add(cardId);
    }
    saveToLocalStorage();
  }

  void toggleVocabBookmark(String word) {
    if (savedVocabWords.contains(word)) {
      savedVocabWords.remove(word);
    } else {
      savedVocabWords.add(word);
    }
    saveToLocalStorage();
  }

  void setTargetBand(double band) {
    targetBand.value = band;
    saveToLocalStorage();
  }

  void setExamModule(String module) {
    examModule.value = module;
    saveToLocalStorage();
  }

  Future<void> updateCandidateName(String newName) async {
    candidateName.value = newName;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('candidate_name', newName);
    await prefs.setString('myName', newName);
  }

  void _recalculateStats() {
    if (testHistory.isEmpty) return;

    double totalAcc = 0;
    double readingAccSum = 0; int readingCount = 0;
    double listeningAccSum = 0; int listeningCount = 0;
    double writingAccSum = 0; int writingCount = 0;
    double speakingAccSum = 0; int speakingCount = 0;

    double? latestReadingBand;
    double? latestListeningBand;
    double? latestWritingBand;
    double? latestSpeakingBand;

    for (var r in testHistory) {
      totalAcc += r.accuracy;
      if (r.skill == "Reading") {
        readingAccSum += r.accuracy;
        readingCount++;
        latestReadingBand ??= r.bandScore;
      } else if (r.skill == "Listening") {
        listeningAccSum += r.accuracy;
        listeningCount++;
        latestListeningBand ??= r.bandScore;
      } else if (r.skill == "Writing") {
        writingAccSum += r.accuracy;
        writingCount++;
        latestWritingBand ??= r.bandScore;
      } else if (r.skill == "Speaking") {
        speakingAccSum += r.accuracy;
        speakingCount++;
        latestSpeakingBand ??= r.bandScore;
      }
    }

    overallAccuracy.value = double.parse((totalAcc / testHistory.length).toStringAsFixed(1));

    if (readingCount > 0) {
      readingAccuracy.value = double.parse((readingAccSum / readingCount).toStringAsFixed(1));
      if (latestReadingBand != null) readingBand.value = latestReadingBand;
    }
    if (listeningCount > 0) {
      listeningAccuracy.value = double.parse((listeningAccSum / listeningCount).toStringAsFixed(1));
      if (latestListeningBand != null) listeningBand.value = latestListeningBand;
    }
    if (writingCount > 0) {
      writingAccuracy.value = double.parse((writingAccSum / writingCount).toStringAsFixed(1));
      if (latestWritingBand != null) writingBand.value = latestWritingBand;
    }
    if (speakingCount > 0) {
      speakingAccuracy.value = double.parse((speakingAccSum / speakingCount).toStringAsFixed(1));
      if (latestSpeakingBand != null) speakingBand.value = latestSpeakingBand;
    }

    // Calculate official Cambridge overall average
    final avg = (listeningBand.value + readingBand.value + writingBand.value + speakingBand.value) / 4.0;
    final fractionalPart = avg - avg.floor();

    if (fractionalPart < 0.25) {
      overallBand.value = avg.floorToDouble();
    } else if (fractionalPart < 0.75) {
      overallBand.value = avg.floorToDouble() + 0.5;
    } else {
      overallBand.value = (avg.floor() + 1).toDouble();
    }
  }
}
