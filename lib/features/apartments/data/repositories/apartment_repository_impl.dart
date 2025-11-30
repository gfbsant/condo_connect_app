import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/exceptions/api_exception.dart';
import '../../domain/datasources/apartment_remote_datasource.dart';
import '../../domain/entities/apartment_entity.dart';
import '../../domain/repositories/apartment_repository.dart';
import '../models/apartment_model.dart';

@Injectable(as: ApartmentRepository)
class ApartmentRepositoryImpl implements ApartmentRepository {
  ApartmentRepositoryImpl(this._remoteDataSource);

  final ApartmentRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, ApartmentEntity>> createApartment(
    final ApartmentEntity apartment,
  ) async {
    try {
      final apartmentModel = ApartmentModel.fromEntity(apartment);
      final ApartmentModel result = await _remoteDataSource.createApartment(
        apartmentModel,
      );

      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao criar apartamento: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ApartmentEntity>>> getApartmentsByCondo(
    final int condominiumId,
    final Map<String, String>? query,
  ) async {
    try {
      final List<ApartmentModel> result = await _remoteDataSource
          .getApartmentsByCondo(condominiumId, query);

      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao obter apartamentos: $e'));
    }
  }

  @override
  Future<Either<Failure, ApartmentEntity>> getApartmentById(
    final int apartmentId,
  ) async {
    try {
      final ApartmentModel result = await _remoteDataSource.getApartmentById(
        apartmentId,
      );

      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao obter apartamento: $e'));
    }
  }

  @override
  Future<Either<Failure, ApartmentEntity>> updateApartment(
    final int apartmentId,
    final ApartmentEntity apartment,
  ) async {
    try {
      final apartmentModel = ApartmentModel.fromEntity(apartment);
      final ApartmentModel result = await _remoteDataSource.updateApartment(
        apartmentId,
        apartmentModel,
      );

      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao atualizar apartamento: $e'));
    }
  }

  @override
  Future<Either<Failure, ApartmentEntity>> approveApartment(
    final int apartmentId,
  ) async {
    try {
      final ApartmentModel result = await _remoteDataSource.approveApartment(
        apartmentId,
      );

      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao aprovar apartamento: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteApartment(final int apartmentId) async {
    try {
      await _remoteDataSource.deleteApartment(apartmentId);

      return const Right(null);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao deletar apartamento: $e'));
    }
  }
}
