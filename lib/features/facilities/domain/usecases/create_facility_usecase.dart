import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/usecase/usecase.dart';
import '../entities/facility_entity.dart';
import '../repositories/facility_repository.dart';

@injectable
class CreateFacilityUseCase
    implements UseCase<FacilityEntity, CreateFacilityParams> {
  CreateFacilityUseCase(this._repository);

  final FacilityRepository _repository;

  @override
  Future<Either<Failure, FacilityEntity>> call(
    final CreateFacilityParams params,
  ) => _repository.createFacility(params.condominiumId, params.facility);
}

class CreateFacilityParams {
  const CreateFacilityParams({
    required this.condominiumId,
    required this.facility,
  });

  final int condominiumId;
  final FacilityEntity facility;
}
