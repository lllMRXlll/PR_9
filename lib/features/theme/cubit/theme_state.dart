import 'package:equatable/equatable.dart';

class ThemeState extends Equatable {
  const ThemeState({this.isDarkMode = false});

  final bool isDarkMode;

  ThemeState copyWith({bool? isDarkMode}) =>
      ThemeState(isDarkMode: isDarkMode ?? this.isDarkMode);

  Map<String, dynamic> toJson() => {'isDarkMode': isDarkMode};

  factory ThemeState.fromJson(Map<String, dynamic> json) {
    return ThemeState(isDarkMode: json['isDarkMode'] as bool? ?? false);
  }

  @override
  List<Object?> get props => [isDarkMode];
}
