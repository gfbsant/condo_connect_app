import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

@injectable
class RequestPasswordResetUseCase
    implements UseCase<void, RequestPasswordResetParams> {
  const RequestPasswordResetUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, void>> call(final RequestPasswordResetParams params) =>
      repository.requestPasswordReset(params.email);
}

class RequestPasswordResetParams {
  const RequestPasswordResetParams({required this.email});

  final String email;
}
