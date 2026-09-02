import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constant/prefs_helper.dart';

class IeltsTestResult {
  final String id;
  final String skill; // Listening, Reading, Writing, Speaking
  final String testName;
  final int score;
  final int totalQuestions;
  final double accuracy;
  final double bandScore;
  final String date;
  final bool isMockExam;

  IeltsTestResult({
    required this.id,
    required this.skill,
    required this.testName,
    required this.score,
    required this.totalQuestions,
    required this.accuracy,
    required this.bandScore,
    required this.date,
    this.isMockExam = false,
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
    'isMockExam': isMockExam,
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
    isMockExam: json['isMockExam'] ?? (json['testName']?.toString().toLowerCase().contains('mock') ?? false),
  );
}

class IeltsProgressController extends GetxController {
  static IeltsProgressController get to => Get.find<IeltsProgressController>();

  // Candidate Profile State
  var candidateName = "IELTS Aspirant".obs;
  var targetBand = 8.0.obs;
  var examDaysRemaining = 28.obs;
  var examDateString = "".obs;
  var examModule = "Academic".obs; // Academic vs General Training
  var overallBand = 8.0.obs;
  var overallAccuracy = 0.0.obs;

  double get overallBandScore => overallBand.value;

  int get dynamicDaysRemaining {
    if (examDateString.value.isNotEmpty) {
      try {
        final target = DateTime.parse(examDateString.value);
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final examDay = DateTime(target.year, target.month, target.day);
        final diff = examDay.difference(today).inDays;
        return diff >= 0 ? diff : 0;
      } catch (_) {}
    }
    return examDaysRemaining.value;
  }

  Future<void> setExamDate(DateTime date) async {
    final str = "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    examDateString.value = str;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final examDay = DateTime(date.year, date.month, date.day);
    final diff = examDay.difference(today).inDays;
    examDaysRemaining.value = diff >= 0 ? diff : 0;
    await saveToLocalStorage();
  }

  // Individual Skill Bands (default to target band)
  var listeningBand = 8.0.obs;
  var readingBand = 8.0.obs;
  var writingBand = 8.0.obs;
  var speakingBand = 8.0.obs;

  // Individual Skill Accuracies (0.0% for new accounts)
  var listeningAccuracy = 0.0.obs;
  var readingAccuracy = 0.0.obs;
  var writingAccuracy = 0.0.obs;
  var speakingAccuracy = 0.0.obs;

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

  String _userKey(String baseKey, {String? customName}) {
    final raw = customName ?? (PrefsHelper.myEmail.isNotEmpty ? PrefsHelper.myEmail : candidateName.value);
    final sanitized = raw.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]'), '_');
    if (sanitized.isNotEmpty && sanitized != "ielts_aspirant") {
      return 'cand_${sanitized}_$baseKey';
    }
    return baseKey;
  }

