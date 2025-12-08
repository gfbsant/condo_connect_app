import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/exceptions/api_exception.dart';
import '../../domain/datasources/reservation_remote_datasource.dart';
import '../../domain/entities/reservation_entity.dart';
import '../../domain/repositories/reservation_repository.dart';
import '../models/reservation_model.dart';

@Injectable(as: ReservationRepository)
class ReservationRepositoryImpl implements ReservationRepository {
  const ReservationRepositoryImpl(this._remoteDataSource);

  final ReservationRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, ReservationEntity>> createReservation(
    final int facilityId,
    final ReservationEntity reservation,
  ) async {
    try {
      final reservationModel = ReservationModel.fromEntity(reservation);
      final ReservationModel result = await _remoteDataSource.createReservation(
        facilityId,
        reservationModel,
      );

      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao criar reserva: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ReservationEntity>>> getReservationsByApartment(
    final int apartmentId,
  ) async {
    try {
      final List<ReservationModel> result = await _remoteDataSource
          .getReservationsByApartment(apartmentId);

      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao obter reservas: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ReservationEntity>>> getReservationsByFacility(
    final int facilityId,
  ) async {
    try {
      final List<ReservationModel> result = await _remoteDataSource
          .getReservationsByFacility(facilityId);

      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao obter reservas: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReservation(
    final int reservationId,
  ) async {
    try {
      await _remoteDataSource.deleteReservation(reservationId);

      return const Right(null);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao deletar reserva: $e'));
    }
  }
}
