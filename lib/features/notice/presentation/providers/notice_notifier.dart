import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/notice_entity.dart';
import '../../domain/usecases/create_notice_usecase.dart';
import '../../domain/usecases/delete_notice_usecase.dart';
import '../../domain/usecases/get_notice_by_id_usecase.dart';
import '../../domain/usecases/get_notices_by_apartment_usecase.dart';
import '../../domain/usecases/get_notices_by_condo_usecase.dart';
import '../../domain/usecases/update_notice_usecase.dart';
import 'notice_providers.dart';
import 'notice_state.dart';

class NoticeNotifier extends Notifier<NoticeState> {
  late final CreateNoticeUseCase _createNoticeUseCase;
  late final GetNoticesByApartmentUseCase _getNoticesByApartmentUseCase;
  late final GetNoticesByCondoUseCase _getNoticesByCondoUseCase;
  late final GetNoticeByIdUseCase _getNoticeByIdUseCase;
  late final UpdateNoticeUseCase _updateNoticeUseCase;
  late final DeleteNoticeUseCase _deleteNoticeUseCase;

  bool get _isLoading => state.status == NoticeStatus.loading;

  bool get _isSearching => state.status == NoticeStatus.searching;

  @override
  NoticeState build() {
    _createNoticeUseCase = ref.read(createNoticeUseCaseProvider);
    _getNoticesByApartmentUseCase = ref.read(
      getNoticesByApartmentUseCaseProvider,
    );
    _getNoticesByCondoUseCase = ref.read(getNoticesByCondoUseCaseProvider);
    _getNoticeByIdUseCase = ref.read(getNoticeByIdUseCaseProvider);
    _updateNoticeUseCase = ref.read(updateNoticeUseCaseProvider);
    _deleteNoticeUseCase = ref.read(deleteNoticeUseCaseProvider);
    return const NoticeState.initial();
  }

  Future<bool> createNotice(
    final int apartmentId,
    final NoticeEntity notice,
  ) async {
    if (_isLoading) {
      return false;
    }

    _setLoadingState();

    final Either<Failure, NoticeEntity> result = await _createNoticeUseCase(
      CreateNoticeParams(apartmentId, notice),
    );

    return result.fold(
      (final failure) {
        state = state.copyWith(
          status: NoticeStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (final createdNotice) {
        final updatedNotices = List<NoticeEntity>.from(state.notices)
          ..add(createdNotice);
        state = state.copyWith(
          status: NoticeStatus.success,
          notices: updatedNotices,
          successMessage: 'Aviso criado com sucesso',
        );
        return true;
      },
    );
  }

  Future<void> getNoticesByApartment(final int apartmentId) async {
    if (_isSearching) {
      return;
    }

    _setSearchingState();

    final Either<Failure, List<NoticeEntity>> result =
        await _getNoticesByApartmentUseCase(
          GetNoticesByApartmentParams(apartmentId),
        );

    result.fold(
      (final failure) => state = state.copyWith(
        status: NoticeStatus.error,
        errorMessage: failure.message,
      ),
      (final notices) => state = state.copyWith(
        notices: notices,
        status: NoticeStatus.initial,
      ),
    );
  }

  Future<void> getNoticesByCondo(final int condoId) async {
    if (_isSearching) {
      return;
    }

    _setSearchingState();

    final Either<Failure, List<NoticeEntity>> result =
        await _getNoticesByCondoUseCase(GetNoticesByCondoParams(condoId));

    result.fold(
      (final failure) => state = state.copyWith(
        status: NoticeStatus.error,
        errorMessage: failure.message,
      ),
      (final notices) => state = state.copyWith(
        notices: notices,
        status: NoticeStatus.initial,
      ),
    );
  }

  Future<void> getNoticeById(final int id) async {
    if (_isLoading) {
      return;
    }

    _setLoadingState();

    final Either<Failure, NoticeEntity> result = await _getNoticeByIdUseCase(
      GetNoticeByIdParams(id),
    );

    result.fold(
      (final failure) => state = state.copyWith(
        status: NoticeStatus.searching,
        errorMessage: failure.message,
      ),
      (final notice) => state = state.copyWith(
        selectedNotice: notice,
        status: NoticeStatus.initial,
      ),
    );
  }

  Future<bool> updateNotice(final int id, final NoticeEntity notice) async {
    if (_isLoading) {
      return false;
    }

    _setLoadingState();

    final Either<Failure, NoticeEntity> result = await _updateNoticeUseCase(
      UpdateNoticeParams(id, notice),
    );

    return result.fold(
      (final failure) {
        state = state.copyWith(
          status: NoticeStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (final updatedNotice) {
        final List<NoticeEntity> updatedNotices = state.notices
            .map((final n) => n.id == id ? updatedNotice : n)
            .toList();
        state = state.copyWith(
          status: NoticeStatus.success,
          notices: updatedNotices,
          selectedNotice: state.selectedNotice?.id == id
              ? updatedNotice
              : state.selectedNotice,
          successMessage: 'Aviso atualizado com sucesso!',
        );
        return true;
      },
    );
  }

  Future<bool> deleteNotice(final int id) async {
    if (_isLoading) {
      return false;
    }

    _setLoadingState();

    final Either<Failure, void> result = await _deleteNoticeUseCase(
      DeleteNoticeParams(id),
    );

    return result.fold(
      (final failure) {
        state = state.copyWith(
          status: NoticeStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (_) {
        final List<NoticeEntity> updatedNotices = state.notices
            .where((final n) => n.id != id)
            .toList();
        state = state.copyWith(
          status: NoticeStatus.success,
          notices: updatedNotices,
          successMessage: 'Aviso deletado com sucesso',
          clearSelectedNotice: state.selectedNotice?.id == id,
        );
        return true;
      },
    );
  }

  void clearMessages() {
    if (state.errorMessage != null || state.successMessage != null) {
      state = state.copyWith(clearMessages: true);
    }
  }

  void clearSelectedNotice() {
    if (state.selectedNotice != null) {
      state = state.copyWith(clearSelectedNotice: true);
    }
  }

  void _setLoadingState() {
    state = state.copyWith(status: NoticeStatus.loading, clearMessages: true);
  }

  void _setSearchingState() {
    state = state.copyWith(status: NoticeStatus.searching, clearMessages: true);
  }
}
