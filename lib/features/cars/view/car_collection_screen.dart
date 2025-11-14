import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/routes.dart';
import '../bloc/car_bloc.dart';
import '../bloc/car_state.dart';

class CarCollectionScreen extends StatelessWidget {
  const CarCollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Коллекция по брендам')),
      body: BlocBuilder<CarBloc, CarState>(
        builder: (context, state) {
          final groups = state.groupedByBrand.entries.toList()
            ..sort((a, b) => a.key.compareTo(b.key));
          if (groups.isEmpty) {
            return const Center(child: Text('Нет данных'));
          }
          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final entry = groups[index];
              return ExpansionTile(
                title: Text('${entry.key} (${entry.value.length})'),
                children: entry.value
                    .map(
                      (car) => ListTile(
                        title: Text(car.displayName),
                        subtitle: Text(car.registrationNumber),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.of(context).pushNamed(
                          AppRoutes.carDetails,
                          arguments: car.id,
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          );
        },
      ),
    );
  }
}
