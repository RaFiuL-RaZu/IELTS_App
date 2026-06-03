class WeeklyModel {
  String? id;
  String? createdBy;
  String? creatorId;
  String? title;
  String? content;
  String? category;
  String? difficulty;
  String? duration;
  bool? isWeeklyScript;
  bool? isPracticed;
  DateTime? createdAt;
  DateTime? updatedAt;

  DateTime? weeklyScriptExpiryDate;

  WeeklyModel({
    this.id,
    this.createdBy,
    this.creatorId,
    this.title,
    this.content,
    this.category,
    this.difficulty,
    this.duration,
    this.isWeeklyScript,
    this.isPracticed,
    this.createdAt,
    this.updatedAt,
    this.weeklyScriptExpiryDate,
  });

  factory WeeklyModel.fromJson(Map<String, dynamic> json) {
    return WeeklyModel(
      id: json['_id'],
      createdBy: json['createdBy'],
      creatorId: json['creatorId'],
      title: json['title'],
      content: json['content'],
      category: json['category'],
      difficulty: json['difficulty'],
      duration: json['duration'],
      isWeeklyScript: json['isWeeklyScript'],
      isPracticed: json['isPracticed'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,

      // ✅ PARSE NEW FIELD
      weeklyScriptExpiryDate: json['weeklyScriptExpiryDate'] != null
          ? DateTime.parse(json['weeklyScriptExpiryDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'createdBy': createdBy,
      'creatorId': creatorId,
      'title': title,
      'content': content,
      'category': category,
      'difficulty': difficulty,
      'duration': duration,
      'isWeeklyScript': isWeeklyScript,
      'isPracticed': isPracticed,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),

      // ✅ NEW FIELD
      'weeklyScriptExpiryDate': weeklyScriptExpiryDate?.toIso8601String(),
    };
  }
}