import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/entities/apartment_entity.dart';
import '../../domain/usecases/approve_apartment_usecase.dart';
import '../../domain/usecases/create_apartment_usecase.dart';
import '../../domain/usecases/delete_apartment_usecase.dart';
import '../../domain/usecases/get_apartment_by_id_usecase.dart';
import '../../domain/usecases/get_apartments_by_condo_usecase.dart';
import '../../domain/usecases/update_apartment_usecase.dart';
import 'apartment_notifier.dart';
import 'apartment_state.dart';

// Use cases
final Provider<CreateApartmentUseCase> createApartmentUseCaseProvider =
    Provider.autoDispose<CreateApartmentUseCase>(
      (final ref) => getIt<CreateApartmentUseCase>(),
    );

final Provider<GetApartmentsByCondoUseCase>
getApartmentsByCondoUseCaseProvider =
    Provider.autoDispose<GetApartmentsByCondoUseCase>(
      (final ref) => getIt<GetApartmentsByCondoUseCase>(),
    );

final Provider<GetApartmentByIdUseCase> getApartmentByIdUseCaseProvider =
    Provider.autoDispose<GetApartmentByIdUseCase>(
      (final ref) => getIt<GetApartmentByIdUseCase>(),
    );

final Provider<UpdateApartmentUseCase> updateApartmentUseCaseProvider =
    Provider.autoDispose<UpdateApartmentUseCase>(
      (final ref) => getIt<UpdateApartmentUseCase>(),
    );

final Provider<ApproveApartmentUseCase> approveApartmentUseCaseProvider =
    Provider.autoDispose<ApproveApartmentUseCase>(
      (final ref) => getIt<ApproveApartmentUseCase>(),
    );

final Provider<DeleteApartmentUseCase> deleteApartmentUseCaseProvider =
    Provider.autoDispose<DeleteApartmentUseCase>(
      (final ref) => getIt<DeleteApartmentUseCase>(),
    );

// Main notifier
final NotifierProvider<ApartmentNotifier, ApartmentState>
apartmentNotifierProvider =
    NotifierProvider.autoDispose<ApartmentNotifier, ApartmentState>(
      ApartmentNotifier.new,
    );

// Helpers
final Provider<ApartmentNotifier> apartmentNotifierAccessor =
    Provider.autoDispose<ApartmentNotifier>(
      (final ref) => ref.watch(apartmentNotifierProvider.notifier),
    );

final Provider<List<ApartmentEntity>> apartmentsProvider =
    Provider.autoDispose<List<ApartmentEntity>>(
      (final ref) => ref.watch(apartmentNotifierProvider).apartments,
    );

final Provider<ApartmentEntity?> selectedApartmentProvider =
    Provider.autoDispose<ApartmentEntity?>(
      (final ref) => ref.watch(apartmentNotifierProvider).selectedApartment,
    );

final Provider<bool> isLoadingProvider = Provider.autoDispose<bool>(
  (final ref) =>
      ref.watch(apartmentNotifierProvider).status == ApartmentStatus.loading,
);
