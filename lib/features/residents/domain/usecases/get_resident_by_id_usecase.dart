import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/usecase/usecase.dart';
import '../entities/resident_entity.dart';
import '../repositories/resident_repository.dart';

@injectable
class GetResidentByIdUseCase
    implements UseCase<ResidentEntity, GetResidentByIdParams> {
  const GetResidentByIdUseCase(this._repository);

  final ResidentRepository _repository;

  @override
  Future<Either<Failure, ResidentEntity>> call(
    final GetResidentByIdParams params,
  ) => _repository.getResidentById(params.residentId);
}

class GetResidentByIdParams {
  const GetResidentByIdParams({required this.residentId});

  final int residentId;
}
