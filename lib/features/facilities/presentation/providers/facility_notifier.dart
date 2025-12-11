import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/errors/failures.dart';
import '../../domain/entities/facility_entity.dart';
import '../../domain/usecases/create_facility_usecase.dart';
import '../../domain/usecases/delete_facility_usecase.dart';
import '../../domain/usecases/get_facilities_by_condo_usecase.dart';
import '../../domain/usecases/get_facility_by_id_usecase.dart';
import '../../domain/usecases/update_facility_usecase.dart';
import 'facility_providers.dart';
import 'facility_state.dart';

class FacilityNotifier extends Notifier<FacilityState> {
  late final CreateFacilityUseCase _createFacilityUseCase;
  late final GetFacilitiesByCondoUseCase _getFacilitiesByCondoUseCase;
  late final GetFacilityByIdUseCase _getFacilityByIdUseCase;
  late final UpdateFacilityUseCase _updateFacilityUseCase;
  late final DeleteFacilityUseCase _deleteFacilityUseCase;

  bool get _isLoading => state.status == .loading;

  @override
  FacilityState build() {
    _createFacilityUseCase = ref.read(createFacilityUseCaseProvider);
    _getFacilitiesByCondoUseCase = ref.read(
      getFacilitiesByCondoUseCaseProvider,
    );
    _getFacilityByIdUseCase = ref.read(getFacilityByIdUseCaseProvider);
    _updateFacilityUseCase = ref.read(updateFacilityUseCaseProvider);
    _deleteFacilityUseCase = ref.read(deleteFacilityUseCaseProvider);
    return const FacilityState.initial();
  }

  Future<bool> createFacility(
    final int condominiumId,
    final FacilityEntity facility,
  ) async {
    if (_isLoading) {
      return false;
    }

    _setLoadingState();

    final Either<Failure, FacilityEntity> result = await _createFacilityUseCase(
      CreateFacilityParams(condominiumId: condominiumId, facility: facility),
    );

    return result.fold(
      (final failure) {
        state = state.copyWith(status: .error, errorMessage: failure.message);
        return false;
      },
      (final createdFacility) {
        final updatedItems = List<FacilityEntity>.of(state.facilities)
          ..add(createdFacility);
        state = state.copyWith(
          facilities: updatedItems,
          status: .success,
          successMessage: 'Área comum criada com sucesso!',
        );
        return true;
      },
    );
  }

  Future<void> getFacilitiesByCondo(final int condominiumId) async {
    if (state.status == .searching) {
      return;
    }

    state = state.copyWith(status: .searching);

    final Either<Failure, List<FacilityEntity>> result =
        await _getFacilitiesByCondoUseCase(
          GetFacilitiesByCondoParams(condominiumId: condominiumId),
        );

    result.fold(
      (final failure) {
        state = state.copyWith(status: .error, errorMessage: failure.message);
      },
      (final facilities) {
        state = state.copyWith(facilities: facilities, status: .initial);
      },
    );
  }

  Future<void> getFacilityById(final int facilityId) async {
    if (_isLoading) {
      return;
    }

    _setLoadingState();

    final Either<Failure, FacilityEntity> result =
        await _getFacilityByIdUseCase(
          GetFacilityByIdParams(facilityId: facilityId),
        );

    result.fold(
      (final failure) {
        state = state.copyWith(status: .error, errorMessage: failure.message);
      },
      (final facility) {
        state = state.copyWith(selectedFacility: facility, status: .initial);
      },
    );
  }

  Future<bool> updateFacility(
    final int id,
    final FacilityEntity facility,
  ) async {
    if (_isLoading) {
      return false;
    }

    _setLoadingState();

    final Either<Failure, FacilityEntity> result = await _updateFacilityUseCase(
      UpdateFacilityParams(id: id, facility: facility),
    );

    return result.fold(
      (final failure) {
        state = state.copyWith(status: .error, errorMessage: failure.message);
        return false;
      },
      (final updatedFacility) {
        final List<FacilityEntity> updatedFacilities = state.facilities
            .map((final f) => f.id == id ? updatedFacility : f)
            .toList();
        state = state.copyWith(
          facilities: updatedFacilities,
          selectedFacility: state.selectedFacility?.id == id
              ? updatedFacility
              : state.selectedFacility,
          status: .success,
          successMessage: 'Área comum atualizada com sucesso',
        );
        return true;
      },
    );
  }

  Future<bool> deleteFacility(final int facilityId) async {
    if (_isLoading) {
      return false;
    }

    _setLoadingState();

    final Either<Failure, void> result = await _deleteFacilityUseCase(
      DeleteFacilityParams(facilityId: facilityId),
    );

    return result.fold(
      (final failure) {
        state = state.copyWith(status: .error, errorMessage: failure.message);
        return false;
      },
      (_) {
        final List<FacilityEntity> updatedFacilities = state.facilities
            .where((final f) => f.id != facilityId)
            .toList();
        state = state.copyWith(
          facilities: updatedFacilities,
          clearSelectedFacility: state.selectedFacility?.id == facilityId,
          status: .success,
          successMessage: 'Área comum deletada com sucesso',
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

  void clearSelectedFacility() {
    if (state.selectedFacility != null) {
      state = state.copyWith(clearSelectedFacility: true);
    }
  }

  void _setLoadingState() {
    if (state.status != FacilityStatus.loading) {
      state = state.copyWith(status: .loading);
    }
  }
}
