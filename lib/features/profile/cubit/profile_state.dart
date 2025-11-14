import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.fullName = '',
    this.email = '',
    this.company = '',
    this.avatarUrl = '',
    this.bio = 'Добавьте информацию о себе и задачах автопарка.',
    this.totalCars = 0,
    this.plannedCars = 0,
    this.completedCars = 0,
    this.ratedCars = 0,
  });

  final String fullName;
  final String email;
  final String company;
  final String avatarUrl;
  final String bio;
  final int totalCars;
  final int plannedCars;
  final int completedCars;
  final int ratedCars;

  ProfileState copyWith({
    String? fullName,
    String? email,
    String? company,
    String? avatarUrl,
    String? bio,
    int? totalCars,
    int? plannedCars,
    int? completedCars,
    int? ratedCars,
  }) {
    return ProfileState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      company: company ?? this.company,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      totalCars: totalCars ?? this.totalCars,
      plannedCars: plannedCars ?? this.plannedCars,
      completedCars: completedCars ?? this.completedCars,
      ratedCars: ratedCars ?? this.ratedCars,
    );
  }

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'email': email,
        'company': company,
        'avatarUrl': avatarUrl,
        'bio': bio,
        'totalCars': totalCars,
        'plannedCars': plannedCars,
        'completedCars': completedCars,
        'ratedCars': ratedCars,
      };

  factory ProfileState.fromJson(Map<String, dynamic> json) {
    return ProfileState(
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      company: json['company'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      totalCars: json['totalCars'] as int? ?? 0,
      plannedCars: json['plannedCars'] as int? ?? 0,
      completedCars: json['completedCars'] as int? ?? 0,
      ratedCars: json['ratedCars'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        fullName,
        email,
        company,
        avatarUrl,
        bio,
        totalCars,
        plannedCars,
        completedCars,
        ratedCars,
      ];
}
