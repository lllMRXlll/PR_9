import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/routes.dart';
import 'package:flutter_application_9/features/cars/widgets/car_highlight_card.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

enum AuthMode { login, register }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.mode = AuthMode.login});

  final AuthMode mode;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _companyController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _companyController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _companyController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(AuthMode mode) {
    if (!_formKey.currentState!.validate()) return;
    final bloc = context.read<AuthBloc>();
    if (mode == AuthMode.login) {
      bloc.add(
        AuthLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    } else {
      bloc.add(
        AuthRegisterRequested(
          fullName: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          company: _companyController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.error != null && state.error!.isNotEmpty) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error!)));
          }
          if (state.isAuthenticated) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
          }
        },
        builder: (context, state) {
          final mode = widget.mode;
          final isLogin = mode == AuthMode.login;
          return SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 720;
                final form = _AuthForm(
                  formKey: _formKey,
                  isLogin: isLogin,
                  fullNameController: _fullNameController,
                  companyController: _companyController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  isLoading: state.isLoading,
                  onSubmit: () => _submit(mode),
                );
                final intro = _AuthIntro(isLogin: isLogin);
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: isWide
                      ? Row(
                          children: [
                            Expanded(child: intro),
                            const SizedBox(width: 24),
                            Expanded(child: form),
                          ],
                        )
                      : ListView(
                          children: [
                            intro,
                            const SizedBox(height: 24),
                            form,
                          ],
                        ),
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: TextButton(
          onPressed: () {
            final newMode =
                widget.mode == AuthMode.login ? AuthMode.register : AuthMode.login;
            Navigator.of(context).pushReplacementNamed(
              newMode == AuthMode.login ? '/login' : '/register',
            );
          },
          child: Text(
            widget.mode == AuthMode.login
                ? 'Нет аккаунта? Зарегистрируйтесь'
                : 'Уже есть аккаунт? Войдите',
            style: theme.textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}

class _AuthIntro extends StatelessWidget {
  const _AuthIntro({required this.isLogin});

  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    final title = isLogin ? 'Авторизация' : 'Регистрация';
    final description = isLogin
        ? 'Получите доступ к картотеке автопарка и отслеживайте обслуживание.'
        : 'Создайте аккаунт и ведите учёт всех машин организации.';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        Text(description, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 24),
        const CarHighlightCard(),
      ],
    );
  }
}

class _AuthForm extends StatelessWidget {
  const _AuthForm({
    required this.formKey,
    required this.isLogin,
    required this.fullNameController,
    required this.companyController,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final bool isLogin;
  final TextEditingController fullNameController;
  final TextEditingController companyController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!isLogin) ...[
                TextFormField(
                  controller: fullNameController,
                  decoration: const InputDecoration(labelText: 'ФИО'),
                  validator: _required,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: companyController,
                  decoration: const InputDecoration(labelText: 'Компания/подразделение'),
                  validator: _required,
                ),
                const SizedBox(height: 12),
              ],
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: _required,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Пароль'),
                obscureText: true,
                validator: _required,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: isLoading ? null : onSubmit,
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(isLogin ? 'Войти' : 'Зарегистрироваться'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'Обязательное поле' : null;
}
