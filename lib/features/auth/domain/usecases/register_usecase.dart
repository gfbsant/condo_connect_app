import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/usecase/usecase.dart';
import '../../../user/domain/entities/user_entity.dart';
import '../repositories/auth_repository.dart';

@injectable
class RegisterUseCase implements UseCase<UserEntity, RegisterParams> {
  const RegisterUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, UserEntity>> call(final RegisterParams params) =>
      repository.register(user: params.user);
}

class RegisterParams {
  const RegisterParams({required this.user});

  final UserEntity user;
}
