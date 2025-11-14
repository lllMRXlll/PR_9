import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/routes.dart';
import '../../../core/models/car.dart';
import '../../cars/bloc/car_bloc.dart';
import '../../cars/bloc/car_event.dart';
import '../../cars/bloc/car_state.dart';
import '../../cars/widgets/car_list_view.dart';
import '../../theme/cubit/theme_cubit.dart';
import '../../theme/cubit/theme_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Картотека авто'),
        actions: [
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return IconButton(
                tooltip: 'Сменить тему',
                onPressed: () => context.read<ThemeCubit>().toggle(),
                icon: Icon(
                  state.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Профиль',
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.profile),
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.carForm),
        icon: const Icon(Icons.add),
        label: const Text('Новое авто'),
      ),
      body: BlocBuilder<CarBloc, CarState>(
        builder: (context, state) {
          return Column(
            children: [
              _SummarySection(state: state),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Поиск по бренду или гос. номеру',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) =>
                      context.read<CarBloc>().add(CarSearchChanged(value)),
                ),
              ),
              SizedBox(
                height: 56,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  children: [
                    _QuickFilterChip(
                      label: 'Все',
                      selected: state.statusFilter == null &&
                          !state.favoritesOnly &&
                          state.searchQuery.isEmpty,
                      onSelected: () => context.read<CarBloc>().add(
                            const CarFilterChanged(
                              status: null,
                              favoritesOnly: false,
                              clearStatus: true,
                            ),
                          ),
                    ),
                    _QuickFilterChip(
                      label: 'Запланированные',
                      selected: state.statusFilter == CarStatus.planned,
                      onSelected: () => context
                          .read<CarBloc>()
                          .add(const CarFilterChanged(status: CarStatus.planned)),
                    ),
                    _QuickFilterChip(
                      label: 'В работе',
                      selected: state.statusFilter == CarStatus.inProgress,
                      onSelected: () => context
                          .read<CarBloc>()
                          .add(const CarFilterChanged(status: CarStatus.inProgress)),
                    ),
                    _QuickFilterChip(
                      label: 'Готовые',
                      selected: state.statusFilter == CarStatus.completed,
                      onSelected: () => context
                          .read<CarBloc>()
                          .add(const CarFilterChanged(status: CarStatus.completed)),
                    ),
                    _QuickFilterChip(
                      label: 'Избранные',
                      selected: state.favoritesOnly,
                      onSelected: () => context
                          .read<CarBloc>()
                          .add(CarFilterChanged(favoritesOnly: !state.favoritesOnly)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CarListView(
                  cars: state.filteredCars,
                  onOpenDetails: (car) => Navigator.of(context).pushNamed(
                    AppRoutes.carDetails,
                    arguments: car.id,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Разделы'),
                  SizedBox(height: 8),
                  Text('Управление картотекой авто'),
                ],
              ),
            ),
            _DrawerTile(
              icon: Icons.calendar_month,
              title: 'Запланированные осмотры',
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(AppRoutes.plannedCars);
              },
            ),
            _DrawerTile(
              icon: Icons.check_circle,
              title: 'Обслуженные авто',
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(AppRoutes.completedCars);
              },
            ),
            _DrawerTile(
              icon: Icons.star_half,
              title: 'Оцененные авто',
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(AppRoutes.ratedCars);
              },
            ),
            _DrawerTile(
              icon: Icons.view_comfy,
              title: 'Коллекция по брендам',
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(AppRoutes.collection);
              },
            ),
            _DrawerTile(
              icon: Icons.bar_chart,
              title: 'Статистика',
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(AppRoutes.statistics);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SummarySection extends StatelessWidget {
  const _SummarySection({required this.state});

  final CarState state;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        scrollDirection: Axis.horizontal,
        children: [
          _SummaryCard(
            title: 'Всего авто',
            value: state.cars.length.toString(),
            icon: Icons.directions_car,
            color: Colors.blue,
          ),
          _SummaryCard(
            title: 'Запланировано',
            value: state.plannedCars.length.toString(),
            icon: Icons.calendar_month,
            color: Colors.orange,
          ),
          _SummaryCard(
            title: 'Готовы',
            value: state.completedCars.length.toString(),
            icon: Icons.check_circle,
            color: Colors.green,
          ),
          _SummaryCard(
            title: 'Избранные',
            value: state.favoriteCars.length.toString(),
            icon: Icons.star,
            color: Colors.amber,
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 16),
              Text(
                value,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickFilterChip extends StatelessWidget {
  const _QuickFilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onSelected(),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
