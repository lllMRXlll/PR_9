import 'package:equatable/equatable.dart';

import 'package:flutter_application_9/core/models/car.dart';

abstract class CarEvent extends Equatable {
  const CarEvent();

  @override
  List<Object?> get props => [];
}

class CarSearchChanged extends CarEvent {
  const CarSearchChanged(this.query);
  final String query;
  @override
  List<Object?> get props => [query];
}

class CarFilterChanged extends CarEvent {
  const CarFilterChanged({
    this.status,
    this.favoritesOnly,
    this.clearStatus = false,
  });
  final CarStatus? status;
  final bool? favoritesOnly;
  final bool clearStatus;

  @override
  List<Object?> get props => [status, favoritesOnly, clearStatus];
}

class CarFavoriteToggled extends CarEvent {
  const CarFavoriteToggled(this.id);
  final String id;
  @override
  List<Object?> get props => [id];
}

class CarDeleted extends CarEvent {
  const CarDeleted(this.id);
  final String id;
  @override
  List<Object?> get props => [id];
}

class CarStatusUpdated extends CarEvent {
  const CarStatusUpdated(this.id, this.status);
  final String id;
  final CarStatus status;
  @override
  List<Object?> get props => [id, status];
}

class CarRated extends CarEvent {
  const CarRated(this.id, this.rating);
  final String id;
  final int? rating;
  @override
  List<Object?> get props => [id, rating];
}

class CarSaved extends CarEvent {
  const CarSaved({
    this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.registrationNumber,
    required this.mileage,
    required this.color,
    required this.owner,
    required this.notes,
    required this.status,
    required this.isFavorite,
    this.rating,
    this.scheduledAt,
    this.tags = const [],
  });

  final String? id;
  final String brand;
  final String model;
  final int year;
  final String registrationNumber;
  final int mileage;
  final String color;
  final String owner;
  final String notes;
  final CarStatus status;
  final bool isFavorite;
  final int? rating;
  final DateTime? scheduledAt;
  final List<String> tags;

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
        status,
        isFavorite,
        rating,
        scheduledAt,
        tags,
      ];
}
