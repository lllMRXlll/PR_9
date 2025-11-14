import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/routes.dart';
import '../../../core/models/car.dart';
import '../bloc/car_bloc.dart';
import '../bloc/car_event.dart';
import '../bloc/car_state.dart';

class CarDetailScreen extends StatelessWidget {
  const CarDetailScreen({super.key, required this.carId});

  final String carId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarBloc, CarState>(
      builder: (context, state) {
        Car? car;
        for (final item in state.cars) {
          if (item.id == carId) {
            car = item;
            break;
          }
        }
        if (car == null) {
          return const Scaffold(
            body: Center(child: Text('Карточка не найдена')),
          );
        }
        final currentCar = car;
        return Scaffold(
          appBar: AppBar(
            title: Text(currentCar.displayName),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => Navigator.of(context).pushNamed(
                  AppRoutes.carForm,
                  arguments: carId,
                ),
              ),
              IconButton(
                icon: Icon(
                  currentCar.isFavorite ? Icons.star : Icons.star_border,
                ),
                onPressed: () =>
                    context.read<CarBloc>().add(CarFavoriteToggled(currentCar.id)),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _InfoTile(label: 'Гос. номер', value: currentCar.registrationNumber),
              _InfoTile(label: 'Год выпуска', value: '${currentCar.year}'),
              _InfoTile(label: 'Пробег', value: '${currentCar.mileage} км'),
              _InfoTile(label: 'Цвет', value: currentCar.color),
              _InfoTile(label: 'Ответственный', value: currentCar.owner),
              if (currentCar.scheduledAt != null)
                _InfoTile(
                  label: 'Плановая дата',
                  value:
                      '${currentCar.scheduledAt!.day}.${currentCar.scheduledAt!.month}.${currentCar.scheduledAt!.year}',
                ),
              const SizedBox(height: 16),
              Text(
                'Заметки',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(currentCar.notes.isEmpty ? 'Нет заметок' : currentCar.notes),
              const SizedBox(height: 24),
              _StatusSelector(car: currentCar),
              const SizedBox(height: 16),
              _RatingSelector(car: currentCar),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {
                  context.read<CarBloc>().add(CarDeleted(currentCar.id));
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.delete),
                label: const Text('Удалить карточку'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(value),
    );
  }
}

class _StatusSelector extends StatelessWidget {
  const _StatusSelector({required this.car});
  final Car car;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Статус обслуживания',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        SegmentedButton<CarStatus>(
          segments: const [
            ButtonSegment(value: CarStatus.planned, label: Text('План')),
            ButtonSegment(value: CarStatus.inProgress, label: Text('В работе')),
            ButtonSegment(value: CarStatus.completed, label: Text('Готово')),
          ],
          selected: {car.status},
          onSelectionChanged: (value) => context
              .read<CarBloc>()
              .add(CarStatusUpdated(car.id, value.first)),
        ),
      ],
    );
  }
}

class _RatingSelector extends StatelessWidget {
  const _RatingSelector({required this.car});
  final Car car;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Оцените состояние',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Slider(
          value: (car.rating ?? 0).toDouble(),
          divisions: 5,
          min: 0,
          max: 5,
          label: (car.rating ?? 0).toString(),
          onChanged: (value) => context
              .read<CarBloc>()
              .add(CarRated(car.id, value.toInt())),
        ),
      ],
    );
  }
}
