import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/repositories/auth_repository.dart';
import '../core/repositories/car_repository.dart';
import '../features/auth/bloc/auth_bloc.dart';
import '../features/cars/bloc/car_bloc.dart';
import '../features/profile/cubit/profile_cubit.dart';
import '../features/theme/cubit/theme_cubit.dart';
import '../features/theme/cubit/theme_state.dart';
import 'routes.dart';
import 'theme.dart';

class AutoCatalogApp extends StatelessWidget {
  const AutoCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository()),
        RepositoryProvider(create: (_) => CarRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeCubit()),
          BlocProvider(create: (_) => ProfileCubit()),
          BlocProvider(
            create: (context) => AuthBloc(
              repository: context.read<AuthRepository>(),
              profileCubit: context.read<ProfileCubit>(),
            ),
          ),
          BlocProvider(
            create: (context) => CarBloc(
              repository: context.read<CarRepository>(),
              profileCubit: context.read<ProfileCubit>(),
            ),
          ),
        ],
        child: const _AppView(),
      ),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          title: 'Картотека авто',
          theme: buildLightTheme(),
          darkTheme: buildDarkTheme(),
          themeMode: themeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRouter.onGenerateRoute,
        );
      },
    );
  }
}
