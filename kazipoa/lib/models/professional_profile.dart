import 'user.dart';

class ProfessionalProfile {
  final String id;
  final String userId;
  final String businessName;
  final String bio;
  final String specialization;
  final String location;
  final double latitude;
  final double longitude;
  final List<String> portfolioImages;
  final List<String> services;
  final double rating;
  final int reviewCount;
  final ProGrade grade;
  final DateTime? subscriptionExpiry;
  final bool isTopRated;
  final Map<String, dynamic> businessContacts;
  final List<String> workingHours;
  final double? basePrice;
  final String? currency;

  ProfessionalProfile({
    required this.id,
    required this.userId,
    required this.businessName,
    required this.bio,
    required this.specialization,
    required this.location,
    required this.latitude,
    required this.longitude,
    this.portfolioImages = const [],
    this.services = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.grade = ProGrade.none,
    this.subscriptionExpiry,
    this.isTopRated = false,
    this.businessContacts = const {},
    this.workingHours = const [],
    this.basePrice,
    this.currency = 'TZS',
  });

  factory ProfessionalProfile.fromJson(Map<String, dynamic> json) {
    return ProfessionalProfile(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      businessName: json['businessName'] ?? '',
      bio: json['bio'] ?? '',
      specialization: json['specialization'] ?? '',
      location: json['location'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      portfolioImages: List<String>.from(json['portfolioImages'] ?? []),
      services: List<String>.from(json['services'] ?? []),
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      grade: ProGrade.values.firstWhere(
        (grade) => grade.toString() == 'ProGrade.${json['grade']}',
        orElse: () => ProGrade.none,
      ),
      subscriptionExpiry: json['subscriptionExpiry'] != null 
          ? DateTime.parse(json['subscriptionExpiry']) 
          : null,
      isTopRated: json['isTopRated'] ?? false,
      businessContacts: Map<String, dynamic>.from(json['businessContacts'] ?? {}),
      workingHours: List<String>.from(json['workingHours'] ?? []),
      basePrice: json['basePrice']?.toDouble(),
      currency: json['currency'] ?? 'TZS',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'businessName': businessName,
      'bio': bio,
      'specialization': specialization,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'portfolioImages': portfolioImages,
      'services': services,
      'rating': rating,
      'reviewCount': reviewCount,
      'grade': grade.toString().split('.').last,
      'subscriptionExpiry': subscriptionExpiry?.toIso8601String(),
      'isTopRated': isTopRated,
      'businessContacts': businessContacts,
      'workingHours': workingHours,
      'basePrice': basePrice,
      'currency': currency,
    };
  }

  ProfessionalProfile copyWith({
    String? id,
    String? userId,
    String? businessName,
    String? bio,
    String? specialization,
    String? location,
    double? latitude,
    double? longitude,
    List<String>? portfolioImages,
    List<String>? services,
    double? rating,
    int? reviewCount,
    ProGrade? grade,
    DateTime? subscriptionExpiry,
    bool? isTopRated,
    Map<String, dynamic>? businessContacts,
    List<String>? workingHours,
    double? basePrice,
    String? currency,
  }) {
    return ProfessionalProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      businessName: businessName ?? this.businessName,
      bio: bio ?? this.bio,
      specialization: specialization ?? this.specialization,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      portfolioImages: portfolioImages ?? this.portfolioImages,
      services: services ?? this.services,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      grade: grade ?? this.grade,
      subscriptionExpiry: subscriptionExpiry ?? this.subscriptionExpiry,
      isTopRated: isTopRated ?? this.isTopRated,
      businessContacts: businessContacts ?? this.businessContacts,
      workingHours: workingHours ?? this.workingHours,
      basePrice: basePrice ?? this.basePrice,
      currency: currency ?? this.currency,
    );
  }

  bool get isSubscriptionActive {
    if (subscriptionExpiry == null) return false;
    return DateTime.now().isBefore(subscriptionExpiry!);
  }

  String get gradeDisplay {
    switch (grade) {
      case ProGrade.silver:
        return 'Silver';
      case ProGrade.gold:
        return 'Gold';
      default:
        return 'Standard';
    }
  }
}
