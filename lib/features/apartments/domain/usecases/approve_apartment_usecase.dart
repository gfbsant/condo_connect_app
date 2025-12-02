import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/usecase/usecase.dart';
import '../entities/apartment_entity.dart';
import '../repositories/apartment_repository.dart';

@injectable
class ApproveApartmentUseCase
    implements UseCase<ApartmentEntity, ApproveApartmentParams> {
  const ApproveApartmentUseCase(this._repository);

  final ApartmentRepository _repository;

  @override
  Future<Either<Failure, ApartmentEntity>> call(
    final ApproveApartmentParams params,
  ) => _repository.approveApartment(params.apartmentId);
}

class ApproveApartmentParams {
  const ApproveApartmentParams({required this.apartmentId});

  final int apartmentId;
}
