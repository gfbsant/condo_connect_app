import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/usecase/usecase.dart';
import '../entities/resident_entity.dart';
import '../repositories/resident_repository.dart';

@injectable
class GetResidentsByApartmentUseCase
    implements UseCase<List<ResidentEntity>, GetResidentsByApartmentParams> {
  const GetResidentsByApartmentUseCase(this._repository);

  final ResidentRepository _repository;

  @override
  Future<Either<Failure, List<ResidentEntity>>> call(
    final GetResidentsByApartmentParams params,
  ) => _repository.getResidentsByApartment(params.apartmentId);
}

class GetResidentsByApartmentParams {
  const GetResidentsByApartmentParams({required this.apartmentId});

  final int apartmentId;
}
