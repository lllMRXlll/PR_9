import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/routes.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль пользователя')),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              CircleAvatar(
                radius: 48,
                child: Text(
                  state.fullName.isEmpty
                      ? 'AV'
                      : state.fullName.split(' ').map((e) => e[0]).take(2).join(),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  state.fullName.isEmpty ? 'Имя не задано' : state.fullName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 8),
              Center(child: Text(state.email)),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Компания', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(state.company.isEmpty ? '—' : state.company),
                      const SizedBox(height: 12),
                      Text('О себе', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(state.bio),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _metric('Всего авто', state.totalCars),
                  _metric('Запланировано', state.plannedCars),
                  _metric('Готово', state.completedCars),
                  _metric('Оценено', state.ratedCars),
                ],
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthLogoutRequested());
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
                },
                icon: const Icon(Icons.logout),
                label: const Text('Выйти из аккаунта'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _metric(String label, int value) {
    return SizedBox(
      width: 150,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                '$value',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(label, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
