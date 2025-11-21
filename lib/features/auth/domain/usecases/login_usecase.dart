import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../user/domain/entities/user_entity.dart';
import '../repositories/auth_repository.dart';

@injectable
class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  const LoginUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, UserEntity>> call(final LoginParams params) =>
      repository.login(email: params.email, password: params.password);
}

class LoginParams {
  const LoginParams({required this.email, required this.password});

  final String email;
  final String password;
}
