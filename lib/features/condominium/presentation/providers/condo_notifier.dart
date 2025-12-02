import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/errors/failures.dart';
import '../../domain/entities/condominium_entity.dart';
import '../../domain/usecases/create_condo_usecase.dart';
import '../../domain/usecases/delete_condo_usecase.dart';
import '../../domain/usecases/get_condo_by_id_usecase.dart';
import '../../domain/usecases/search_condos_usecase.dart';
import '../../domain/usecases/update_condo_usecase.dart';
import 'condo_providers.dart';
import 'condo_state.dart';

class CondoNotifier extends Notifier<CondoState> {
  late final CreateCondoUseCase _createCondoUseCase;
  late final SearchCondosUseCase _searchCondosUseCase;
  late final GetCondoByIdUseCase _getCondoByIdUseCase;
  late final UpdateCondoUseCase _updateCondoUseCase;
  late final DeleteCondoUseCase _deleteCondoUseCase;

  @override
  CondoState build() {
    _createCondoUseCase = ref.read(createCondoUseCaseProvider);
    _searchCondosUseCase = ref.read(searchCondosUseCaseProvider);
    _getCondoByIdUseCase = ref.read(getCondoByIdUseCaseProvider);
    _updateCondoUseCase = ref.read(updateCondoUseCaseProvider);
    _deleteCondoUseCase = ref.read(deleteCondoUseCaseProvider);
    return const CondoState.initial();
  }

  Future<bool> createCondo(final CondominiumEntity condo) async {
    if (state.status == CondoStatus.loading) {
      return false;
    }

    _setLoadingState();

    final Either<Failure, CondominiumEntity> result = await _createCondoUseCase(
      CreateCondoParams(condo: condo),
    );

    return result.fold(
      (final failure) {
        state = state.copyWith(
          status: CondoStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (final createdCondo) {
        final updatedCondos = List<CondominiumEntity>.from(state.condos)
          ..add(createdCondo);
        state = state.copyWith(
          status: CondoStatus.success,
          condos: updatedCondos,
          successMessage: 'Condominio criado com sucesso',
        );
        return true;
      },
    );
  }

  Future<void> searchCondos([final String? query]) async {
    if (state.status == CondoStatus.searching) {
      return;
    }

    state = state.copyWith(status: CondoStatus.searching, clearMessages: true);

    final Either<Failure, List<CondominiumEntity>> result =
        await _searchCondosUseCase(SearchCondosParams(query: query));

    result.fold(
      (final failure) => state = state.copyWith(
        status: CondoStatus.error,
        errorMessage: failure.message,
      ),
      (final condos) =>
          state = state.copyWith(status: CondoStatus.initial, condos: condos),
    );
  }

  Future<void> getCondoById(final int id) async {
    if (state.status == CondoStatus.loading) {
      return;
    }

    _setLoadingState();

    final Either<Failure, CondominiumEntity> result =
        await _getCondoByIdUseCase(GetCondoByIdParams(id: id));

    result.fold(
      (final failure) => state = state.copyWith(
        status: CondoStatus.error,
        errorMessage: failure.message,
      ),
      (final condo) => state = state.copyWith(
        status: CondoStatus.initial,
        selectedCondo: condo,
      ),
    );
  }

  Future<bool> updateCondo(final int id, final CondominiumEntity condo) async {
    if (state.status == CondoStatus.loading) {
      return false;
    }

    _setLoadingState();

    final Either<Failure, CondominiumEntity> result = await _updateCondoUseCase(
      UpdateCondoParams(id: id, condo: condo),
    );

    return result.fold(
      (final failure) {
        state = state.copyWith(
          status: CondoStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (final updatedCondo) {
        final List<CondominiumEntity> updatedCondos = state.condos
            .map((final c) => c.id == id ? updatedCondo : c)
            .toList();
        state = state.copyWith(
          status: CondoStatus.success,
          condos: updatedCondos,
          selectedCondo: state.selectedCondo?.id == id
              ? updatedCondo
              : state.selectedCondo,
          successMessage: 'Condominio atualizado com sucesso',
        );
        return true;
      },
    );
  }

  Future<bool> deleteCondo(final int id) async {
    if (state.status == CondoStatus.loading) {
      return false;
    }

    final Either<Failure, void> result = await _deleteCondoUseCase(
      DeleteCondoParams(id: id),
    );

    return result.fold(
      (final failure) {
        state = state.copyWith(
          status: CondoStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (_) {
        final List<CondominiumEntity> updatedCondos = state.condos
            .where((final c) => c.id != id)
            .toList();
        state = state.copyWith(
          status: CondoStatus.success,
          condos: updatedCondos,
          successMessage: 'Condomínio deletado com sucesso',
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

  void clearSelectedCondo() {
    if (state.selectedCondo != null) {
      state = state.copyWith(clearSelectedCondo: true);
    }
  }

  void _setLoadingState() {
    state = state.copyWith(status: CondoStatus.loading, clearMessages: true);
  }
}
