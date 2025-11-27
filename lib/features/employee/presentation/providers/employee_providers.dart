import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/entities/employee_entity.dart';
import '../../domain/usecases/create_employee_usecase.dart';
import '../../domain/usecases/delete_employee_usecase.dart';
import '../../domain/usecases/get_employee_by_id_usecase.dart';
import '../../domain/usecases/get_employees_by_condo_usecase.dart';
import '../../domain/usecases/update_employee_usecase.dart';
import 'employee_notifier.dart';
import 'employee_state.dart';

final Provider<CreateEmployeeUseCase> createEmployeeUseCaseProvider =
    Provider.autoDispose<CreateEmployeeUseCase>(
      (final ref) => getIt<CreateEmployeeUseCase>(),
    );

final Provider<GetEmployeesByCondoUseCase> getEmployeesByCondoUseCaseProvider =
    Provider.autoDispose<GetEmployeesByCondoUseCase>(
      (final ref) => getIt<GetEmployeesByCondoUseCase>(),
    );

final Provider<GetEmployeeByIdUseCase> getEmployeeByIdUseCaseProvider =
    Provider.autoDispose<GetEmployeeByIdUseCase>(
      (final ref) => getIt<GetEmployeeByIdUseCase>(),
    );

final Provider<UpdateEmployeeUseCase> updateEmployeeUseCaseProvider =
    Provider.autoDispose<UpdateEmployeeUseCase>(
      (final ref) => getIt<UpdateEmployeeUseCase>(),
    );

final Provider<DeleteEmployeeUseCase> deleteEmployeeUseCaseProvider =
    Provider.autoDispose<DeleteEmployeeUseCase>(
      (final ref) => getIt<DeleteEmployeeUseCase>(),
    );

// Main notifier
final NotifierProvider<EmployeeNotifier, EmployeeState>
employeeNotifierProvider =
    NotifierProvider.autoDispose<EmployeeNotifier, EmployeeState>(
      EmployeeNotifier.new,
    );

// Helpers
final Provider<EmployeeNotifier> employeeNotifierAccessor =
    Provider.autoDispose<EmployeeNotifier>(
      (final ref) => ref.watch(employeeNotifierProvider.notifier),
    );

final Provider<List<EmployeeEntity>> employeesProvider =
    Provider.autoDispose<List<EmployeeEntity>>(
      (final ref) => ref.watch(employeeNotifierProvider).employees,
    );

final Provider<EmployeeEntity?> selectedEmployeeProvider =
    Provider.autoDispose<EmployeeEntity?>(
      (final ref) => ref.watch(employeeNotifierProvider).selectedEmployee,
    );

final Provider<bool> isLoadingProvider = Provider.autoDispose<bool>(
  (final ref) =>
      ref.watch(employeeNotifierProvider).status == EmployeeStatus.loading,
);

final Provider<String?> errorMessageProvider = Provider.autoDispose<String?>(
  (final ref) => ref.watch(employeeNotifierProvider).errorMessage,
);

final Provider<String?> successMessageProvider = Provider.autoDispose<String?>(
  (final ref) => ref.watch(employeeNotifierProvider).successMessage,
);
