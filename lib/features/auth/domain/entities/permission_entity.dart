import 'package:equatable/equatable.dart';

class PermissionEntity extends Equatable {
  const PermissionEntity({
    required this.condominiumId,
    required this.role,
    required this.permissions,
  });

  final int condominiumId;
  final String role;
  final List<String> permissions;

  @override
  List<Object?> get props => [condominiumId, role, permissions];
}
