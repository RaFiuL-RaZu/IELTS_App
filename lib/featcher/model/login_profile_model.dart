class LoginProfileModel {
  final User user;
  final String accessToken;

  LoginProfileModel({
    required this.user,
    required this.accessToken,
  });

  factory LoginProfileModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return LoginProfileModel(
        user: User.empty(),
        accessToken: '',
      );
    }

    return LoginProfileModel(
      user: json['user'] != null
          ? User.fromJson(json['user'])
          : User.empty(),
      accessToken: json['accessToken'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'accessToken': accessToken,
    };
  }
}

class User {
  final String id;
  final String email;
  final String role;
  final String fullName;
  final String gender;
  final List<String> voiceSpecialties;
  final String profileImage;
  final int auditionsJoinCount;
  final int scriptCount;
  final DateTime? lastActiveAt;
  final bool isBlocked;
  final bool isVerifiedByAdmin;
  final bool hasCompletedProfile;
  final bool isDeleted;
  final DateTime? passwordChangedAt;
  final String loginWith;
  final String? fcmToken;
  final String subscriptionType;
  final DateTime? subscriptionExpiresAt;
  final int scriptGeneratedCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String about;
  final Phone phone;

  User({
    required this.id,
    required this.email,
    required this.role,
    required this.fullName,
    required this.gender,
    required this.voiceSpecialties,
    required this.profileImage,
    required this.auditionsJoinCount,
    required this.scriptCount,
    required this.lastActiveAt,
    required this.isBlocked,
    required this.isVerifiedByAdmin,
    required this.hasCompletedProfile,
    required this.isDeleted,
    required this.passwordChangedAt,
    required this.loginWith,
    required this.fcmToken,
    required this.subscriptionType,
    required this.subscriptionExpiresAt,
    required this.scriptGeneratedCount,
    required this.createdAt,
    required this.updatedAt,
    required this.about,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      fullName: json['fullName'] ?? '',
      gender: json['gender'] ?? '',
      voiceSpecialties: List<String>.from(json['voiceSpecialties'] ?? []),
      profileImage: json['profileImage'] ?? '',
      auditionsJoinCount: json['auditionsJoinCount'] ?? 0,
      scriptCount: json['scriptCount'] ?? 0,
      lastActiveAt: json['lastActiveAt'] != null
          ? DateTime.tryParse(json['lastActiveAt'])
          : null,
      isBlocked: json['isBlocked'] ?? false,
      isVerifiedByAdmin: json['isVerifiedByAdmin'] ?? false,
      hasCompletedProfile: json['hasCompletedProfile'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      passwordChangedAt: json['passwordChangedAt'] != null
          ? DateTime.tryParse(json['passwordChangedAt'])
          : null,

      // ✅ FIXED API mismatch
      loginWith: json['loginWith'] ?? json['loginWth'] ?? '',

      fcmToken: json['fcmToken'],
      subscriptionType: json['subscriptionType'] ?? 'free',
      subscriptionExpiresAt: json['subscriptionExpiresAt'] != null
          ? DateTime.tryParse(json['subscriptionExpiresAt'])
          : null,
      scriptGeneratedCount: json['scriptGeneratedCount'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      about: json['about'] ?? '',
      phone: Phone.fromJson(json['phone'] ?? {}),
    );
  }

  /// ✅ Safe empty fallback to avoid crashes
  factory User.empty() {
    return User(
      id: '',
      email: '',
      role: '',
      fullName: '',
      gender: '',
      voiceSpecialties: [],
      profileImage: '',
      auditionsJoinCount: 0,
      scriptCount: 0,
      lastActiveAt: null,
      isBlocked: false,
      isVerifiedByAdmin: false,
      hasCompletedProfile: false,
      isDeleted: false,
      passwordChangedAt: null,
      loginWith: '',
      fcmToken: null,
      subscriptionType: 'free',
      subscriptionExpiresAt: null,
      scriptGeneratedCount: 0,
      createdAt: null,
      updatedAt: null,
      about: '',
      phone: Phone(code: '', number: ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'role': role,
      'fullName': fullName,
      'gender': gender,
      'voiceSpecialties': voiceSpecialties,
      'profileImage': profileImage,
      'auditionsJoinCount': auditionsJoinCount,
      'scriptCount': scriptCount,
      'lastActiveAt': lastActiveAt?.toIso8601String(),
      'isBlocked': isBlocked,
      'isVerifiedByAdmin': isVerifiedByAdmin,
      'hasCompletedProfile': hasCompletedProfile,
      'isDeleted': isDeleted,
      'passwordChangedAt': passwordChangedAt?.toIso8601String(),
      'loginWith': loginWith,
      'fcmToken': fcmToken,
      'subscriptionType': subscriptionType,
      'subscriptionExpiresAt': subscriptionExpiresAt?.toIso8601String(),
      'scriptGeneratedCount': scriptGeneratedCount,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'about': about,
      'phone': phone.toJson(),
    };
  }
}

class Phone {
  final String code;
  final String number;

  Phone({
    required this.code,
    required this.number,
  });

  factory Phone.fromJson(Map<String, dynamic> json) {
    return Phone(
      code: json['code'] ?? '',
      number: json['number'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'number': number,
    };
  }
}