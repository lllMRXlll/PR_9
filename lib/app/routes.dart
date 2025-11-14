import 'package:flutter/material.dart';

import '../features/auth/view/auth_screen.dart';
import '../features/cars/view/car_collection_screen.dart';
import '../features/cars/view/car_detail_screen.dart';
import '../features/cars/view/car_form_screen.dart';
import '../features/cars/view/completed_cars_screen.dart';
import '../features/cars/view/planned_cars_screen.dart';
import '../features/cars/view/rated_cars_screen.dart';
import '../features/dashboard/view/home_screen.dart';
import '../features/dashboard/view/splash_screen.dart';
import '../features/profile/view/profile_screen.dart';
import '../features/stats/view/car_statistics_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const profile = '/profile';
  static const carForm = '/car-form';
  static const carDetails = '/car-details';
  static const plannedCars = '/planned-cars';
  static const completedCars = '/completed-cars';
  static const ratedCars = '/rated-cars';
  static const collection = '/collection';
  static const statistics = '/statistics';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const AuthScreen(mode: AuthMode.login),
        );
      case AppRoutes.register:
        return MaterialPageRoute(
          builder: (_) => const AuthScreen(mode: AuthMode.register),
        );
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case AppRoutes.carForm:
        final carId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => CarFormScreen(carId: carId),
        );
      case AppRoutes.carDetails:
        final carId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => CarDetailScreen(carId: carId),
        );
      case AppRoutes.plannedCars:
        return MaterialPageRoute(builder: (_) => const PlannedCarsScreen());
      case AppRoutes.completedCars:
        return MaterialPageRoute(builder: (_) => const CompletedCarsScreen());
      case AppRoutes.ratedCars:
        return MaterialPageRoute(builder: (_) => const RatedCarsScreen());
      case AppRoutes.collection:
        return MaterialPageRoute(builder: (_) => const CarCollectionScreen());
      case AppRoutes.statistics:
        return MaterialPageRoute(builder: (_) => const CarStatisticsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => UnknownRouteScreen(routeName: settings.name ?? ''),
        );
    }
  }
}

class UnknownRouteScreen extends StatelessWidget {
  const UnknownRouteScreen({super.key, required this.routeName});

  final String routeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Маршрут $routeName не найден'),
      ),
    );
  }
}
