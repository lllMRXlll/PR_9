import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/routes.dart';
import '../bloc/car_bloc.dart';
import '../bloc/car_state.dart';
import '../widgets/car_list_view.dart';

class RatedCarsScreen extends StatelessWidget {
  const RatedCarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Оцененные авто')),
      body: BlocBuilder<CarBloc, CarState>(
        builder: (context, state) {
          return CarListView(
            cars: state.ratedCars,
            onOpenDetails: (car) => Navigator.of(context).pushNamed(
              AppRoutes.carDetails,
              arguments: car.id,
            ),
          );
        },
      ),
    );
  }
}
