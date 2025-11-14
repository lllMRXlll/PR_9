import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/car.dart';
import '../bloc/car_bloc.dart';
import '../bloc/car_event.dart';

class CarListView extends StatelessWidget {
  const CarListView({
    super.key,
    required this.cars,
    this.onOpenDetails,
  });

  final List<Car> cars;
  final void Function(Car car)? onOpenDetails;

  @override
  Widget build(BuildContext context) {
    if (cars.isEmpty) {
      return const Center(
        child: Text('Список пуст. Добавьте авто.'),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final car = cars[index];
        return _CarCard(
          car: car,
          onTap: () => onOpenDetails?.call(car),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: cars.length,
    );
  }
}

class _CarCard extends StatelessWidget {
  const _CarCard({required this.car, this.onTap});

  final Car car;
  final VoidCallback? onTap;

  Color _statusColor(BuildContext context) {
    switch (car.status) {
      case CarStatus.planned:
        return Colors.orange;
      case CarStatus.inProgress:
        return Colors.blue;
      case CarStatus.completed:
        return Colors.green;
    }
  }

  String _statusLabel() {
    switch (car.status) {
      case CarStatus.planned:
        return 'Запланировано';
      case CarStatus.inProgress:
        return 'В работе';
      case CarStatus.completed:
        return 'Завершено';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(context);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          car.displayName,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(car.registrationNumber),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      car.isFavorite ? Icons.star : Icons.star_border,
                      color: car.isFavorite
                          ? Theme.of(context).colorScheme.secondary
                          : null,
                    ),
                    onPressed: () => context
                        .read<CarBloc>()
                        .add(CarFavoriteToggled(car.id)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    avatar: Icon(Icons.timeline, color: color, size: 18),
                    label: Text(_statusLabel()),
                    side: BorderSide(color: color),
                  ),
                  Chip(
                    avatar: const Icon(Icons.event),
                    label: Text('${car.year} год'),
                  ),
                  Chip(
                    avatar: const Icon(Icons.speed),
                    label: Text('${car.mileage} км'),
                  ),
                  if (car.rating != null)
                    Chip(
                      avatar: const Icon(Icons.star, color: Colors.amber),
                      label: Text('${car.rating}/5'),
                    ),
                ],
              ),
              if (car.notes.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(car.notes),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
