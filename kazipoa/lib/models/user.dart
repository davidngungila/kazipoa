enum UserType {
  client,
  professional,
}

enum BookingStatus {
  pending,
  confirmed,
  completed,
  cancelled,
  inProgress,
}

enum VerificationStatus {
  unverified,
  pending,
  verified,
}

enum ProGrade {
  none,
  silver,
  gold,
}

class User {
  final String id;
  final String email;
  final String name;
  final String phone;
  final UserType userType;
  final String? avatar;
  final DateTime createdAt;
  final VerificationStatus isVerified;
  final bool isActive;
  final DateTime? lastLoginAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.userType,
    this.avatar,
    required this.createdAt,
    this.isVerified = VerificationStatus.unverified,
    this.isActive = true,
    this.lastLoginAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      userType: UserType.values.firstWhere(
        (type) => type.toString() == 'UserType.${json['userType']}',
        orElse: () => UserType.client,
      ),
      avatar: json['avatar'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      isVerified: VerificationStatus.values.firstWhere(
        (status) => status.toString() == 'VerificationStatus.${json['isVerified']}',
        orElse: () => VerificationStatus.unverified,
      ),
      isActive: json['isActive'] ?? true,
      lastLoginAt: json['lastLoginAt'] != null ? DateTime.parse(json['lastLoginAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'userType': userType.toString().split('.').last,
      'avatar': avatar,
      'createdAt': createdAt.toIso8601String(),
      'isVerified': isVerified.toString().split('.').last,
      'isActive': isActive,
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    UserType? userType,
    String? avatar,
    DateTime? createdAt,
    VerificationStatus? isVerified,
    bool? isActive,
    DateTime? lastLoginAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      userType: userType ?? this.userType,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
}
