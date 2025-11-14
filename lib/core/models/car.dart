import 'package:equatable/equatable.dart';

enum CarStatus { planned, inProgress, completed }

class Car extends Equatable {
  const Car({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.registrationNumber,
    required this.mileage,
    required this.color,
    required this.owner,
    required this.notes,
    required this.createdAt,
    this.status = CarStatus.inProgress,
    this.isFavorite = false,
    this.rating,
    this.scheduledAt,
    this.tags = const [],
  });

  final String id;
  final String brand;
  final String model;
  final int year;
  final String registrationNumber;
  final int mileage;
  final String color;
  final String owner;
  final String notes;
  final bool isFavorite;
  final CarStatus status;
  final int? rating;
  final DateTime createdAt;
  final DateTime? scheduledAt;
  final List<String> tags;

  String get displayName => '$brand $model';
  bool get hasPlannedMaintenance => scheduledAt != null;
  bool get isRated => rating != null;

  Car copyWith({
    String? id,
    String? brand,
    String? model,
    int? year,
    String? registrationNumber,
    int? mileage,
    String? color,
    String? owner,
    String? notes,
    bool? isFavorite,
    CarStatus? status,
    int? rating,
    DateTime? createdAt,
    DateTime? scheduledAt,
    List<String>? tags,
  }) {
    return Car(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      mileage: mileage ?? this.mileage,
      color: color ?? this.color,
      owner: owner ?? this.owner,
      notes: notes ?? this.notes,
      isFavorite: isFavorite ?? this.isFavorite,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      tags: tags ?? this.tags,
    );
  }

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      year: json['year'] as int,
      registrationNumber: json['registrationNumber'] as String,
      mileage: json['mileage'] as int,
      color: json['color'] as String,
      owner: json['owner'] as String,
      notes: json['notes'] as String? ?? '',
      isFavorite: json['isFavorite'] as bool? ?? false,
      status: CarStatus.values
          .firstWhere((s) => s.name == json['status'], orElse: () => CarStatus.inProgress),
      rating: json['rating'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      scheduledAt: json['scheduledAt'] != null
          ? DateTime.tryParse(json['scheduledAt'] as String)
          : null,
      tags: (json['tags'] as List<dynamic>? ?? const [])
          .map((tag) => tag.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'brand': brand,
        'model': model,
        'year': year,
        'registrationNumber': registrationNumber,
        'mileage': mileage,
        'color': color,
        'owner': owner,
        'notes': notes,
        'isFavorite': isFavorite,
        'status': status.name,
        'rating': rating,
        'createdAt': createdAt.toIso8601String(),
        'scheduledAt': scheduledAt?.toIso8601String(),
        'tags': tags,
      };

  @override
  List<Object?> get props => [
        id,
        brand,
        model,
        year,
        registrationNumber,
        mileage,
        color,
        owner,
        notes,
        isFavorite,
        status,
        rating,
        createdAt,
        scheduledAt,
        tags,
      ];
}
