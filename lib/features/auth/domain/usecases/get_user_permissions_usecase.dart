import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/usecase/usecase.dart';
import '../entities/permission_entity.dart';
import '../repositories/auth_repository.dart';

@injectable
class GetUserPermissionsUseCase
    implements UseCaseNoParams<List<PermissionEntity>> {
  GetUserPermissionsUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, List<PermissionEntity>>> call() =>
      _repository.getUserPermissions();
}
