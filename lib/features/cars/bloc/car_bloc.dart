import 'dart:math';

import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:flutter_application_9/core/models/car.dart';
import 'package:flutter_application_9/core/repositories/car_repository.dart';
import 'package:flutter_application_9/features/profile/cubit/profile_cubit.dart';
import 'car_event.dart';
import 'car_state.dart';

class CarBloc extends HydratedBloc<CarEvent, CarState> {
  CarBloc({
    required CarRepository repository,
    ProfileCubit? profileCubit,
  })  : _repository = repository,
        _profileCubit = profileCubit,
        super(CarState.initial(repository.loadCars())) {
    on<CarSearchChanged>(_onSearchChanged);
    on<CarFilterChanged>(_onFilterChanged);
    on<CarFavoriteToggled>(_onFavoriteToggled);
    on<CarDeleted>(_onDeleted);
    on<CarStatusUpdated>(_onStatusUpdated);
    on<CarRated>(_onRated);
    on<CarSaved>(_onSaved);
    _syncProfile(state);
  }

  final CarRepository _repository;
  final ProfileCubit? _profileCubit;
  final _random = Random();

  void _syncProfile(CarState state) {
    _profileCubit?.updateStats(
      total: state.cars.length,
      planned: state.plannedCars.length,
      completed: state.completedCars.length,
      rated: state.ratedCars.length,
    );
  }

  Future<void> _onSearchChanged(
    CarSearchChanged event,
    Emitter<CarState> emit,
  ) async {
    final newState = state.copyWith(searchQuery: event.query);
    emit(newState);
  }

  Future<void> _onFilterChanged(
    CarFilterChanged event,
    Emitter<CarState> emit,
  ) async {
    final status =
        event.clearStatus ? null : (event.status ?? state.statusFilter);
    emit(
      state.copyWith(
        statusFilter: status,
        statusFilterOverride: event.clearStatus || event.status != null,
        favoritesOnly: event.favoritesOnly ?? state.favoritesOnly,
      ),
    );
  }

  Future<void> _onFavoriteToggled(
    CarFavoriteToggled event,
    Emitter<CarState> emit,
  ) async {
    final updated = state.cars.map((car) {
      if (car.id == event.id) {
        return car.copyWith(isFavorite: !car.isFavorite);
      }
      return car;
    }).toList();
    final newState = state.copyWith(cars: updated);
    emit(newState);
    _syncProfile(newState);
  }

  Future<void> _onDeleted(CarDeleted event, Emitter<CarState> emit) async {
    final updated = state.cars.where((car) => car.id != event.id).toList();
    final newState = state.copyWith(cars: updated);
    emit(newState);
    _syncProfile(newState);
  }

  Future<void> _onStatusUpdated(
    CarStatusUpdated event,
    Emitter<CarState> emit,
  ) async {
    final updated = state.cars.map((car) {
      if (car.id == event.id) {
        return car.copyWith(status: event.status);
      }
      return car;
    }).toList();
    final newState = state.copyWith(cars: updated);
    emit(newState);
    _syncProfile(newState);
  }

  Future<void> _onRated(CarRated event, Emitter<CarState> emit) async {
    final updated = state.cars.map((car) {
      if (car.id == event.id) {
        return car.copyWith(rating: event.rating);
      }
      return car;
    }).toList();
    final newState = state.copyWith(cars: updated);
    emit(newState);
    _syncProfile(newState);
  }

  Future<void> _onSaved(CarSaved event, Emitter<CarState> emit) async {
    final tags = event.tags.where((tag) => tag.trim().isNotEmpty).toList();
    if (event.id == null) {
      final car = Car(
        id: _generateId(),
        brand: event.brand,
        model: event.model,
        year: event.year,
        registrationNumber: event.registrationNumber,
        mileage: event.mileage,
        color: event.color,
        owner: event.owner,
        notes: event.notes,
        isFavorite: event.isFavorite,
        status: event.status,
        rating: event.rating,
        scheduledAt: event.scheduledAt,
        tags: tags,
        createdAt: DateTime.now(),
      );
      final updated = [...state.cars, car];
      final newState = state.copyWith(cars: updated);
      emit(newState);
      _syncProfile(newState);
    } else {
      final updated = state.cars.map((car) {
        if (car.id == event.id) {
          return car.copyWith(
            brand: event.brand,
            model: event.model,
            year: event.year,
            registrationNumber: event.registrationNumber,
            mileage: event.mileage,
            color: event.color,
            owner: event.owner,
            notes: event.notes,
            isFavorite: event.isFavorite,
            status: event.status,
            rating: event.rating,
            scheduledAt: event.scheduledAt,
            tags: tags,
          );
        }
        return car;
      }).toList();
      final newState = state.copyWith(cars: updated);
      emit(newState);
      _syncProfile(newState);
    }
  }

  String _generateId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final suffix = _random.nextInt(9999).toString().padLeft(4, '0');
    return 'car-$timestamp-$suffix';
  }

  @override
  CarState? fromJson(Map<String, dynamic> json) {
    try {
      final newState = CarState.fromJson(json);
      _syncProfile(newState);
      return newState;
    } catch (_) {
      return CarState.initial(_repository.loadCars());
    }
  }

  @override
  Map<String, dynamic>? toJson(CarState state) => state.toJson();
}
