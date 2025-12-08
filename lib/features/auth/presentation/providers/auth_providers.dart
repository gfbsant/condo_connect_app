import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/services/storage/secure_storage_service.dart';
import '../../../user/domain/entities/user_entity.dart';
import '../../domain/usecases/confirm_password_reset_usecase.dart';
import '../../domain/usecases/get_user_permissions_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/request_password_reset_usecase.dart';
import 'auth_notifier.dart';
import 'auth_state.dart';

// Use Cases
final Provider<LoginUseCase> loginUseCaseProvider =
    Provider.autoDispose<LoginUseCase>((final ref) => getIt<LoginUseCase>());

final Provider<GetUserPermissionsUseCase> getUserPermissionsUseCaseProvider =
    Provider.autoDispose<GetUserPermissionsUseCase>(
      (_) => getIt<GetUserPermissionsUseCase>(),
    );

final Provider<LogoutUseCase> logoutUseCaseProvider =
    Provider.autoDispose<LogoutUseCase>((final ref) => getIt<LogoutUseCase>());

final Provider<RegisterUseCase> registerUseCaseProvider =
    Provider.autoDispose<RegisterUseCase>(
      (final ref) => getIt<RegisterUseCase>(),
    );

final Provider<RequestPasswordResetUseCase>
requestPasswordResetUseCaseProvider =
    Provider.autoDispose<RequestPasswordResetUseCase>(
      (final ref) => getIt<RequestPasswordResetUseCase>(),
    );

final Provider<ConfirmPasswordResetUseCase>
confirmPasswordResetUseCaseProvider =
    Provider.autoDispose<ConfirmPasswordResetUseCase>(
      (final ref) => getIt<ConfirmPasswordResetUseCase>(),
    );

final Provider<SecureStorageService> secureStorageServiceProvider =
    Provider.autoDispose<SecureStorageService>(
      (final ref) => getIt<SecureStorageService>(),
    );

// Provider principal do auth
final NotifierProvider<AuthNotifier, AuthState> authNotifierProvider =
    NotifierProvider.autoDispose<AuthNotifier, AuthState>(AuthNotifier.new);

// Providers auxiliares
final Provider<AuthNotifier> authNotifierAccessor =
    Provider.autoDispose<AuthNotifier>(
      (final ref) => ref.watch(authNotifierProvider.notifier),
    );

final Provider<UserEntity?> currentUserProvider =
    Provider.autoDispose<UserEntity?>(
      (final ref) => ref.watch(authNotifierProvider).user,
    );

final Provider<bool> isAuthenticatedProvider = Provider.autoDispose<bool>(
  (final ref) =>
      ref.watch(authNotifierProvider).status == AuthStatus.authenticated,
);

final Provider<bool> isLoadingProvider = Provider.autoDispose<bool>(
  (final ref) => ref.watch(authNotifierProvider).status == AuthStatus.loading,
);
