import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'theme_state.dart';

class ThemeCubit extends HydratedCubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());

  void toggle() => emit(state.copyWith(isDarkMode: !state.isDarkMode));

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    try {
      return ThemeState.fromJson(json);
    } catch (_) {
      return const ThemeState();
    }
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) => state.toJson();
}
