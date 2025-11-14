import 'package:equatable/equatable.dart';

import 'package:flutter_application_9/core/models/user.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.isLoading = false,
    this.error,
  });

  final AuthStatus status;
  final User? user;
  final bool isLoading;
  final String? error;

  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  factory AuthState.unauthenticated() =>
      const AuthState(status: AuthStatus.unauthenticated);

  factory AuthState.authenticated(User user) => AuthState(
        status: AuthStatus.authenticated,
        user: user,
      );

  Map<String, dynamic> toJson() => {
        'status': status.name,
        'user': user?.toJson(),
      };

  factory AuthState.fromJson(Map<String, dynamic> json) {
    final statusString = json['status'] as String? ?? AuthStatus.unknown.name;
    final mappedStatus = AuthStatus.values.firstWhere(
      (element) => element.name == statusString,
      orElse: () => AuthStatus.unknown,
    );
    return AuthState(
      status: mappedStatus,
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  List<Object?> get props => [status, user, isLoading, error];
}
