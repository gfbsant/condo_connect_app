import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/usecase/usecase.dart';
import '../entities/facility_entity.dart';
import '../repositories/facility_repository.dart';

@injectable
class UpdateFacilityUseCase
    implements UseCase<FacilityEntity, UpdateFacilityParams> {
  const UpdateFacilityUseCase(this._repository);

  final FacilityRepository _repository;

  @override
  Future<Either<Failure, FacilityEntity>> call(
    final UpdateFacilityParams params,
  ) => _repository.updateFacility(params.facilityId, params.facility);
}

class UpdateFacilityParams {
  const UpdateFacilityParams({
    required this.facilityId,
    required this.facility,
  });

  final int facilityId;
  final FacilityEntity facility;
}
