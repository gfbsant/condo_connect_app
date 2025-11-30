import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/usecases/create_resident_usecase.dart';
import '../../domain/usecases/delete_resident_usecase.dart';
import '../../domain/usecases/get_resident_by_id_usecase.dart';
import '../../domain/usecases/get_residents_by_apartment_usecase.dart';
import '../../domain/usecases/update_resident_usecase.dart';
import 'resident_notifier.dart';
import 'resident_state.dart';

// Use Cases
final Provider<CreateResidentUseCase> createResidentUseCaseProvider =
    Provider.autoDispose<CreateResidentUseCase>(
      (final ref) => getIt<CreateResidentUseCase>(),
    );

final Provider<GetResidentsByApartmentUseCase>
getResidentsByApartmentUseCaseProvider =
    Provider.autoDispose<GetResidentsByApartmentUseCase>(
      (final ref) => getIt<GetResidentsByApartmentUseCase>(),
    );

final Provider<GetResidentByIdUseCase> getResidentByIdUseCaseProvider =
    Provider.autoDispose<GetResidentByIdUseCase>(
      (final ref) => getIt<GetResidentByIdUseCase>(),
    );

final Provider<UpdateResidentUseCase> updateResidentUseCaseProvider =
    Provider.autoDispose<UpdateResidentUseCase>(
      (final ref) => getIt<UpdateResidentUseCase>(),
    );

final Provider<DeleteResidentUseCase> deleteResidentUseCase =
    Provider.autoDispose<DeleteResidentUseCase>(
      (final ref) => getIt<DeleteResidentUseCase>(),
    );

// Main notifier
final NotifierProvider<ResidentNotifier, ResidentState>
residentNotifierProvider =
    NotifierProvider.autoDispose<ResidentNotifier, ResidentState>(
      ResidentNotifier.new,
    );

// Helpers
final Provider<ResidentNotifier> residentNotifierAccessor =
    Provider.autoDispose<ResidentNotifier>(
      (final ref) => ref.watch(residentNotifierProvider.notifier),
    );

final Provider<bool> isLoadingProvider = Provider.autoDispose<bool>(
  (final ref) => ref.watch(residentNotifierProvider).status == .loading,
);
