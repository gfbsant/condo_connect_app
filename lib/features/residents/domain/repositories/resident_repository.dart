import 'package:dartz/dartz.dart';

import '../../../../shared/errors/failures.dart';
import '../entities/resident_entity.dart';

abstract class ResidentRepository {
  Future<Either<Failure, ResidentEntity>> createResident(
    final int apartmentId,
    final String email,
  );

  Future<Either<Failure, List<ResidentEntity>>> getResidentsByApartment(
    final int apartmentId,
  );

  Future<Either<Failure, ResidentEntity>> getResidentById(final int residentId);

  Future<Either<Failure, ResidentEntity>> updateResident(
    final int apartmentId,
    final int residentId,
    final ResidentEntity resident,
  );

  Future<Either<Failure, void>> deleteResident(
    final int apartmentId,
    final int residentId,
  );
}
