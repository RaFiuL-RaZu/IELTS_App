import 'package:get/get.dart';

class AuditionModel {
  final String id;
  final Creator creator;
  final String title;
  final String category;
  final DateTime? reminderDate;
  final String status;
  final String auditionFile;
  int likeCount;

  RxBool isLiked; // 👈 IMPORTANT
  RxBool isFavorite;

  late final int commentCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  AuditionModel({
    required this.id,
    required this.creator,
    required this.title,
    required this.category,
    this.reminderDate,
    required this.status,
    required this.auditionFile,
    required this.likeCount,
    bool isLiked = false,
    bool isFavorite = false,
    required this.commentCount,
    required this.createdAt,
    required this.updatedAt,
  })  : isLiked = isLiked.obs,
        isFavorite = isFavorite.obs;

  factory AuditionModel.fromJson(Map<String, dynamic> json) {
    return AuditionModel(
      id: json['_id'],
      creator: Creator.fromJson(json['creatorId']),
      title: json['title'],
      category: json['category'],
      reminderDate: json['reminderDate'] != null
          ? DateTime.parse(json['reminderDate'])
          : null,
      status: json['status'],
      auditionFile: json['auditionFile'],
      likeCount: json['likeCount'] ?? 0,
      isLiked: json['isLiked'] ?? false, // 👈 backend value
      isFavorite: json['isFavorite'] ?? false,
      commentCount: json['commentCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "creatorId": creator.toJson(),
      "title": title,
      "category": category,
      "reminderDate": reminderDate?.toIso8601String(),
      "status": status,
      "auditionFile": auditionFile,
      "likeCount": likeCount,
      "isLiked": isLiked,
      "isFavorite": isFavorite.value,
      "commentCount": commentCount,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}

class Creator {
  final String id;
  final String fullName;
  final String profileImage;
  final DateTime createdAt;

  Creator({
    required this.id,
    required this.fullName,
    required this.profileImage,
    required this.createdAt,
  });

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      id: json['_id'] ?? "",
      fullName: json['fullName'] ?? "",
      profileImage: json['profileImage'] ?? "",
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "fullName": fullName,
      "profileImage": profileImage,
      "createdAt": createdAt.toIso8601String(),
    };
  }
}