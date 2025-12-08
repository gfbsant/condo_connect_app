import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/errors/failures.dart';
import '../../domain/entities/reservation_entity.dart';
import '../../domain/usecases/create_reservation_usecase.dart';
import '../../domain/usecases/delete_reservation_usecase.dart';
import '../../domain/usecases/get_reservations_by_apartment_usecase.dart';
import '../../domain/usecases/get_reservations_by_facility_usecase.dart';
import 'reservation_providers.dart';
import 'reservation_state.dart';

class ReservationNotifier extends Notifier<ReservationState> {
  late final CreateReservationUseCase _createReservationUseCase;
  late final GetReservationsByApartmentUseCase
  _getReservationsByApartmentUseCase;
  late final GetReservationsByFacilityUseCase _getReservationsByFacilityUseCase;
  late final DeleteReservationUseCase _deleteReservationUseCase;

  bool get _isLoading => state.status == .loading;

  bool get _isSearching => state.status == .searching;

  @override
  ReservationState build() {
    _createReservationUseCase = ref.read(createReservationUseCaseProvider);
    _getReservationsByApartmentUseCase = ref.read(
      getReservationsByApartmentUseCaseProvider,
    );
    _getReservationsByFacilityUseCase = ref.read(
      getReservationsByFacilityUseCaseProvider,
    );
    _deleteReservationUseCase = ref.read(deleteReservationUseCaseProvider);
    return const ReservationState.initial();
  }

  Future<bool> createReservation(
    final int facilityId,
    final ReservationEntity reservation,
  ) async {
    if (_isLoading) {
      return false;
    }

    _setLoadingState();

    final Either<Failure, ReservationEntity> result =
        await _createReservationUseCase(
          CreateReservationParams(
            facilityId: facilityId,
            reservation: reservation,
          ),
        );

    return result.fold(
      (final failure) {
        state = state.copyWith(status: .error, errorMessage: failure.message);
        return false;
      },
      (final createdReservation) {
        final updatedReservations = List<ReservationEntity>.of(
          state.reservations,
        )..add(createdReservation);
        state = state.copyWith(
          reservations: updatedReservations,
          status: .suceess,
          successMessage: 'Reserva criada com sucesso!',
        );
        return true;
      },
    );
  }

  Future<void> getReservationsByApartment(final int apartmentId) async {
    if (_isSearching) {
      return;
    }

    _setSearchingState();

    final Either<Failure, List<ReservationEntity>> result =
        await _getReservationsByApartmentUseCase(
          GetReservationsByApartmentParams(apartmentId: apartmentId),
        );

    result.fold(
      (final failure) =>
          state = state.copyWith(status: .error, errorMessage: failure.message),
      (final reservations) =>
          state = state.copyWith(reservations: reservations, status: .initial),
    );
  }

  Future<void> getReservationsByFacility(final int facilityId) async {
    if (_isSearching) {
      return;
    }

    _setSearchingState();

    final Either<Failure, List<ReservationEntity>> result =
        await _getReservationsByFacilityUseCase(
          GetReservationsByFacilityParams(facilityId: facilityId),
        );

    result.fold(
      (final failure) =>
          state = state.copyWith(status: .error, errorMessage: failure.message),
      (final reservations) =>
          state = state.copyWith(reservations: reservations, status: .initial),
    );
  }

  Future<bool> deleteReservation(final int reservationId) async {
    if (_isLoading) {
      return false;
    }

    _setLoadingState();

    final Either<Failure, void> result = await _deleteReservationUseCase(
      DeleteReservationParams(reservationId: reservationId),
    );

    return result.fold(
      (final failure) {
        state = state.copyWith(status: .error, errorMessage: failure.message);
        return false;
      },
      (_) {
        final List<ReservationEntity> updatedReservations = state.reservations
            .where((final r) => r.id != reservationId)
            .toList();
        state = state.copyWith(
          reservations: updatedReservations,
          successMessage: 'Reserva deletada com sucesso',
          status: .suceess,
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

  void _setLoadingState() {
    if (state.status != ReservationStatus.loading) {
      state = state.copyWith(status: .loading);
    }
  }

  void _setSearchingState() {
    if (state.status != ReservationStatus.searching) {
      state = state.copyWith(status: .searching);
    }
  }
}
