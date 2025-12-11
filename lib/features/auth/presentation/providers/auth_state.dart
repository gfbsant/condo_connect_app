import 'package:equatable/equatable.dart';

import '../../../user/domain/entities/user_entity.dart';
import '../../domain/entities/permission_entity.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  success,
  error,
}

class AuthState extends Equatable {
  const AuthState({
    required this.status,
    this.permissions = const [],
    this.user,
    this.errorMessage,
    this.successMessage,
    this.isLoadingPermissions = false,
  });

  const AuthState.initial()
    : status = AuthStatus.initial,
      permissions = const [],
      user = null,
      errorMessage = null,
      successMessage = null,
      isLoadingPermissions = false;

  AuthState copyWith({
    final AuthStatus? status,
    final UserEntity? user,
    final List<PermissionEntity>? permissions,
    final String? errorMessage,
    final String? successMessage,
    final bool? isLoadingPermissions,
    final bool clearMessages = false,
  }) => AuthState(
    status: status ?? this.status,
    user: user ?? this.user,
    permissions: permissions ?? this.permissions,
    errorMessage: clearMessages ? null : errorMessage ?? this.errorMessage,
    successMessage: clearMessages
        ? null
        : successMessage ?? this.successMessage,
    isLoadingPermissions: isLoadingPermissions ?? this.isLoadingPermissions,
  );

  final AuthStatus status;
  final UserEntity? user;
  final List<PermissionEntity> permissions;
  final String? errorMessage;
  final String? successMessage;
  final bool isLoadingPermissions;

  @override
  List<Object?> get props => [
    status,
    user,
    permissions,
    errorMessage,
    successMessage,
  ];
}
