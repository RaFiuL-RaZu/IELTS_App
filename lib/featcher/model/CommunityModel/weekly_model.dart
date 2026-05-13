class CommunityModel {
  String? id;
  UserModel? user;
  String? category;
  String? duration;
  String? toneStyle;
  String? content;
  String? audioFile;
  DateTime? createdAt;
  DateTime? updatedAt;

  CommunityModel({
    this.id,
    this.user,
    this.category,
    this.duration,
    this.toneStyle,
    this.content,
    this.audioFile,
    this.createdAt,
    this.updatedAt,
  });

  factory CommunityModel.fromJson(Map<String, dynamic> json) {
    return CommunityModel(
      id: json['_id'],
      user: json['userId'] != null
          ? UserModel.fromJson(json['userId'])
          : null,
      category: json['category'],
      duration: json['duration'],
      toneStyle: json['toneStyle'],
      content: json['content'],
      audioFile: json['audioFile'],
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
      'category': category,
      'duration': duration,
      'toneStyle': toneStyle,
      'content': content,
      'audioFile': audioFile,
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