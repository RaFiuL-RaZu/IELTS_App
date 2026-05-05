class MyAuditionModel {
  final String id;
  final String creatorId;
  final String title;
  final String category;
  final DateTime reminderDate;
  final String status;
  final String auditionFile;
  final int likeCount;
  final int commentCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  MyAuditionModel({
    required this.id,
    required this.creatorId,
    required this.title,
    required this.category,
    required this.reminderDate,
    required this.status,
    required this.auditionFile,
    required this.likeCount,
    required this.commentCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MyAuditionModel.fromJson(Map<String, dynamic> json) {
    return MyAuditionModel(
      id: json['_id'] ?? '',
      creatorId: json['creatorId'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      reminderDate: DateTime.parse(json['reminderDate']),
      status: json['status'] ?? '',
      auditionFile: json['auditionFile'] ?? '',
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "creatorId": creatorId,
      "title": title,
      "category": category,
      "reminderDate": reminderDate.toIso8601String(),
      "status": status,
      "auditionFile": auditionFile,
      "likeCount": likeCount,
      "commentCount": commentCount,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}