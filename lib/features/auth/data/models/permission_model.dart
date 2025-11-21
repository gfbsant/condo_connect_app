import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/permission_entity.dart';
part 'permission_model.g.dart';

@JsonSerializable()
class PermissionModel extends PermissionEntity {
  const PermissionModel({
    required super.condominiumId,
    required super.role,
    required super.permissions,
  });

  factory PermissionModel.fromJson(final Map<String, dynamic> json) =>
      _$PermissionModelFromJson(json);

  Map<String, dynamic> json() => _$PermissionModelToJson(this);

  PermissionEntity toEntity() => PermissionEntity(
    condominiumId: condominiumId,
    role: role,
    permissions: permissions,
  );
}
