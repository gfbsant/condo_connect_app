import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/exceptions/api_exception.dart';
import '../../domain/datasources/condo_remote_datasource.dart';
import '../../domain/entities/condominium_entity.dart';
import '../../domain/repositories/condo_repository.dart';
import '../models/condominium_model.dart';

@Injectable(as: CondoRepository)
class CondoRepositoryImpl implements CondoRepository {
  const CondoRepositoryImpl(this.remoteDataSource);

  final CondoRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, CondominiumEntity>> createCondo(
    final CondominiumEntity condo,
  ) async {
    try {
      final CondominiumModel result = await remoteDataSource.createCondominium(
        CondominiumModel.fromEntity(condo),
      );
      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro no login: $e'));
    }
  }

  @override
  Future<Either<Failure, List<CondominiumEntity>>> searchCondos({
    final String? query,
  }) async {
    try {
      final List<CondominiumModel> result = await remoteDataSource.searchCondos(
        query: query,
      );
      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao buscar condos: $e'));
    }
  }

  @override
  Future<Either<Failure, CondominiumEntity>> getCondoById(final int id) async {
    try {
      final CondominiumModel result = await remoteDataSource.getCondominiumById(
        id,
      );
      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao buscar condo: $e'));
    }
  }

  @override
  Future<Either<Failure, CondominiumEntity>> updateCondo(
    final int id,
    final CondominiumEntity condo,
  ) async {
    try {
      final CondominiumModel result = await remoteDataSource.updateCondominium(
        id,
        CondominiumModel.fromEntity(condo),
      );
      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao atualizar condo: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCondo(final int id) async {
    try {
      await remoteDataSource.deleteCondominium(id);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao deletar condominio: $e'));
    }
  }
}
