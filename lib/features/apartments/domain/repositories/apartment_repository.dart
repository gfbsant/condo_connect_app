import 'package:dartz/dartz.dart';

import '../../../../shared/errors/failures.dart';
import '../entities/apartment_entity.dart';

abstract class ApartmentRepository {
  Future<Either<Failure, ApartmentEntity>> createApartment(
    final int condominiumId,
    final ApartmentEntity apartment,
  );

  Future<Either<Failure, List<ApartmentEntity>>> getApartmentsByCondo(
    final int condominiumId,
    final Map<String, String>? query,
  );

  Future<Either<Failure, ApartmentEntity>> getApartmentById(
    final int apartmentId,
  );

  Future<Either<Failure, ApartmentEntity>> updateApartment(
    final int apartmentId,
    final ApartmentEntity apartment,
  );

  Future<Either<Failure, ApartmentEntity>> approveApartment(
    final int apartmentId,
  );

  Future<Either<Failure, void>> deleteApartment(final int apartmentId);
}
