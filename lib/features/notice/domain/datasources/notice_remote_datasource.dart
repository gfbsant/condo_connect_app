import '../../data/models/notice_model.dart';

abstract class NoticeRemoteDataSource {
  Future<NoticeModel> createNotice(
    final int apartmentId,
    final NoticeModel notice,
  );

  Future<List<NoticeModel>> getNoticesByCondo(final int condoId);

  Future<List<NoticeModel>> getNoticesByApartment(final int apartmentId);

  Future<NoticeModel> getNoticeById(final int id);

  Future<NoticeModel> updateNotice(final int id, final NoticeModel notice);

  Future<void> deleteNotice(final int id);
}
