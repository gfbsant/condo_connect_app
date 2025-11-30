import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/resident_entity.dart';

abstract class ResidentRepository {
  Future<Either<Failure, ResidentEntity>> createResident(
    final int apartmentId,
    final int userId,
  );

  Future<Either<Failure, List<ResidentEntity>>> getResidentsByApartment(
    final int apartmentId,
  );

  Future<Either<Failure, ResidentEntity>> getResidentById(
    final int apartmentId,
    final int residentId,
  );

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
