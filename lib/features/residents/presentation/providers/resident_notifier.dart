import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/errors/failures.dart';
import '../../domain/entities/resident_entity.dart';
import '../../domain/usecases/create_resident_usecase.dart';
import '../../domain/usecases/delete_resident_usecase.dart';
import '../../domain/usecases/get_resident_by_id_usecase.dart';
import '../../domain/usecases/get_residents_by_apartment_usecase.dart';
import '../../domain/usecases/update_resident_usecase.dart';
import 'resident_provider.dart';
import 'resident_state.dart';

class ResidentNotifier extends Notifier<ResidentState> {
  late final CreateResidentUseCase _createResidentUseCase;
  late final GetResidentsByApartmentUseCase _getResidentsByApartmentUseCase;
  late final GetResidentByIdUseCase _getResidentByIdUseCase;
  late final UpdateResidentUseCase _updateResidentUseCase;
  late final DeleteResidentUseCase _deleteResidentUseCase;

  bool get _isLoading => state.status == .loading;

  @override
  ResidentState build() {
    _createResidentUseCase = ref.read(createResidentUseCaseProvider);
    _getResidentsByApartmentUseCase = ref.read(
      getResidentsByApartmentUseCaseProvider,
    );
    _getResidentByIdUseCase = ref.read(getResidentByIdUseCaseProvider);
    _updateResidentUseCase = ref.read(updateResidentUseCaseProvider);
    _deleteResidentUseCase = ref.read(deleteResidentUseCase);
    return const ResidentState.initial();
  }

  Future<bool> createResident(final int apartmentId, final int userId) async {
    if (_isLoading) {
      return false;
    }

    _setLoadingState();

    final Either<Failure, ResidentEntity> result = await _createResidentUseCase(
      CreateResidentParams(apartmentId: apartmentId, userId: userId),
    );

    return result.fold(
      (final failure) {
        state = state.copyWith(status: .error, errorMessage: failure.message);
        return false;
      },
      (final createdResident) {
        final updatedResidents = List<ResidentEntity>.of(state.residents)
          ..add(createdResident);
        state = state.copyWith(
          residents: updatedResidents,
          selectedResident: state.selectedResident?.id == createdResident.id
              ? createdResident
              : state.selectedResident,
          status: .success,
          successMessage: 'Morador criado com sucesso',
        );
        return true;
      },
    );
  }

  Future<void> getResidentsByApartment(final int apartmentId) async {
    if (state.status == .searching) {
      return;
    }

    state = state.copyWith(status: .searching);

    final Either<Failure, List<ResidentEntity>> result =
        await _getResidentsByApartmentUseCase(
          GetResidentsByApartmentParams(apartmentId: apartmentId),
        );

    result.fold(
      (final failure) => state = state.copyWith(status: .error),
      (final residents) =>
          state.copyWith(residents: residents, status: .initial),
    );
  }

  Future<void> getResidentById(
    final int apartmentId,
    final int residentId,
  ) async {
    if (_isLoading) {
      return;
    }

    _setLoadingState();

    final Either<Failure, ResidentEntity> result =
        await _getResidentByIdUseCase(
          GetResidentByIdParams(
            apartmentId: apartmentId,
            residentId: residentId,
          ),
        );

    result.fold(
      (final failure) =>
          state = state.copyWith(status: .error, errorMessage: failure.message),
      (final resident) =>
          state = state.copyWith(selectedResident: resident, status: .initial),
    );
  }

  Future<bool> updateResident(
    final int apartmentId,
    final int residentId,
    final ResidentEntity resident,
  ) async {
    if (_isLoading) {
      return false;
    }

    _setLoadingState();

    final Either<Failure, ResidentEntity> result = await _updateResidentUseCase(
      UpdateResidentParams(
        apartmentId: apartmentId,
        residentId: residentId,
        resident: resident,
      ),
    );

    return result.fold(
      (final failure) {
        state = state.copyWith(status: .error, errorMessage: failure.message);
        return false;
      },
      (final updatedResident) {
        final List<ResidentEntity> updatedResidents = state.residents
            .map((final r) => r.id == residentId ? updatedResident : r)
            .toList();
        state = state.copyWith(
          status: .success,
          residents: updatedResidents,
          selectedResident: state.selectedResident?.id == residentId
              ? updatedResident
              : state.selectedResident,
          successMessage: 'Morador atualizado com sucesso!',
        );
        return true;
      },
    );
  }

  Future<bool> deleteResident(
    final int apartmentId,
    final int residentId,
  ) async {
    if (_isLoading) {
      return false;
    }

    _setLoadingState();

    final Either<Failure, void> result = await _deleteResidentUseCase(
      DeleteResidentParams(apartmentId: apartmentId, residentId: residentId),
    );

    return result.fold(
      (final failure) {
        state = state.copyWith(status: .error, errorMessage: failure.message);
        return false;
      },
      (_) {
        final List<ResidentEntity> updatedResidents = state.residents
            .where((final r) => r.id != residentId)
            .toList();
        state = state.copyWith(
          status: .success,
          clearSelectedResident: state.selectedResident?.id == residentId,
          residents: updatedResidents,
          successMessage: 'Morador deletado com sucesso!',
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

  void clearSelectedResident() {
    if (state.selectedResident != null) {
      state = state.copyWith(clearSelectedResident: true);
    }
  }

  void _setLoadingState() {
    if (state.status != ResidentStatus.loading) {
      state = state.copyWith(status: .loading);
    }
  }
}
