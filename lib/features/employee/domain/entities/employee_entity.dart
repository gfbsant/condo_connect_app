import 'package:equatable/equatable.dart';

import '../../../user/domain/entities/user_entity.dart';
import '../enums/employee_role.dart';

class EmployeeEntity extends Equatable {
  const EmployeeEntity({
    required this.condominiumId,
    required this.role,
    this.email,
    this.userId,
    this.id,
    this.description,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final int condominiumId;
  final int? userId;
  final String? email;
  final String? description;
  final EmployeeRole role;
  final UserEntity? user;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isAdmin => role == EmployeeRole.admin;

  @override
  List<Object?> get props => [
    id,
    userId,
    condominiumId,
    description,
    role,
    user,
    createdAt,
    updatedAt,
  ];
}
