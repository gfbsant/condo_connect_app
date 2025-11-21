import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/condominium_entity.dart';
import '../repositories/condo_repository.dart';

@injectable
class UpdateCondoUseCase
    implements UseCase<CondominiumEntity, UpdateCondoParams> {
  const UpdateCondoUseCase(this._repository);

  final CondoRepository _repository;

  @override
  Future<Either<Failure, CondominiumEntity>> call(
    final UpdateCondoParams params,
  ) => _repository.updateCondo(params.id, params.condo);
}

class UpdateCondoParams {
  const UpdateCondoParams({required this.id, required this.condo});

  final int id;
  final CondominiumEntity condo;
}
