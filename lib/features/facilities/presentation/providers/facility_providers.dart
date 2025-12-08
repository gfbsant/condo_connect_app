// Use cases
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/usecases/create_facility_usecase.dart';
import '../../domain/usecases/delete_facility_usecase.dart';
import '../../domain/usecases/get_facilities_by_condo_usecase.dart';
import '../../domain/usecases/get_facility_by_id_usecase.dart';
import '../../domain/usecases/update_facility_usecase.dart';
import 'facility_notifier.dart';
import 'facility_state.dart';

Provider<CreateFacilityUseCase> createFacilityUseCaseProvider =
    Provider.autoDispose<CreateFacilityUseCase>(
      (final ref) => getIt<CreateFacilityUseCase>(),
    );

Provider<GetFacilitiesByCondoUseCase> getFacilitiesByCondoUseCaseProvider =
    Provider.autoDispose<GetFacilitiesByCondoUseCase>(
      (final ref) => getIt<GetFacilitiesByCondoUseCase>(),
    );

Provider<GetFacilityByIdUseCase> getFacilityByIdUseCaseProvider =
    Provider.autoDispose<GetFacilityByIdUseCase>(
      (final ref) => getIt<GetFacilityByIdUseCase>(),
    );

Provider<UpdateFacilityUseCase> updateFacilityUseCaseProvider =
    Provider.autoDispose<UpdateFacilityUseCase>(
      (final ref) => getIt<UpdateFacilityUseCase>(),
    );

Provider<DeleteFacilityUseCase> deleteFacilityUseCaseProvider =
    Provider.autoDispose<DeleteFacilityUseCase>(
      (final ref) => getIt<DeleteFacilityUseCase>(),
    );

// Main Notifier
final NotifierProvider<FacilityNotifier, FacilityState>
facilityNotifierProvider =
    NotifierProvider.autoDispose<FacilityNotifier, FacilityState>(
      FacilityNotifier.new,
    );

// Helpers
final Provider<FacilityNotifier> facilityNotifierAccessor =
    Provider.autoDispose<FacilityNotifier>(
      (final ref) => ref.watch(facilityNotifierProvider.notifier),
    );

final Provider<bool> isLoadingProvider = Provider.autoDispose<bool>(
  (final ref) => ref.watch(facilityNotifierProvider).status == .loading,
);
