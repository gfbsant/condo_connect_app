import 'package:equatable/equatable.dart';

import '../enums/permission_role.dart';
import '../enums/permission_type.dart';

class PermissionEntity extends Equatable {
  const PermissionEntity({
    required this.condominiumId,
    required this.role,
    required this.permissions,
  });

  final int condominiumId;
  final PermissionRole role;
  final List<PermissionType> permissions;

  @override
  List<Object?> get props => [condominiumId, role, permissions];
}

extension PermissionEntityExtension on PermissionEntity {
  bool hasPermission(final PermissionType permission) =>
      permissions.contains(permission);

  bool hasAnyPermission(final List<PermissionType> permissionList) =>
      permissionList.any(permissions.contains);

  bool hasAllPermissions(final List<PermissionType> permissionList) =>
      permissionList.every(permissions.contains);
}
