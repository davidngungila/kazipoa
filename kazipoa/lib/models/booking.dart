import 'user.dart';

class Booking {
  final String id;
  final String serviceType;
  final String professionalId;
  final String professionalName;
  final String clientId;
  final String clientName;
  final DateTime bookingDate;
  final String bookingTime;
  final int duration; // in minutes
  final BookingStatus status;
  final double price;
  final String currency;
  final String notes;
  final String location;
  final double? latitude;
  final double? longitude;
  final double? rating;
  final String? review;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;
  final Map<String, dynamic> metadata;

  Booking({
    required this.id,
    required this.serviceType,
    required this.professionalId,
    required this.professionalName,
    required this.clientId,
    required this.clientName,
    required this.bookingDate,
    required this.bookingTime,
    required this.duration,
    this.status = BookingStatus.pending,
    required this.price,
    this.currency = 'TZS',
    this.notes = '',
    required this.location,
    this.latitude,
    this.longitude,
    this.rating,
    this.review,
    required this.createdAt,
    this.updatedAt,
    this.completedAt,
    this.metadata = const {},
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? '',
      serviceType: json['serviceType'] ?? '',
      professionalId: json['professionalId'] ?? '',
      professionalName: json['professionalName'] ?? '',
      clientId: json['clientId'] ?? '',
      clientName: json['clientName'] ?? '',
      bookingDate: DateTime.parse(json['bookingDate'] ?? DateTime.now().toIso8601String()),
      bookingTime: json['bookingTime'] ?? '',
      duration: json['duration'] ?? 60,
      status: BookingStatus.values.firstWhere(
        (status) => status.toString() == 'BookingStatus.${json['status']}',
        orElse: () => BookingStatus.pending,
      ),
      price: (json['price'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? 'TZS',
      notes: json['notes'] ?? '',
      location: json['location'] ?? '',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      rating: json['rating']?.toDouble(),
      review: json['review'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceType': serviceType,
      'professionalId': professionalId,
      'professionalName': professionalName,
      'clientId': clientId,
      'clientName': clientName,
      'bookingDate': bookingDate.toIso8601String(),
      'bookingTime': bookingTime,
      'duration': duration,
      'status': status.toString().split('.').last,
      'price': price,
      'currency': currency,
      'notes': notes,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'review': review,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  Booking copyWith({
    String? id,
    String? serviceType,
    String? professionalId,
    String? professionalName,
    String? clientId,
    String? clientName,
    DateTime? bookingDate,
    String? bookingTime,
    int? duration,
    BookingStatus? status,
    double? price,
    String? currency,
    String? notes,
    String? location,
    double? latitude,
    double? longitude,
    double? rating,
    String? review,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
    Map<String, dynamic>? metadata,
  }) {
    return Booking(
      id: id ?? this.id,
      serviceType: serviceType ?? this.serviceType,
      professionalId: professionalId ?? this.professionalId,
      professionalName: professionalName ?? this.professionalName,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      bookingDate: bookingDate ?? this.bookingDate,
      bookingTime: bookingTime ?? this.bookingTime,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      notes: notes ?? this.notes,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rating: rating ?? this.rating,
      review: review ?? this.review,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  bool get isUpcoming {
    final now = DateTime.now();
    final bookingDateTime = DateTime(
      bookingDate.year,
      bookingDate.month,
      bookingDate.day,
      int.parse(bookingTime.split(':')[0]),
      int.parse(bookingTime.split(':')[1]),
    );
    return bookingDateTime.isAfter(now) && (status == BookingStatus.pending || status == BookingStatus.confirmed);
  }

  bool get isPast {
    final now = DateTime.now();
    final bookingDateTime = DateTime(
      bookingDate.year,
      bookingDate.month,
      bookingDate.day,
      int.parse(bookingTime.split(':')[0]),
      int.parse(bookingTime.split(':')[1]),
    );
    return bookingDateTime.isBefore(now);
  }

  bool get canBeCancelled {
    return status == BookingStatus.pending || status == BookingStatus.confirmed;
  }

  bool get canBeRated {
    return status == BookingStatus.completed && rating == null;
  }

  String get statusDisplay {
    switch (status) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get formattedPrice {
    return '$currency ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }
}
