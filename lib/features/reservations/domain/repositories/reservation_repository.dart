import 'package:dartz/dartz.dart';

import '../../../../shared/errors/failures.dart';
import '../entities/reservation_entity.dart';

abstract class ReservationRepository {
  Future<Either<Failure, ReservationEntity>> createReservation(
    final int facilityId,
    final ReservationEntity reservation,
  );

  Future<Either<Failure, List<ReservationEntity>>> getReservationsByApartment(
    final int apartmentId,
  );

  Future<Either<Failure, List<ReservationEntity>>> getReservationsByFacility(
    final int facilityId,
  );

  Future<Either<Failure, void>> deleteReservation(final int reservationId);
}
