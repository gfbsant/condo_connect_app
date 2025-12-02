import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

@injectable
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
