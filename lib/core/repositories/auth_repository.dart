import 'dart:async';

import '../models/user.dart';

class AuthRepository {
  final Map<String, _Account> _accounts = {
    'admin@garage.ru': _Account(
      password: '123456',
      user: const User(
        id: 'user-1',
        fullName: 'Александр Соколов',
        email: 'admin@garage.ru',
        company: 'Гараж №9',
      ),
    )
  };

  Future<User> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final account = _accounts[email.toLowerCase()];
    if (account == null || account.password != password) {
      throw const AuthException('Неверный email или пароль');
    }
    return account.user;
  }

  Future<User> register({
    required String fullName,
    required String email,
    required String password,
    required String company,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final normalizedEmail = email.toLowerCase();
    if (_accounts.containsKey(normalizedEmail)) {
      throw const AuthException('Пользователь уже существует');
    }
    final user = User(
      id: 'user-${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName,
      email: normalizedEmail,
      company: company,
    );
    _accounts[normalizedEmail] = _Account(password: password, user: user);
    return user;
  }
}

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}

class _Account {
  const _Account({required this.password, required this.user});
  final String password;
  final User user;
}
