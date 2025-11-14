import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../../core/models/user.dart';
import 'profile_state.dart';

class ProfileCubit extends HydratedCubit<ProfileState> {
  ProfileCubit() : super(const ProfileState());

  void syncWithUser(User user) {
    emit(
      state.copyWith(
        fullName: user.fullName,
        email: user.email,
        company: user.company,
      ),
    );
  }

  void updateBio(String value) {
    emit(state.copyWith(bio: value));
  }

  void updateAvatar(String url) {
    emit(state.copyWith(avatarUrl: url));
  }

  void updateStats({
    int? total,
    int? planned,
    int? completed,
    int? rated,
  }) {
    emit(
      state.copyWith(
        totalCars: total ?? state.totalCars,
        plannedCars: planned ?? state.plannedCars,
        completedCars: completed ?? state.completedCars,
        ratedCars: rated ?? state.ratedCars,
      ),
    );
  }

  void reset() => emit(const ProfileState());

  @override
  ProfileState? fromJson(Map<String, dynamic> json) {
    try {
      return ProfileState.fromJson(json);
    } catch (_) {
      return const ProfileState();
    }
  }

  @override
  Map<String, dynamic>? toJson(ProfileState state) => state.toJson();
}
