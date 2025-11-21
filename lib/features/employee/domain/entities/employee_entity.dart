import 'package:equatable/equatable.dart';

import '../enums/employee_role.dart';

class EmployeeEntity extends Equatable {
  const EmployeeEntity({
    required this.userId,
    required this.condominiumId,
    required this.role,
    required this.createdAt,
    this.id,
    this.description,
    this.updatedAt,
  });

  final int? id;
  final int userId;
  final int condominiumId;
  final String? description;
  final EmployeeRole role;
  final DateTime createdAt;
  final DateTime? updatedAt;

  bool get isAdmin => role == EmployeeRole.admin;

  @override
  List<Object?> get props => [
    id,
    userId,
    condominiumId,
    description,
    role,
    createdAt,
    updatedAt,
  ];
}
