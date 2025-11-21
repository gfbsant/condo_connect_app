//
// ignore_for_file: overridden_fields

import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/employee_entity.dart';
import '../../domain/enums/employee_role.dart';

part 'employee_model.g.dart';

@JsonSerializable()
class EmployeeModel extends EmployeeEntity {
  const EmployeeModel({
    required super.userId,
    required super.condominiumId,
    required super.role,
    required this.createdAt,
    this.id,
    super.description,
    this.updatedAt,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  factory EmployeeModel.fromEntity(final EmployeeEntity entity) =>
      EmployeeModel(
        id: entity.id,
        userId: entity.userId,
        condominiumId: entity.condominiumId,
        description: entity.description,
        role: entity.role,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );

  factory EmployeeModel.fromJson(final Map<String, dynamic> json) =>
      _$EmployeeModelFromJson(json);

  @JsonKey(includeToJson: false)
  @override
  final int? id;

  @JsonKey(includeToJson: false)
  @override
  final DateTime createdAt;

  @JsonKey(includeToJson: false)
  @override
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() => _$EmployeeModelToJson(this);

  EmployeeEntity toEntity() => EmployeeEntity(
    id: id,
    userId: userId,
    condominiumId: condominiumId,
    description: description,
    role: role,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
