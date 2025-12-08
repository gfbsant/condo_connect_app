import 'package:dartz/dartz.dart';

import '../../../../shared/errors/failures.dart';
import '../../../user/domain/entities/user_entity.dart';
import '../entities/permission_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required final String email,
    required final String password,
  });

  Future<Either<Failure, List<PermissionEntity>>> getUserPermissions();

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, UserEntity>> register({
    required final UserEntity user,
  });

  Future<Either<Failure, void>> requestPasswordReset(final String email);

  Future<Either<Failure, void>> resetPassword({
    required final String token,
    required final String newPassword,
  });
}
