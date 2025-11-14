import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/car.dart';
import '../../cars/bloc/car_bloc.dart';
import '../../cars/bloc/car_state.dart';

class CarStatisticsScreen extends StatelessWidget {
  const CarStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Статистика автопарка')),
      body: BlocBuilder<CarBloc, CarState>(
        builder: (context, state) {
          final total = state.cars.length;
          final planned = state.plannedCars.length;
          final completed = state.completedCars.length;
          final rated = state.ratedCars.length;
          final completion =
              total == 0 ? 0.0 : completed / total;
          final plannedShare =
              total == 0 ? 0.0 : planned / total;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _StatRow(
                label: 'Укомплектованность',
                value: '${(completion * 100).toStringAsFixed(0)}%',
                progress: completion,
              ),
              _StatRow(
                label: 'Запланировано ТО',
                value: '$planned из $total',
                progress: plannedShare,
              ),
              _StatRow(
                label: 'Есть оценка состояния',
                value: '$rated авто',
                progress: total == 0 ? 0 : rated / total,
              ),
              const SizedBox(height: 24),
              DataTable(columns: const [
                DataColumn(label: Text('Бренд')),
                DataColumn(label: Text('Всего')),
                DataColumn(label: Text('Готово')),
              ], rows: [
                for (final entry in state.groupedByBrand.entries)
                  DataRow(cells: [
                    DataCell(Text(entry.key)),
                    DataCell(Text('${entry.value.length}')),
                    DataCell(Text(
                      '${entry.value.where((car) => car.status == CarStatus.completed).length}',
                    )),
                  ])
              ]),
            ],
          );
        },
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    required this.progress,
  });

  final String label;
  final String value;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 8),
            Text(value),
          ],
        ),
      ),
    );
  }
}
