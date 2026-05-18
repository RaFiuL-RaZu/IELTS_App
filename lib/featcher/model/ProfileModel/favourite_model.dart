import 'package:get/get.dart';

/// ================== FavouriteModel ==================
class FavouriteModel {
  final String id;
  final String userId;
  final AuditionModel audition;
  final DateTime createdAt;
  final DateTime updatedAt;

  FavouriteModel({
    required this.id,
    required this.userId,
    required this.audition,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FavouriteModel.fromJson(Map<String, dynamic> json) {
    return FavouriteModel(
      id: json['_id'] ?? "",
      userId: json['userId'] ?? "",
      audition: AuditionModel.fromJson(json['auditionId'] ?? {}),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "userId": userId,
      "auditionId": audition.toJson(),
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}

/// ================== AuditionModel ==================
class AuditionModel {
  final String id;
  final Creator creator;
  final String title;
  final String category;
  final DateTime? reminderDate;
  final String status;
  final String auditionFile;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  RxBool isFavorite;

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
    required this.commentCount,
    required this.isLiked,
    bool isFavorite = true, // favourite list এ true
    required this.createdAt,
    required this.updatedAt,
  }) : isFavorite = isFavorite.obs;

  factory AuditionModel.fromJson(Map<String, dynamic> json) {
    return AuditionModel(
      id: json['_id'] ?? "",
      creator: Creator.fromJson(json['creatorId'] ?? {}),
      title: json['title'] ?? "",
      category: json['category'] ?? "",
      reminderDate: json['reminderDate'] != null
          ? DateTime.parse(json['reminderDate'])
          : null,
      status: json['status'] ?? "",
      auditionFile: json['auditionFile'] ?? "",
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      isLiked: json['isLiked'] ?? false,
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
      "commentCount": commentCount,
      "isLiked": isLiked,
      "isFavorite": isFavorite.value,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}

/// ================== Creator Model ==================
class Creator {
  final String id;
  final String fullName;
  final String profileImage;

  Creator({
    required this.id,
    required this.fullName,
    required this.profileImage,
  });

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      id: json['_id'] ?? "",
      fullName: json['fullName'] ?? "",
      profileImage: json['profileImage'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "fullName": fullName,
      "profileImage": profileImage,
    };
  }
}