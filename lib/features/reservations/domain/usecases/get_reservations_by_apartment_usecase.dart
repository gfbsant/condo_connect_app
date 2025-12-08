import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/usecase/usecase.dart';
import '../entities/reservation_entity.dart';
import '../repositories/reservation_repository.dart';

@injectable
class GetReservationsByApartmentUseCase
    implements
        UseCase<List<ReservationEntity>, GetReservationsByApartmentParams> {
  const GetReservationsByApartmentUseCase(this._repository);

  final ReservationRepository _repository;

  @override
  Future<Either<Failure, List<ReservationEntity>>> call(
    final GetReservationsByApartmentParams params,
  ) => _repository.getReservationsByApartment(params.apartmentId);
}

class GetReservationsByApartmentParams {
  const GetReservationsByApartmentParams({required this.apartmentId});

  final int apartmentId;
}
