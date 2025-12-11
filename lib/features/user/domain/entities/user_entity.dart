import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.email,
    required this.name,
    required this.cpf,
    required this.birthdate,
    required this.password,
    this.id,
    this.phone,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String? email;
  final String name;
  final String? cpf;
  final String? birthdate;
  final String? password;
  final String? phone;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    cpf,
    birthdate,
    password,
    phone,
    createdAt,
    updatedAt,
  ];
}
