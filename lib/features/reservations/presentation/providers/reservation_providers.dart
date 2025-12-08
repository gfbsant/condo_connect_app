import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/usecases/create_reservation_usecase.dart';
import '../../domain/usecases/delete_reservation_usecase.dart';
import '../../domain/usecases/get_reservations_by_apartment_usecase.dart';
import '../../domain/usecases/get_reservations_by_facility_usecase.dart';
import 'reservation_notifier.dart';
import 'reservation_state.dart';

// Use Cases
final Provider<CreateReservationUseCase> createReservationUseCaseProvider =
    Provider.autoDispose<CreateReservationUseCase>(
      (_) => getIt<CreateReservationUseCase>(),
    );

final Provider<GetReservationsByApartmentUseCase>
getReservationsByApartmentUseCaseProvider =
    Provider.autoDispose<GetReservationsByApartmentUseCase>(
      (_) => getIt<GetReservationsByApartmentUseCase>(),
    );

final Provider<GetReservationsByFacilityUseCase>
getReservationsByFacilityUseCaseProvider =
    Provider.autoDispose<GetReservationsByFacilityUseCase>(
      (_) => getIt<GetReservationsByFacilityUseCase>(),
    );

final Provider<DeleteReservationUseCase> deleteReservationUseCaseProvider =
    Provider.autoDispose<DeleteReservationUseCase>(
      (_) => getIt<DeleteReservationUseCase>(),
    );

// Main Notifier
final NotifierProvider<ReservationNotifier, ReservationState>
reservationNotifierProvider =
    NotifierProvider.autoDispose<ReservationNotifier, ReservationState>(
      ReservationNotifier.new,
    );

// Helpers
final Provider<ReservationNotifier> reservationNotifierAccessor =
    Provider.autoDispose<ReservationNotifier>(
      (final ref) => ref.watch(reservationNotifierProvider.notifier),
    );

final Provider<bool> isLoadingProvider = Provider.autoDispose<bool>(
  (final ref) => ref.watch(reservationNotifierProvider).status == .loading,
);
