import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/usecase/usecase.dart';
import '../repositories/reservation_repository.dart';

@injectable
class DeleteReservationUseCase
    implements UseCase<void, DeleteReservationParams> {
  const DeleteReservationUseCase(this._repository);

  final ReservationRepository _repository;
  @override
  Future<Either<Failure, void>> call(final DeleteReservationParams params) =>
      _repository.deleteReservation(params.reservationId);
}

class DeleteReservationParams {
  const DeleteReservationParams({required this.reservationId});

  final int reservationId;
}
