import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/usecase/usecase.dart';
import '../entities/reservation_entity.dart';
import '../repositories/reservation_repository.dart';

@injectable
class CreateReservationUseCase
    implements UseCase<ReservationEntity, CreateReservationParams> {
  const CreateReservationUseCase(this._repository);

  final ReservationRepository _repository;

  @override
  Future<Either<Failure, ReservationEntity>> call(
    final CreateReservationParams params,
  ) => _repository.createReservation(params.facilityId, params.reservation);
}

class CreateReservationParams {
  const CreateReservationParams({
    required this.facilityId,
    required this.reservation,
  });

  final int facilityId;
  final ReservationEntity reservation;
}
