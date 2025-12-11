import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/exceptions/api_exception.dart';
import '../../domain/datasources/resident_remote_datasource.dart';
import '../../domain/entities/resident_entity.dart';
import '../../domain/repositories/resident_repository.dart';
import '../models/resident_model.dart';

@Injectable(as: ResidentRepository)
class ResidentRepositoryImpl implements ResidentRepository {
  ResidentRepositoryImpl(this._remoteDataSource);

  final ResidentRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, ResidentEntity>> createResident(
    final int apartmentId,
    final String email,
  ) async {
    try {
      final ResidentModel result = await _remoteDataSource.createResident(
        apartmentId,
        email,
      );

      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao criar morador: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ResidentEntity>>> getResidentsByApartment(
    final int apartmentId,
  ) async {
    try {
      final List<ResidentModel> result = await _remoteDataSource
          .getResidentsByApartment(apartmentId);

      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao obter moradores: $e'));
    }
  }

  @override
  Future<Either<Failure, ResidentEntity>> getResidentById(
    final int residentId,
  ) async {
    try {
      final ResidentModel response = await _remoteDataSource.getResidentById(
        residentId,
      );

      return Right(response);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao obter morador: $e'));
    }
  }

  @override
  Future<Either<Failure, ResidentEntity>> updateResident(
    final int apartmentId,
    final int residentId,
    final ResidentEntity resident,
  ) async {
    try {
      final residentModel = ResidentModel.fromEntity(resident);
      final ResidentModel response = await _remoteDataSource.updateResident(
        apartmentId,
        residentId,
        residentModel,
      );

      return Right(response);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao atualizar morador: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteResident(
    final int apartmentId,
    final int residentId,
  ) async {
    try {
      await _remoteDataSource.deleteResident(apartmentId, residentId);

      return const Right(null);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao deletar morador: $e'));
    }
  }
}
