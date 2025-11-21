import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/apartment_entity.dart';

abstract class ApartmentRepository {
  Future<Either<Failure, ApartmentEntity>> createApartment(
    final ApartmentEntity apartment,
  );

  Future<Either<Failure, ApartmentEntity>> getApartmentById(final int id);

  Future<Either<Failure, List<ApartmentEntity>>> searchApartments(
    final int condoId,
    final String? query,
  );
}
