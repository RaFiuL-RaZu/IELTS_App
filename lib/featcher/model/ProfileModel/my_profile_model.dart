class ProfileModel {
  String? id;
  String? email;
  String? role;
  String? fullName;
  String? gender;
  List<String>? voiceSpecialties;
  String? profileImage;
  int? auditionsJoinCount;
  int? scriptCount;
  DateTime? lastActiveAt;
  bool? isBlocked;
  bool? isVerifiedByAdmin;
  bool? hasCompletedProfile;
  bool? isDeleted;
  DateTime? passwordChangedAt;
  String? loginWith;
  String? fcmToken;
  String? subscriptionType;
  DateTime? subscriptionExpiresAt;
  int? scriptGeneratedCount;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? about;

  ProfileModel({
    this.id,
    this.email,
    this.role,
    this.fullName,
    this.gender,
    this.voiceSpecialties,
    this.profileImage,
    this.auditionsJoinCount,
    this.scriptCount,
    this.lastActiveAt,
    this.isBlocked,
    this.isVerifiedByAdmin,
    this.hasCompletedProfile,
    this.isDeleted,
    this.passwordChangedAt,
    this.loginWith,
    this.fcmToken,
    this.subscriptionType,
    this.subscriptionExpiresAt,
    this.scriptGeneratedCount,
    this.createdAt,
    this.updatedAt,
    this.about,
  });

  factory ProfileModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ProfileModel();

    return ProfileModel(
      id: json['_id'],
      email: json['email'],
      role: json['role'],
      fullName: json['fullName'],
      gender: json['gender'],
      voiceSpecialties: json['voiceSpecialties'] != null
          ? List<String>.from(json['voiceSpecialties'])
          : null,
      profileImage: json['profileImage'],
      auditionsJoinCount: json['auditionsJoinCount'],
      scriptCount: json['scriptCount'],
      lastActiveAt: json['lastActiveAt'] != null
          ? DateTime.tryParse(json['lastActiveAt'])
          : null,
      isBlocked: json['isBlocked'],
      isVerifiedByAdmin: json['isVerifiedByAdmin'],
      hasCompletedProfile: json['hasCompletedProfile'],
      isDeleted: json['isDeleted'],
      passwordChangedAt: json['passwordChangedAt'] != null
          ? DateTime.tryParse(json['passwordChangedAt'])
          : null,
      loginWith: json['loginWith'] ?? json['loginWth'],
      fcmToken: json['fcmToken'],
      subscriptionType: json['subscriptionType'],
      subscriptionExpiresAt: json['subscriptionExpiresAt'] != null
          ? DateTime.tryParse(json['subscriptionExpiresAt'])
          : null,
      scriptGeneratedCount: json['scriptGeneratedCount'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      about: json['about'],
    );
  }
}