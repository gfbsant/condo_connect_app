import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/usecase/usecase.dart';
import '../repositories/facility_repository.dart';

@injectable
class DeleteFacilityUseCase implements UseCase<void, DeleteFacilityParams> {
  const DeleteFacilityUseCase(this._repository);

  final FacilityRepository _repository;

  @override
  Future<Either<Failure, void>> call(final DeleteFacilityParams params) =>
      _repository.deleteFacility(params.facilityId);
}

class DeleteFacilityParams {
  const DeleteFacilityParams({required this.facilityId});

  final int facilityId;
}
