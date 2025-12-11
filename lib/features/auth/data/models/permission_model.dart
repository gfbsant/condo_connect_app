//
// ignore_for_file: overridden_fields

import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/permission_entity.dart';
import '../../domain/enums/permission_role.dart';
import '../../domain/enums/permission_type.dart';
part 'permission_model.g.dart';

@JsonSerializable(createToJson: false)
class PermissionModel extends PermissionEntity {
  const PermissionModel({
    required super.condominiumId,
    required this.role,
    required this.permissions,
  }) : super(role: role, permissions: permissions);

  factory PermissionModel.fromJson(final Map<String, dynamic> json) =>
      _$PermissionModelFromJson(json);

  @override
  @JsonKey(fromJson: _permissionsFromJson)
  final List<PermissionType> permissions;

  static List<PermissionType> _permissionsFromJson(final List<dynamic> json) =>
      PermissionType.fromStringList(
        json.map((final e) => e.toString()).toList(),
      );

  @override
  @JsonKey(fromJson: _roleFromJson)
  final PermissionRole role;

  static PermissionRole _roleFromJson(final String json) =>
      PermissionRole.fromString(json) ?? PermissionRole.resident;
}
