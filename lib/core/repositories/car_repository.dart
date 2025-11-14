import '../data/sample_cars.dart';
import '../models/car.dart';

class CarRepository {
  CarRepository({List<Car>? seed}) : _cars = List<Car>.from(seed ?? sampleCars);

  final List<Car> _cars;

  List<Car> loadCars() => List.unmodifiable(_cars);
}
