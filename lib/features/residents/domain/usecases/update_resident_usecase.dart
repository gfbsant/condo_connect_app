import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/usecase/usecase.dart';
import '../entities/resident_entity.dart';
import '../repositories/resident_repository.dart';

@injectable
class UpdateResidentUseCase
    implements UseCase<ResidentEntity, UpdateResidentParams> {
  UpdateResidentUseCase(this._repository);

  final ResidentRepository _repository;

  @override
  Future<Either<Failure, ResidentEntity>> call(
    final UpdateResidentParams params,
  ) => _repository.updateResident(
    params.apartmentId,
    params.residentId,
    params.resident,
  );
}

class UpdateResidentParams {
  const UpdateResidentParams({
    required this.apartmentId,
    required this.residentId,
    required this.resident,
  });

  final int apartmentId;
  final int residentId;
  final ResidentEntity resident;
}
