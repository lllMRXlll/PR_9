import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  const AuthRegisterRequested({
    required this.fullName,
    required this.email,
    required this.password,
    required this.company,
  });

  final String fullName;
  final String email;
  final String password;
  final String company;

  @override
  List<Object?> get props => [fullName, email, password, company];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
