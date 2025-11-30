import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/apartment_entity.dart';
import '../../domain/usecases/approve_apartment_usecase.dart';
import '../../domain/usecases/create_apartment_usecase.dart';
import '../../domain/usecases/delete_apartment_usecase.dart';
import '../../domain/usecases/get_apartment_by_id_usecase.dart';
import '../../domain/usecases/get_apartments_by_condo_usecase.dart';
import '../../domain/usecases/update_apartment_usecase.dart';
import 'apartment_providers.dart';
import 'apartment_state.dart';

class ApartmentNotifier extends Notifier<ApartmentState> {
  late final CreateApartmentUseCase _createApartmentUseCase;
  late final GetApartmentsByCondoUseCase _getApartmentsByCondoUseCase;
  late final GetApartmentByIdUseCase _getApartmentByIdUseCase;
  late final UpdateApartmentUseCase _updateApartmentUseCase;
  late final ApproveApartmentUseCase _approveApartmentUseCase;
  late final DeleteApartmentUseCase _deleteApartmentUseCase;

  bool get _isLoading => state.status == .loading;

  @override
  ApartmentState build() {
    _createApartmentUseCase = ref.read(createApartmentUseCaseProvider);
    _getApartmentsByCondoUseCase = ref.read(
      getApartmentsByCondoUseCaseProvider,
    );
    _getApartmentByIdUseCase = ref.read(getApartmentByIdUseCaseProvider);
    _updateApartmentUseCase = ref.read(updateApartmentUseCaseProvider);
    _approveApartmentUseCase = ref.read(approveApartmentUseCaseProvider);
    _deleteApartmentUseCase = ref.read(deleteApartmentUseCaseProvider);
    return const ApartmentState.initial();
  }

  Future<bool> createApartment(final ApartmentEntity apartment) async {
    if (_isLoading) {
      return false;
    }

    _setLoadingState();

    final Either<Failure, ApartmentEntity> result =
        await _createApartmentUseCase(
          CreateApartmentParams(apartment: apartment),
        );

    return result.fold(
      (final failure) {
        state = state.copyWith(status: .error, errorMessage: failure.message);
        return false;
      },
      (final createdApartment) {
        final updatedApartments = List<ApartmentEntity>.of(state.apartments)
          ..add(createdApartment);
        state = state.copyWith(
          status: .success,
          apartments: updatedApartments,
          successMessage: 'Apartamento Criado com Sucesso!',
        );
        return true;
      },
    );
  }

  Future<void> getApartmentsByCondo(final int condominiumId) async {
    if (state.status == .searching) {
      return;
    }

    state = state.copyWith(status: .searching);

    final Either<Failure, List<ApartmentEntity>> result =
        await _getApartmentsByCondoUseCase(
          GetApartmentsByCondoParams(condominiumId: condominiumId),
        );

    result.fold(
      (final failure) =>
          state = state.copyWith(status: .error, errorMessage: failure.message),
      (final apartments) =>
          state = state.copyWith(apartments: apartments, status: .initial),
    );
  }

  Future<void> getApartmentById(final int apartmentId) async {
    if (_isLoading) {
      return;
    }

    _setLoadingState();

    final Either<Failure, ApartmentEntity> result =
        await _getApartmentByIdUseCase(
          GetApartmentByIdParams(apartmentId: apartmentId),
        );

    result.fold(
      (final failure) =>
          state = state.copyWith(status: .error, errorMessage: failure.message),
      (final apartment) => state = state.copyWith(
        selectedApartment: apartment,
        status: .initial,
      ),
    );
  }

  Future<bool> updateApartment(
    final int id,
    final ApartmentEntity apartment,
  ) async {
    if (_isLoading) {
      return false;
    }

    _setLoadingState();

    final Either<Failure, ApartmentEntity> result =
        await _updateApartmentUseCase(
          UpdateApartmentParams(id: id, apartment: apartment),
        );

    return result.fold(
      (final failure) {
        state = state.copyWith(status: .error, errorMessage: failure.message);
        return false;
      },
      (final updatedApartment) {
        final List<ApartmentEntity> updatedApartments = state.apartments
            .map((final ap) => ap.id == id ? updatedApartment : ap)
            .toList();
        state = state.copyWith(
          apartments: updatedApartments,
          status: .success,
          selectedApartment: state.selectedApartment?.id == id
              ? updatedApartment
              : state.selectedApartment,
          successMessage: 'Apartamento atualizado com sucesso!',
        );
        return true;
      },
    );
  }

  Future<bool> approveApartment(final int apartmentId) async {
    if (state.status == .approving) {
      return false;
    }

    state = state.copyWith(status: .approving);

    final Either<Failure, ApartmentEntity> result =
        await _approveApartmentUseCase(
          ApproveApartmentParams(apartmentId: apartmentId),
        );

    return result.fold(
      (final failure) {
        state = state.copyWith(status: .error, errorMessage: failure.message);
        return false;
      },
      (final approvedApartment) {
        final List<ApartmentEntity> updatedApartments = state.apartments
            .map((final ap) => ap.id == apartmentId ? approvedApartment : ap)
            .toList();
        state = state.copyWith(
          status: .success,
          apartments: updatedApartments,
          selectedApartment: state.selectedApartment?.id == apartmentId
              ? approvedApartment
              : state.selectedApartment,
          successMessage: 'Apartamento aprovado com sucesso!',
        );
        return true;
      },
    );
  }

  Future<bool> deleteApartment(final int apartmentId) async {
    if (_isLoading) {
      return false;
    }

    _setLoadingState();

    final Either<Failure, void> result = await _deleteApartmentUseCase(
      DeleteApartmentParams(apartmentId: apartmentId),
    );

    return result.fold(
      (final failure) {
        state = state.copyWith(status: .error, errorMessage: failure.message);
        return false;
      },
      (_) {
        final List<ApartmentEntity> updatedApartments = state.apartments
            .where((final ap) => ap.id != apartmentId)
            .toList();
        state = state.copyWith(
          status: .success,
          apartments: updatedApartments,
          clearSelectedApartment: state.selectedApartment?.id == apartmentId,
          successMessage: 'Apartamento deletado com sucesso!',
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

  void clearSelectedApartment() {
    if (state.selectedApartment != null) {
      state = state.copyWith(clearSelectedApartment: true);
    }
  }

  void _setLoadingState() {
    if (state.status != ApartmentStatus.loading) {
      state = state.copyWith(status: .loading);
    }
  }
}
