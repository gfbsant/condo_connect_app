import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/entities/condominium_entity.dart';
import '../../domain/usecases/create_condo_usecase.dart';
import '../../domain/usecases/delete_condo_usecase.dart';
import '../../domain/usecases/get_condo_by_id_usecase.dart';
import '../../domain/usecases/search_condos_usecase.dart';
import '../../domain/usecases/update_condo_usecase.dart';
import 'condo_notifier.dart';
import 'condo_state.dart';

final Provider<CreateCondoUseCase> createCondoUseCaseProvider =
    Provider.autoDispose<CreateCondoUseCase>(
      (final ref) => getIt<CreateCondoUseCase>(),
    );

final Provider<SearchCondosUseCase> searchCondosUseCaseProvider =
    Provider.autoDispose<SearchCondosUseCase>(
      (final ref) => getIt<SearchCondosUseCase>(),
    );

final Provider<GetCondoByIdUseCase> getCondoByIdUseCaseProvider =
    Provider.autoDispose<GetCondoByIdUseCase>(
      (final ref) => getIt<GetCondoByIdUseCase>(),
    );

final Provider<UpdateCondoUseCase> updateCondoUseCaseProvider =
    Provider.autoDispose<UpdateCondoUseCase>(
      (final ref) => getIt<UpdateCondoUseCase>(),
    );

final Provider<DeleteCondoUseCase> deleteCondoUseCaseProvider =
    Provider.autoDispose<DeleteCondoUseCase>(
      (final ref) => getIt<DeleteCondoUseCase>(),
    );

// Main Notifier
final NotifierProvider<CondoNotifier, CondoState> condoNotifierProvider =
    NotifierProvider.autoDispose<CondoNotifier, CondoState>(CondoNotifier.new);

// Helpers
final Provider<CondoNotifier> condoNotifierAccessor =
    Provider.autoDispose<CondoNotifier>(
      (final ref) => ref.watch(condoNotifierProvider.notifier),
    );

final Provider<List<CondominiumEntity>> condosProvider =
    Provider.autoDispose<List<CondominiumEntity>>(
      (final ref) => ref.watch(condoNotifierProvider).condos,
    );

final Provider<CondominiumEntity?> selectedCondoProvider =
    Provider.autoDispose<CondominiumEntity?>(
      (final ref) => ref.watch(condoNotifierProvider).selectedCondo,
    );

final Provider<bool> isLoadingProvider = Provider.autoDispose<bool>(
  (final ref) => ref.watch(condoNotifierProvider).status == CondoStatus.loading,
);

final Provider<bool> isSearchingProvider = Provider.autoDispose<bool>(
  (final ref) =>
      ref.watch(condoNotifierProvider).status == CondoStatus.searching,
);