  Future<List<String>> getRegisteredCandidates() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList('registered_candidates_list') ?? [];
    } catch (_) {
      return [];
    }
  }

  Future<bool> doesCandidateExist(String name) async {
    final sanitized = name.trim().toLowerCase();
    if (sanitized.isEmpty) return false;
    final list = await getRegisteredCandidates();
    return list.any((e) => e.trim().toLowerCase() == sanitized);
  }

  Future<Map<String, dynamic>?> getCandidateProfileSummary(String name) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final prefix = _userKey('', customName: name);
      final savedName = prefs.getString('${prefix}candidate_name') ?? prefs.getString('candidate_name');
      if (savedName == null || savedName.isEmpty) return null;
      final target = prefs.getDouble('${prefix}target_band') ?? prefs.getDouble('target_band') ?? 8.0;
      final module = prefs.getString('${prefix}exam_module') ?? prefs.getString('exam_module') ?? "Academic";
      final historyJson = prefs.getString('${prefix}test_history') ?? prefs.getString('test_history');
      int testCount = 0;
      if (historyJson != null) {
        try {
          final List d = jsonDecode(historyJson);
          testCount = d.length;
        } catch (_) {}
      }
      return {
        'name': savedName,
        'targetBand': target,
        'module': module,
        'testCount': testCount,
      };
    } catch (_) {
      return null;
    }
  }

  Future<void> switchCandidate(String name) async {
    await saveToLocalStorage();
    await PrefsHelper.setString("candidate_name", name);
    await PrefsHelper.setString("myName", name);
    await loadFromLocalStorage(candidateNameOverride: name);
  }

  @override
  void onInit() {
    super.onInit();
    loadFromLocalStorage();
  }

  Future<void> loadForUser(String email) async {
    await loadFromLocalStorage(userEmail: email);
  }

  Future<void> checkAndResetDailyChecklist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keyPrefix = _userKey('');
      final now = DateTime.now();
      final todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      final lastChecklistDate = prefs.getString('${keyPrefix}last_checklist_date') ?? prefs.getString('last_checklist_date') ?? "";

      if (lastChecklistDate.isNotEmpty && lastChecklistDate != todayStr) {
        speakingTaskDone.value = false;
        listeningTaskDone.value = false;
        readingTaskDone.value = false;
        writingTaskDone.value = false;

        await prefs.setString('${keyPrefix}last_checklist_date', todayStr);
        await prefs.setBool('${keyPrefix}speaking_task_done', false);
        await prefs.setBool('${keyPrefix}listening_task_done', false);
        await prefs.setBool('${keyPrefix}reading_task_done', false);
        await prefs.setBool('${keyPrefix}writing_task_done', false);
      }
    } catch (_) {}
  }

  Future<void> loadFromLocalStorage({String? userEmail, String? candidateNameOverride}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final targetName = candidateNameOverride ?? (PrefsHelper.myName.isNotEmpty ? PrefsHelper.myName : candidateName.value);
      final keyPrefix = _userKey('', customName: targetName);

      candidateName.value = prefs.getString('${keyPrefix}candidate_name') ??
          prefs.getString('candidate_name') ??
          (PrefsHelper.myName.isNotEmpty ? PrefsHelper.myName : "IELTS Aspirant");

      final target = prefs.getDouble('${keyPrefix}target_band') ?? prefs.getDouble('target_band') ?? 8.0;
      targetBand.value = target;

      examDateString.value = prefs.getString('${keyPrefix}exam_date') ?? prefs.getString('exam_date') ?? "";
      if (examDateString.value.isNotEmpty) {
        try {
          final targetDate = DateTime.parse(examDateString.value);
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final examDay = DateTime(targetDate.year, targetDate.month, targetDate.day);
          final diff = examDay.difference(today).inDays;
          examDaysRemaining.value = diff >= 0 ? diff : 0;
        } catch (_) {
          examDaysRemaining.value = prefs.getInt('${keyPrefix}exam_days_remaining') ?? prefs.getInt('exam_days_remaining') ?? 28;
        }
      } else {
        examDaysRemaining.value = prefs.getInt('${keyPrefix}exam_days_remaining') ?? prefs.getInt('exam_days_remaining') ?? 28;
      }

      examModule.value = prefs.getString('${keyPrefix}exam_module') ?? prefs.getString('exam_module') ?? "Academic";

      listeningBand.value = prefs.getDouble('${keyPrefix}listening_band') ?? prefs.getDouble('listening_band') ?? target;
      readingBand.value = prefs.getDouble('${keyPrefix}reading_band') ?? prefs.getDouble('reading_band') ?? target;
      writingBand.value = prefs.getDouble('${keyPrefix}writing_band') ?? prefs.getDouble('writing_band') ?? target;
      speakingBand.value = prefs.getDouble('${keyPrefix}speaking_band') ?? prefs.getDouble('speaking_band') ?? target;

      listeningAccuracy.value = prefs.getDouble('${keyPrefix}listening_acc') ?? prefs.getDouble('listening_acc') ?? 0.0;
      readingAccuracy.value = prefs.getDouble('${keyPrefix}reading_acc') ?? prefs.getDouble('reading_acc') ?? 0.0;
      writingAccuracy.value = prefs.getDouble('${keyPrefix}writing_acc') ?? prefs.getDouble('writing_acc') ?? 0.0;
      speakingAccuracy.value = prefs.getDouble('${keyPrefix}speaking_acc') ?? prefs.getDouble('speaking_acc') ?? 0.0;

      // Automatic Daily Checklist Reset on New Day
      final now = DateTime.now();
      final todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      final lastChecklistDate = prefs.getString('${keyPrefix}last_checklist_date') ?? prefs.getString('last_checklist_date') ?? "";

      if (lastChecklistDate.isNotEmpty && lastChecklistDate != todayStr) {
        // Next day arrived! Reset daily checklist so candidate gets a fresh 0/4 daily goal
        speakingTaskDone.value = false;
        listeningTaskDone.value = false;
        readingTaskDone.value = false;
        writingTaskDone.value = false;

        await prefs.setString('${keyPrefix}last_checklist_date', todayStr);
        await prefs.setBool('${keyPrefix}speaking_task_done', false);
        await prefs.setBool('${keyPrefix}listening_task_done', false);
        await prefs.setBool('${keyPrefix}reading_task_done', false);
        await prefs.setBool('${keyPrefix}writing_task_done', false);
      } else {
        if (lastChecklistDate.isEmpty) {
          await prefs.setString('${keyPrefix}last_checklist_date', todayStr);
        }
        speakingTaskDone.value = prefs.getBool('${keyPrefix}speaking_task_done') ?? prefs.getBool('speaking_task_done') ?? false;
        listeningTaskDone.value = prefs.getBool('${keyPrefix}listening_task_done') ?? prefs.getBool('listening_task_done') ?? false;
        readingTaskDone.value = prefs.getBool('${keyPrefix}reading_task_done') ?? prefs.getBool('reading_task_done') ?? false;
        writingTaskDone.value = prefs.getBool('${keyPrefix}writing_task_done') ?? prefs.getBool('writing_task_done') ?? false;
      }

      final historyJson = prefs.getString('${keyPrefix}test_history') ?? (keyPrefix.isEmpty ? prefs.getString('test_history') : null);
      if (historyJson != null) {
        final List decoded = jsonDecode(historyJson);
        testHistory.value = decoded.map((e) => IeltsTestResult.fromJson(e)).toList();
      } else {
        testHistory.value = [];
      }

      final savedCards = prefs.getStringList('${keyPrefix}saved_cue_cards') ?? prefs.getStringList('saved_cue_cards');
      if (savedCards != null) {
        savedCueCardIds.value = savedCards.toSet();
      } else {
        savedCueCardIds.clear();
      }

      final savedWords = prefs.getStringList('${keyPrefix}saved_vocab') ?? prefs.getStringList('saved_vocab');
      if (savedWords != null) {
        savedVocabWords.value = savedWords.toSet();
      } else {
        savedVocabWords.clear();
      }

      _recalculateStats();
    } catch (e) {
      debugPrint("Error loading IELTS local storage: $e");
    }
  }

  Future<void> saveToLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keyPrefix = _userKey('');

      final now = DateTime.now();
      final todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      await prefs.setString('${keyPrefix}last_checklist_date', todayStr);

      await prefs.setString('${keyPrefix}candidate_name', candidateName.value);
      await prefs.setDouble('${keyPrefix}target_band', targetBand.value);
      await prefs.setInt('${keyPrefix}exam_days_remaining', examDaysRemaining.value);
      await prefs.setString('${keyPrefix}exam_date', examDateString.value);
      await prefs.setString('${keyPrefix}exam_module', examModule.value);

      await prefs.setDouble('${keyPrefix}listening_band', listeningBand.value);
      await prefs.setDouble('${keyPrefix}reading_band', readingBand.value);
      await prefs.setDouble('${keyPrefix}writing_band', writingBand.value);
      await prefs.setDouble('${keyPrefix}speaking_band', speakingBand.value);

      await prefs.setDouble('${keyPrefix}listening_acc', listeningAccuracy.value);
      await prefs.setDouble('${keyPrefix}reading_acc', readingAccuracy.value);
      await prefs.setDouble('${keyPrefix}writing_acc', writingAccuracy.value);
      await prefs.setDouble('${keyPrefix}speaking_acc', speakingAccuracy.value);

      await prefs.setBool('${keyPrefix}speaking_task_done', speakingTaskDone.value);
      await prefs.setBool('${keyPrefix}listening_task_done', listeningTaskDone.value);
      await prefs.setBool('${keyPrefix}reading_task_done', readingTaskDone.value);
      await prefs.setBool('${keyPrefix}writing_task_done', writingTaskDone.value);

      final historyJson = jsonEncode(testHistory.map((e) => e.toJson()).toList());
      await prefs.setString('${keyPrefix}test_history', historyJson);

      await prefs.setStringList('${keyPrefix}saved_cue_cards', savedCueCardIds.toList());
      await prefs.setStringList('${keyPrefix}saved_vocab', savedVocabWords.toList());

      // Also mirror to global default keys for backward compatibility
      await prefs.setString('candidate_name', candidateName.value);
      await prefs.setDouble('target_band', targetBand.value);
      await prefs.setInt('exam_days_remaining', examDaysRemaining.value);
      await prefs.setString('exam_module', examModule.value);
      await prefs.setString('test_history', historyJson);

      // Register candidate in profile accounts registry
      if (candidateName.value.isNotEmpty && candidateName.value != "IELTS Aspirant") {
        final currentList = prefs.getStringList('registered_candidates_list') ?? [];
        if (!currentList.any((e) => e.trim().toLowerCase() == candidateName.value.trim().toLowerCase())) {
          currentList.add(candidateName.value.trim());
          await prefs.setStringList('registered_candidates_list', currentList);
        }
      }
    } catch (e) {
      debugPrint("Error saving IELTS local storage: $e");
    }
  }

  Future<void> resetPracticeHistory() async {
    testHistory.clear();
    testHistory.refresh();
    listeningBand.value = targetBand.value;
    readingBand.value = targetBand.value;
    writingBand.value = targetBand.value;
    speakingBand.value = targetBand.value;
    listeningAccuracy.value = 0.0;
    readingAccuracy.value = 0.0;
    writingAccuracy.value = 0.0;
    speakingAccuracy.value = 0.0;
    overallBand.value = targetBand.value;
    overallAccuracy.value = 0.0;
    speakingTaskDone.value = false;
    listeningTaskDone.value = false;
    readingTaskDone.value = false;
    writingTaskDone.value = false;
    savedCueCardIds.clear();
    savedVocabWords.clear();
    await saveToLocalStorage();
  }

  Future<void> resetUserData({String? newName, double? targetBandVal, String? module, bool clearHistory = true}) async {
    candidateName.value = newName ?? "IELTS Aspirant";
    if (targetBandVal != null) targetBand.value = targetBandVal;
    if (module != null) examModule.value = module;
    if (clearHistory) {
      await resetPracticeHistory();
    }
    await saveToLocalStorage();
  }

  List<IeltsTestResult> get mockTestHistory => testHistory.where((e) {
    return e.isMockExam || e.testName.toLowerCase().contains("mock");
  }).toList();

  List<IeltsTestResult> get practiceHistory => testHistory.where((e) {
    return !e.isMockExam && !e.testName.toLowerCase().contains("mock");
  }).toList();

  void addTestResult({
    required String skill,
    required String testName,
    required int score,
    required int totalQuestions,
    required double bandScore,
    bool isMockExam = false,
  }) {
    final accuracy = totalQuestions > 0 ? (score / totalQuestions) * 100 : 0.0;
    final bool effectiveMock = isMockExam || testName.toLowerCase().contains("mock");
    final newResult = IeltsTestResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      skill: skill,
      testName: testName,
      score: score,
      totalQuestions: totalQuestions,
      accuracy: double.parse(accuracy.toStringAsFixed(1)),
      bandScore: bandScore,
      date: "Just now",
      isMockExam: effectiveMock,
    );

    testHistory.insert(0, newResult);
    testHistory.refresh();
    _recalculateStats();
    saveToLocalStorage();
  }

  IeltsTestResult? getLatestMockResult(String skill, {String? testQuery}) {
    for (var t in testHistory) {
      final isMock = t.isMockExam || t.testName.toLowerCase().contains("mock");
      if (!isMock) continue;
      if (testQuery != null && testQuery.isNotEmpty) {
        final cleanQuery = testQuery.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), ' ').trim();
        final cleanName = t.testName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), ' ').trim();
        if (cleanName.contains(cleanQuery) || cleanQuery.contains(cleanName)) {
          return t;
        }
      } else if (t.skill.toLowerCase() == skill.toLowerCase()) {
        return t;
      }
    }
    return null;
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
    if (testHistory.isEmpty) {
      overallAccuracy.value = 0.0;
      listeningAccuracy.value = 0.0;
      readingAccuracy.value = 0.0;
      writingAccuracy.value = 0.0;
      speakingAccuracy.value = 0.0;
      overallBand.value = targetBand.value;
      listeningBand.value = targetBand.value;
      readingBand.value = targetBand.value;
      writingBand.value = targetBand.value;
      speakingBand.value = targetBand.value;
      return;
    }

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
