import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/usecase/usecase.dart';
import '../entities/apartment_entity.dart';
import '../repositories/apartment_repository.dart';

@injectable
class UpdateApartmentUseCase
    implements UseCase<ApartmentEntity, UpdateApartmentParams> {
  const UpdateApartmentUseCase(this._repository);

  final ApartmentRepository _repository;

  @override
  Future<Either<Failure, ApartmentEntity>> call(
    final UpdateApartmentParams params,
  ) => _repository.updateApartment(params.id, params.apartment);
}

class UpdateApartmentParams {
  const UpdateApartmentParams({required this.id, required this.apartment});

  final int id;
  final ApartmentEntity apartment;
}
