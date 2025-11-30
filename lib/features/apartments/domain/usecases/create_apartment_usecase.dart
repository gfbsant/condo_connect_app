import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/apartment_entity.dart';
import '../repositories/apartment_repository.dart';

@injectable
class CreateApartmentUseCase
    implements UseCase<ApartmentEntity, CreateApartmentParams> {
  CreateApartmentUseCase(this._repository);

  final ApartmentRepository _repository;

  @override
  Future<Either<Failure, ApartmentEntity>> call(
    final CreateApartmentParams params,
  ) => _repository.createApartment(params.apartment);
}

class CreateApartmentParams {
  const CreateApartmentParams({required this.apartment});

  final ApartmentEntity apartment;
}
