class CommentModel {
  String? id;
  UserModel? user;
  String? auditionId;
  String? comment;
  DateTime? createdAt;
  DateTime? updatedAt;

  CommentModel({
    this.id,
    this.user,
    this.auditionId,
    this.comment,
    this.createdAt,
    this.updatedAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['_id'],
      user: json['userId'] != null
          ? UserModel.fromJson(json['userId'])
          : null,
      auditionId: json['auditionId'],
      comment: json['comment'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': user?.toJson(),
      'auditionId': auditionId,
      'comment': comment,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
class UserModel {
  String? id;
  String? fullName;
  String? profileImage;

  UserModel({
    this.id,
    this.fullName,
    this.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      fullName: json['fullName'],
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'profileImage': profileImage,
    };
  }
}