import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/usecase/usecase.dart';
import '../entities/reservation_entity.dart';
import '../repositories/reservation_repository.dart';

@injectable
class GetReservationsByFacilityUseCase
    implements
        UseCase<List<ReservationEntity>, GetReservationsByFacilityParams> {
  const GetReservationsByFacilityUseCase(this._repository);

  final ReservationRepository _repository;

  @override
  Future<Either<Failure, List<ReservationEntity>>> call(
    final GetReservationsByFacilityParams params,
  ) => _repository.getReservationsByFacility(params.facilityId);
}

class GetReservationsByFacilityParams {
  const GetReservationsByFacilityParams({required this.facilityId});

  final int facilityId;
}
