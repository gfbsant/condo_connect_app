import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/exceptions/api_exception.dart';
import '../../domain/datasources/notice_remote_datasource.dart';
import '../../domain/entities/notice_entity.dart';
import '../../domain/repositories/notice_repository.dart';
import '../models/notice_model.dart';

@Injectable(as: NoticeRepository)
class NoticeRepositoryImpl implements NoticeRepository {
  const NoticeRepositoryImpl(this.remoteDataSource);

  final NoticeRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, NoticeEntity>> createNotice(
    final int apartmentId,
    final NoticeEntity notice,
  ) async {
    try {
      final noticeModel = NoticeModel.fromEntity(notice);
      final NoticeModel createdNotice = await remoteDataSource.createNotice(
        apartmentId,
        noticeModel,
      );

      return Right(createdNotice);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao criar aviso: $e'));
    }
  }

  @override
  Future<Either<Failure, List<NoticeEntity>>> getNoticesByApartment(
    final int apartmentId,
  ) async {
    try {
      final List<NoticeModel> result = await remoteDataSource
          .getNoticesByApartment(apartmentId);

      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao obter avisos: $e'));
    }
  }

  @override
  Future<Either<Failure, List<NoticeEntity>>> getNoticesByCondo(
    final int condoId,
  ) async {
    try {
      final List<NoticeModel> result = await remoteDataSource.getNoticesByCondo(
        condoId,
      );

      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao obter avisos: $e'));
    }
  }

  @override
  Future<Either<Failure, NoticeEntity>> getNoticeById(final int id) async {
    try {
      final NoticeModel result = await remoteDataSource.getNoticeById(id);

      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao obter aviso: $e'));
    }
  }

  @override
  Future<Either<Failure, NoticeEntity>> updateNotice(
    final int id,
    final NoticeEntity notice,
  ) async {
    try {
      final noticeModel = NoticeModel.fromEntity(notice);
      final NoticeModel updatedNotice = await remoteDataSource.updateNotice(
        id,
        noticeModel,
      );

      return Right(updatedNotice);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao atualizar aviso: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotice(final int id) async {
    try {
      await remoteDataSource.deleteNotice(id);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao deletar aviso: $e'));
    }
  }
}
