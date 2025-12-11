// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PermissionModel _$PermissionModelFromJson(Map<String, dynamic> json) =>
    PermissionModel(
      condominiumId: (json['condominiumId'] as num).toInt(),
      role: PermissionModel._roleFromJson(json['role'] as String),
      permissions: PermissionModel._permissionsFromJson(
        json['permissions'] as List,
      ),
    );
