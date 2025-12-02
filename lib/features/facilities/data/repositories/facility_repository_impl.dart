import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/exceptions/api_exception.dart';
import '../../domain/datasources/facility_remote_datasource.dart';
import '../../domain/entities/facility_entity.dart';
import '../../domain/repositories/facility_repository.dart';
import '../models/facility_model.dart';

@Injectable(as: FacilityRepository)
class FacilityRepositoryImpl implements FacilityRepository {
  const FacilityRepositoryImpl(this._remoteDataSource);

  final FacilityRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, FacilityEntity>> createFacility(
    final int condominiumId,
    final FacilityEntity facility,
  ) async {
    try {
      final facilityModel = FacilityModel.fromEntity(facility);
      final FacilityModel result = await _remoteDataSource.createFacility(
        condominiumId,
        facilityModel,
      );

      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao criar área comum: $e'));
    }
  }

  @override
  Future<Either<Failure, List<FacilityEntity>>> getFacilitiesByCondo(
    final int condominiumId,
  ) async {
    try {
      final List<FacilityModel> result = await _remoteDataSource
          .getFacilitiesByCondo(condominiumId);

      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao obter áreas comuns: $e'));
    }
  }

  @override
  Future<Either<Failure, FacilityEntity>> getFacilityById(
    final int facilityId,
  ) async {
    try {
      final FacilityModel result = await _remoteDataSource.getFacilityById(
        facilityId,
      );

      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao obter área comum: $e'));
    }
  }

  @override
  Future<Either<Failure, FacilityEntity>> updateFacility(
    final int id,
    final FacilityEntity facility,
  ) async {
    try {
      final facilityModel = FacilityModel.fromEntity(facility);
      final FacilityModel result = await _remoteDataSource.updateFacility(
        id,
        facilityModel,
      );

      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao atualizar área comum: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFacility(final int facilityId) async {
    try {
      await _remoteDataSource.deleteFacility(facilityId);

      return const Right(null);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao deletar área comum: $e'));
    }
  }
}
