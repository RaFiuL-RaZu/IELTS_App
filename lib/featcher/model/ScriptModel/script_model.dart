class ScriptModel {
  final String? id;
  final String? createdBy;
  final String? creatorId;
  final String? title;
  final String? content;
  final String? category;
  final String? difficulty;
  final String? duration;
  final bool isWeeklyScript;
  final bool isComplete; // ✅ NEW FIELD
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ScriptModel({
    this.id = '',
    this.createdBy = '',
    this.creatorId = '',
    this.title = '',
    this.content = '',
    this.category = 'General',
    this.difficulty = 'Beginner',
    this.duration = '',
    this.isWeeklyScript = false,
    this.isComplete = false, // ✅ default
    this.createdAt,
    this.updatedAt,
  });

  factory ScriptModel.fromJson(Map<String, dynamic> json) {
    return ScriptModel(
      id: json['_id'] ?? '',
      createdBy: json['createdBy'] ?? '',
      creatorId: json['creatorId'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      category: json['category'] ?? 'General',
      difficulty: json['difficulty'] ?? 'Beginner',
      duration: json['duration'] ?? '',
      isWeeklyScript: json['isWeeklyScript'] ?? false,
      isComplete: json['isComplete'] ?? false, // ✅ added
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id ?? '',
      'createdBy': createdBy ?? '',
      'creatorId': creatorId ?? '',
      'title': title ?? '',
      'content': content ?? '',
      'category': category ?? 'General',
      'difficulty': difficulty ?? 'Beginner',
      'duration': duration ?? '',
      'isWeeklyScript': isWeeklyScript,
      'isComplete': isComplete,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}