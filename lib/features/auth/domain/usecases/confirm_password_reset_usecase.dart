import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class ConfirmPasswordResetUseCase
    implements UseCase<void, ConfirmPasswordResetParams> {
  const ConfirmPasswordResetUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, void>> call(final ConfirmPasswordResetParams params) =>
      repository.resetPassword(
        token: params.token,
        newPassword: params.newPassword,
      );
}

class ConfirmPasswordResetParams {
  const ConfirmPasswordResetParams({
    required this.token,
    required this.newPassword,
  });

  final String token;
  final String newPassword;
}
