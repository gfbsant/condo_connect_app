import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/apartment_repository.dart';

@injectable
class DeleteApartmentUseCase implements UseCase<void, DeleteApartmentParams> {
  const DeleteApartmentUseCase(this._repository);

  final ApartmentRepository _repository;

  @override
  Future<Either<Failure, void>> call(final DeleteApartmentParams params) =>
      _repository.deleteApartment(params.apartmentId);
}

class DeleteApartmentParams {
  const DeleteApartmentParams({required this.apartmentId});

  final int apartmentId;
}
