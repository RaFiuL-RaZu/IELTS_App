class BlockUser {
  final String? id;
  final String? userId;
  final TargetUser? targetUserId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  BlockUser({
    this.id,
    this.userId,
    this.targetUserId,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory BlockUser.fromJson(Map<String, dynamic> json) {
    return BlockUser(
      id: json['_id'],
      userId: json['userId'],
      targetUserId: json['targetUserId'] == null
          ? null
          : TargetUser.fromJson(json['targetUserId']),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt']),
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'targetUserId': targetUserId?.toJson(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}

class TargetUser {
  final String? id;
  final String? fullName;
  final String? profileImage;

  TargetUser({
    this.id,
    this.fullName,
    this.profileImage,
  });

  factory TargetUser.fromJson(Map<String, dynamic> json) {
    return TargetUser(
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