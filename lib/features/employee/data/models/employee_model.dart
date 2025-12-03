//
// ignore_for_file: overridden_fields

import 'package:json_annotation/json_annotation.dart';

import '../../../user/data/models/user_model.dart';
import '../../../user/domain/entities/user_entity.dart';
import '../../domain/entities/employee_entity.dart';
import '../../domain/enums/employee_role.dart';

part 'employee_model.g.dart';

@JsonSerializable()
class EmployeeModel extends EmployeeEntity {
  const EmployeeModel({
    required super.condominiumId,
    required super.role,
    super.email,
    super.userId,
    this.id,
    super.description,
    this.user,
    this.createdAt,
    this.updatedAt,
  }) : super(id: id, user: user, createdAt: createdAt, updatedAt: updatedAt);

  factory EmployeeModel.fromEntity(final EmployeeEntity entity) =>
      EmployeeModel(
        id: entity.id,
        userId: entity.userId,
        email: entity.email,
        condominiumId: entity.condominiumId,
        description: entity.description,
        role: entity.role,
        user: entity.user,
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
  final DateTime? createdAt;

  @JsonKey(includeToJson: false)
  @override
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() => _$EmployeeModelToJson(this);

  EmployeeEntity toEntity() => EmployeeEntity(
    id: id,
    userId: userId,
    email: email,
    condominiumId: condominiumId,
    description: description,
    role: role,
    user: user,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  @JsonKey(includeToJson: false, fromJson: _userFromJson)
  @override
  final UserEntity? user;

  static UserEntity? _userFromJson(final Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return UserModel.fromJson(json);
  }
}
