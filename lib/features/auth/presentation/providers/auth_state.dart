import 'package:equatable/equatable.dart';

import '../../../user/domain/entities/user_entity.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  success,
  error,
}

class AuthState extends Equatable {
  const AuthState({required this.status, this.user, this.errorMessage});

  const AuthState.initial()
    : status = AuthStatus.initial,
      user = null,
      errorMessage = null;

  AuthState copyWith({
    final AuthStatus? status,
    final UserEntity? user,
    final String? errorMessage,
    final bool clearMessage = false,
  }) => AuthState(
    status: status ?? this.status,
    user: user ?? this.user,
    errorMessage: clearMessage ? null : (errorMessage ?? this.errorMessage),
  );

  final AuthStatus status;

  final UserEntity? user;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, user, errorMessage];
}
