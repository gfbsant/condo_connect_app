import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/usecase/usecase.dart';
import '../entities/facility_entity.dart';
import '../repositories/facility_repository.dart';

@injectable
class GetFacilityByIdUseCase
    implements UseCase<FacilityEntity, GetFacilityByIdParams> {
  const GetFacilityByIdUseCase(this._repository);

  final FacilityRepository _repository;

  @override
  Future<Either<Failure, FacilityEntity>> call(
    final GetFacilityByIdParams params,
  ) => _repository.getFacilityById(params.facilityId);
}

class GetFacilityByIdParams {
  const GetFacilityByIdParams({required this.facilityId});

  final int facilityId;
}
