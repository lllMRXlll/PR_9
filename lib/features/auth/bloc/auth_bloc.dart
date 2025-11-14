import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:flutter_application_9/core/repositories/auth_repository.dart';
import 'package:flutter_application_9/features/profile/cubit/profile_cubit.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthRepository repository,
    ProfileCubit? profileCubit,
  })  : _repository = repository,
        _profileCubit = profileCubit,
        super(AuthState.unauthenticated()) {
    on<AuthLoginRequested>(_onLogin);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthLogoutRequested>(_onLogout);
  }

  final AuthRepository _repository;
  final ProfileCubit? _profileCubit;

  Future<void> _onLogin(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final user = await _repository.login(
        email: event.email,
        password: event.password,
      );
      _profileCubit?.syncWithUser(user);
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          isLoading: false,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          isLoading: false,
          error: error.toString(),
        ),
      );
    }
  }

  Future<void> _onRegister(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final user = await _repository.register(
        fullName: event.fullName,
        email: event.email,
        password: event.password,
        company: event.company,
      );
      _profileCubit?.syncWithUser(user);
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          isLoading: false,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          isLoading: false,
          error: error.toString(),
        ),
      );
    }
  }

  void _onLogout(AuthLogoutRequested event, Emitter<AuthState> emit) {
    emit(AuthState.unauthenticated());
    _profileCubit?.reset();
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    try {
      final restored = AuthState.fromJson(json);
      if (restored.user != null) {
        _profileCubit?.syncWithUser(restored.user!);
      }
      return restored;
    } catch (_) {
      return AuthState.unauthenticated();
    }
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) => state.toJson();
}
