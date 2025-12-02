import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/usecase/usecase.dart';
import '../entities/facility_entity.dart';
import '../repositories/facility_repository.dart';

@injectable
class GetFacilitiesByCondoUseCase
    implements UseCase<List<FacilityEntity>, GetFacilitiesByCondoParams> {
  const GetFacilitiesByCondoUseCase(this._repository);

  final FacilityRepository _repository;

  @override
  Future<Either<Failure, List<FacilityEntity>>> call(
    final GetFacilitiesByCondoParams params,
  ) => _repository.getFacilitiesByCondo(params.condominiumId);
}

class GetFacilitiesByCondoParams {
  const GetFacilitiesByCondoParams({required this.condominiumId});

  final int condominiumId;
}
