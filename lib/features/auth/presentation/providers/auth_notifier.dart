import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/storage/secure_storage_service.dart';
import '../../../../shared/errors/failures.dart';
import '../../../user/domain/entities/user_entity.dart';
import '../../domain/usecases/confirm_password_reset_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/request_password_reset_usecase.dart';
import 'auth_providers.dart';
import 'auth_state.dart';

class AuthNotifier extends Notifier<AuthState> {
  late final LoginUseCase _loginUseCase;
  late final LogoutUseCase _logoutUseCase;
  late final RegisterUseCase _registerUseCase;
  late final RequestPasswordResetUseCase _requestPasswordResetUseCase;
  late final ConfirmPasswordResetUseCase _confirmPasswordResetUseCase;
  late final SecureStorageService _secureStorageService;

  bool get stateIsLoading => state.status == AuthStatus.loading;

  @override
  AuthState build() {
    _loginUseCase = ref.read(loginUseCaseProvider);
    _logoutUseCase = ref.read(logoutUseCaseProvider);
    _registerUseCase = ref.read(registerUseCaseProvider);
    _requestPasswordResetUseCase = ref.read(
      requestPasswordResetUseCaseProvider,
    );
    _confirmPasswordResetUseCase = ref.read(
      confirmPasswordResetUseCaseProvider,
    );
    _secureStorageService = ref.read(secureStorageServiceProvider);
    return const AuthState.initial();
  }

  Future<void> checkAuthStatus() async {
    final String? token = await _secureStorageService.getAccessToken();
    if (token == null) {
      state = state.copyWith(status: AuthStatus.authenticated);
    } else {
      state = state.copyWith(status: AuthStatus.initial);
    }
  }

  Future<void> login({
    required final String email,
    required final String password,
  }) async {
    if (state.status == AuthStatus.loading) {
      return;
    }

    _setLoadingState();

    final Either<Failure, UserEntity> result = await _loginUseCase(
      LoginParams(email: email, password: password),
    );

    result.fold(
      (final failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (final user) =>
          state = state.copyWith(status: AuthStatus.authenticated, user: user),
    );
  }

  Future<void> register({
    required final String name,
    required final String email,
    required final String password,
    required final String cpf,
    required final String birthDate,
    final String? phone,
  }) async {
    if (stateIsLoading) {
      return;
    }

    _setLoadingState();

    try {
      final user = UserEntity(
        email: email,
        name: name,
        cpf: cpf,
        password: password,
        birthDate: birthDate,
      );

      final Either<Failure, UserEntity> result = await _registerUseCase.call(
        RegisterParams(user: user),
      );

      result.fold(
        (final failure) => state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        ),
        (final user) =>
            state = state.copyWith(status: AuthStatus.initial, user: user),
      );
    } on Exception catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Erro ao registrar: $e',
      );
    }
  }

  Future<void> logout() async {
    if (stateIsLoading) {
      return;
    }

    _setLoadingState();

    try {
      final Either<Failure, void> result = await _logoutUseCase();

      result.fold(
        (final failure) => state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        ),
        (final _) => state = const AuthState.initial(),
      );
    } on Exception catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Erro ao fazer login: $e',
      );
    }
  }

  Future<void> requestPasswordReset({required final String email}) async {
    if (stateIsLoading) {
      return;
    }

    _setLoadingState();

    final Either<Failure, void> result = await _requestPasswordResetUseCase(
      RequestPasswordResetParams(email: email),
    );

    result.fold(
      (final failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (final _) => state = state.copyWith(status: AuthStatus.success),
    );
  }

  Future<void> confirmPasswordReset({
    required final String token,
    required final String newPassword,
  }) async {
    if (stateIsLoading) {
      return;
    }

    _setLoadingState();

    final Either<Failure, void> result = await _confirmPasswordResetUseCase(
      ConfirmPasswordResetParams(token: token, newPassword: newPassword),
    );

    result.fold(
      (final failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (final _) => state = state.copyWith(status: AuthStatus.success),
    );
  }

  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(clearMessage: true);
    }
  }

  void _setLoadingState() {
    state = state.copyWith(status: AuthStatus.loading);
  }
}
