import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/usecase/usecase.dart';
import '../entities/condominium_entity.dart';
import '../repositories/condo_repository.dart';

@injectable
class CreateCondoUseCase
    implements UseCase<CondominiumEntity, CreateCondoParams> {
  const CreateCondoUseCase(this._repository);

  final CondoRepository _repository;

  @override
  Future<Either<Failure, CondominiumEntity>> call(
    final CreateCondoParams params,
  ) => _repository.createCondo(params.condo);
}

class CreateCondoParams {
  const CreateCondoParams({required this.condo});

  final CondominiumEntity condo;
}
