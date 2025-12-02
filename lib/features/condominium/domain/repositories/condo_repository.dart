import 'package:dartz/dartz.dart';

import '../../../../shared/errors/failures.dart';
import '../entities/condominium_entity.dart';

abstract class CondoRepository {
  Future<Either<Failure, CondominiumEntity>> createCondo(
    final CondominiumEntity condo,
  );

  Future<Either<Failure, CondominiumEntity>> getCondoById(final int id);

  Future<Either<Failure, List<CondominiumEntity>>> searchCondos({
    final String? query,
  });

  Future<Either<Failure, CondominiumEntity>> updateCondo(
    final int id,
    final CondominiumEntity condo,
  );

  Future<Either<Failure, void>> deleteCondo(final int id);
}
