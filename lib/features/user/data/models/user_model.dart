//
// ignore_for_file: overridden_fields

import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends UserEntity {
  const UserModel({
    required super.email,
    required super.name,
    required super.cpf,
    required super.birthdate,
    required super.password,
    super.phone,
    this.id,
    this.createdAt,
    this.updatedAt,
  }) : super(id: id, updatedAt: updatedAt, createdAt: createdAt);

  factory UserModel.fromEntity(final UserEntity entity) => UserModel(
    id: entity.id,
    email: entity.email,
    name: entity.name,
    birthdate: entity.birthdate,
    cpf: entity.cpf,
    password: entity.password,
    phone: entity.phone,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );

  factory UserModel.fromJson(final Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  @JsonKey(includeToJson: false)
  @override
  final int? id;

  @JsonKey(includeToJson: false)
  @override
  final DateTime? createdAt;

  @JsonKey(includeToJson: false)
  @override
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserEntity toEntity() => UserEntity(
    id: id,
    email: email,
    name: name,
    cpf: cpf,
    password: password,
    birthdate: birthdate,
    phone: phone,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
