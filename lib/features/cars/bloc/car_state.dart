import 'package:equatable/equatable.dart';

import 'package:flutter_application_9/core/models/car.dart';

class CarState extends Equatable {
  const CarState({
    required this.cars,
    this.searchQuery = '',
    this.statusFilter,
    this.favoritesOnly = false,
  });

  final List<Car> cars;
  final String searchQuery;
  final CarStatus? statusFilter;
  final bool favoritesOnly;

  factory CarState.initial(List<Car> cars) => CarState(cars: cars);

  CarState copyWith({
    List<Car>? cars,
    String? searchQuery,
    CarStatus? statusFilter,
    bool statusFilterOverride = false,
    bool? favoritesOnly,
  }) {
    return CarState(
      cars: cars ?? this.cars,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter:
          statusFilterOverride ? statusFilter : (statusFilter ?? this.statusFilter),
      favoritesOnly: favoritesOnly ?? this.favoritesOnly,
    );
  }

  List<Car> get filteredCars {
    final query = searchQuery.trim().toLowerCase();
    return cars.where((car) {
      if (favoritesOnly && !car.isFavorite) {
        return false;
      }
      if (statusFilter != null && car.status != statusFilter) {
        return false;
      }
      if (query.isEmpty) {
        return true;
      }
      final haystack = [
        car.brand,
        car.model,
        car.registrationNumber,
        car.owner,
        car.notes,
        car.tags.join(' '),
      ].join(' ').toLowerCase();
      return haystack.contains(query);
    }).toList();
  }

  List<Car> get plannedCars =>
      cars.where((car) => car.status == CarStatus.planned).toList();
  List<Car> get activeCars =>
      cars.where((car) => car.status == CarStatus.inProgress).toList();
  List<Car> get completedCars =>
      cars.where((car) => car.status == CarStatus.completed).toList();
  List<Car> get ratedCars => cars.where((car) => car.isRated).toList();
  List<Car> get favoriteCars => cars.where((car) => car.isFavorite).toList();

  Map<String, List<Car>> get groupedByBrand {
    final map = <String, List<Car>>{};
    for (final car in cars) {
      map.putIfAbsent(car.brand, () => []).add(car);
    }
    return map;
  }

  Map<String, dynamic> toJson() => {
        'cars': cars.map((car) => car.toJson()).toList(),
        'searchQuery': searchQuery,
        'statusFilter': statusFilter?.name,
        'favoritesOnly': favoritesOnly,
      };

  factory CarState.fromJson(Map<String, dynamic> json) {
    final rawCars = (json['cars'] as List<dynamic>? ?? const [])
        .map((item) => Car.fromJson(item as Map<String, dynamic>))
        .toList();
    return CarState(
      cars: rawCars,
      searchQuery: json['searchQuery'] as String? ?? '',
      statusFilter: (json['statusFilter'] as String?) != null
          ? CarStatus.values.firstWhere(
              (element) => element.name == json['statusFilter'],
              orElse: () => CarStatus.inProgress,
            )
          : null,
      favoritesOnly: json['favoritesOnly'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [cars, searchQuery, statusFilter, favoritesOnly];
}
