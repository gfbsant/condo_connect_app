import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

@injectable
class LogoutUseCase implements UseCaseNoParams {
  LogoutUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, void>> call() => repository.logout();
}
