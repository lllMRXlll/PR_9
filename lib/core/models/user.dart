import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.company,
  });

  final String id;
  final String fullName;
  final String email;
  final String company;

  User copyWith({
    String? id,
    String? fullName,
    String? email,
    String? company,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      company: company ?? this.company,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      company: json['company'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'company': company,
      };

  @override
  List<Object?> get props => [id, fullName, email, company];
}
