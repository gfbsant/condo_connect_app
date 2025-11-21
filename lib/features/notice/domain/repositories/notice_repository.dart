import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/notice_entity.dart';

abstract class NoticeRepository {
  Future<Either<Failure, NoticeEntity>> createNotice(
    final int apartmentId,
    final NoticeEntity notice,
  );

  Future<Either<Failure, List<NoticeEntity>>> getNoticesByCondo(
    final int condoId,
  );

  Future<Either<Failure, List<NoticeEntity>>> getNoticesByApartment(
    final int apartmentId,
  );

  Future<Either<Failure, NoticeEntity>> getNoticeById(final int id);

  Future<Either<Failure, NoticeEntity>> updateNotice(
    final int id,
    final NoticeEntity notice,
  );

  Future<Either<Failure, void>> deleteNotice(final int id);
}
