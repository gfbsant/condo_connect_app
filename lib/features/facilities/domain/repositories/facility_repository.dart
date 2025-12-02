import 'package:dartz/dartz.dart';

import '../../../../shared/errors/failures.dart';
import '../entities/facility_entity.dart';

abstract class FacilityRepository {
  Future<Either<Failure, FacilityEntity>> createFacility(
    final int condominiumId,
    final FacilityEntity facility,
  );

  Future<Either<Failure, List<FacilityEntity>>> getFacilitiesByCondo(
    final int condominiumId,
  );

  Future<Either<Failure, FacilityEntity>> getFacilityById(final int facilityId);

  Future<Either<Failure, FacilityEntity>> updateFacility(
    final int facilityId,
    final FacilityEntity facility,
  );

  Future<Either<Failure, void>> deleteFacility(final int facilityId);
}
