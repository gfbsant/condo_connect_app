import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/services/storage/secure_storage_service.dart';
import '../../../user/domain/entities/user_entity.dart';
import '../../domain/entities/permission_entity.dart';
import '../../domain/usecases/confirm_password_reset_usecase.dart';
import '../../domain/usecases/get_user_permissions_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/request_password_reset_usecase.dart';
import 'auth_notifier.dart';
import 'auth_state.dart';

// Use Cases
final loginUseCaseProvider = Provider<LoginUseCase>(
  (final ref) => getIt<LoginUseCase>(),
);

final getUserPermissionsUseCaseProvider = Provider<GetUserPermissionsUseCase>(
  (_) => getIt<GetUserPermissionsUseCase>(),
);

final logoutUseCaseProvider = Provider<LogoutUseCase>(
  (final ref) => getIt<LogoutUseCase>(),
);

final registerUseCaseProvider = Provider<RegisterUseCase>(
  (final ref) => getIt<RegisterUseCase>(),
);

final requestPasswordResetUseCaseProvider =
    Provider<RequestPasswordResetUseCase>(
      (final ref) => getIt<RequestPasswordResetUseCase>(),
    );

final confirmPasswordResetUseCaseProvider =
    Provider<ConfirmPasswordResetUseCase>(
      (final ref) => getIt<ConfirmPasswordResetUseCase>(),
    );

final secureStorageServiceProvider = Provider<SecureStorageService>(
  (final ref) => getIt<SecureStorageService>(),
);

// ✅ REMOVIDO .autoDispose - mantém o estado global
final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

// Providers auxiliares
final authNotifierAccessor = Provider<AuthNotifier>(
  (final ref) => ref.watch(authNotifierProvider.notifier),
);

final currentUserProvider = Provider<UserEntity?>(
  (final ref) => ref.watch(authNotifierProvider.select((final s) => s.user)),
);

final permissionsProvider = Provider<List<PermissionEntity>>(
  (final ref) =>
      ref.watch(authNotifierProvider.select((final s) => s.permissions)),
);

final isAuthenticatedProvider = Provider<bool>(
  (final ref) =>
      ref.watch(authNotifierProvider.select((final s) => s.status)) ==
      AuthStatus.authenticated,
);

final isLoadingProvider = Provider<bool>(
  (final ref) =>
      ref.watch(authNotifierProvider.select((final s) => s.status)) ==
      AuthStatus.loading,
);

final authStatusProvider = Provider<AuthStatus>(
  (final ref) => ref.watch(authNotifierProvider.select((final s) => s.status)),
);

final isLoadingPermissionsProvider = Provider<bool>(
  (final ref) => ref.watch(
    authNotifierProvider.select((final s) => s.isLoadingPermissions),
  ),
);
