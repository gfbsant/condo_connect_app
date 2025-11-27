import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/employee_entity.dart';
import '../../domain/usecases/create_employee_usecase.dart';
import '../../domain/usecases/delete_employee_usecase.dart';
import '../../domain/usecases/get_employee_by_id_usecase.dart';
import '../../domain/usecases/get_employees_by_condo_usecase.dart';
import '../../domain/usecases/update_employee_usecase.dart';
import 'employee_providers.dart';
import 'employee_state.dart';

class EmployeeNotifier extends Notifier<EmployeeState> {
  late final CreateEmployeeUseCase _createEmployeeUseCase;
  late final GetEmployeesByCondoUseCase _getEmployeesByCondoUseCase;
  late final GetEmployeeByIdUseCase _getEmployeeByIdUseCase;
  late final UpdateEmployeeUseCase _updateEmployeeUseCase;
  late final DeleteEmployeeUseCase _deleteEmployeeUseCase;

  bool get _isLoading => state.status == .loading;

  bool get _isSearching => state.status == .searching;

  @override
  EmployeeState build() {
    _createEmployeeUseCase = ref.read(createEmployeeUseCaseProvider);
    _getEmployeesByCondoUseCase = ref.read(getEmployeesByCondoUseCaseProvider);
    _getEmployeeByIdUseCase = ref.read(getEmployeeByIdUseCaseProvider);
    _updateEmployeeUseCase = ref.read(updateEmployeeUseCaseProvider);
    _deleteEmployeeUseCase = ref.read(deleteEmployeeUseCaseProvider);
    return const EmployeeState.initial();
  }

  Future<bool> createEmployee(
    final int condominiumId,
    final EmployeeEntity employee,
  ) async {
    if (_isLoading) {
      return false;
    }

    _setLoadingState();

    final Either<Failure, EmployeeEntity> result = await _createEmployeeUseCase(
      CreateEmployeeParams(condominiumId: condominiumId, employee: employee),
    );

    return result.fold(
      (final failure) {
        state = state.copyWith(status: .error, errorMessage: failure.message);
        return false;
      },
      (final createdEmployee) {
        final updatedEmployees = List<EmployeeEntity>.of(state.employees)
          ..add(createdEmployee);
        state = state.copyWith(status: .success, employees: updatedEmployees);
        return true;
      },
    );
  }

  Future<void> getEmployeesByCondo(final int condominiumId) async {
    if (_isSearching) {
      return;
    }

    _setSearchingState();

    final Either<Failure, List<EmployeeEntity>> result =
        await _getEmployeesByCondoUseCase(
          GetEmployeesByCondoParams(condominiumId: condominiumId),
        );

    result.fold(
      (final failure) =>
          state = state.copyWith(status: .error, errorMessage: failure.message),
      (final employees) =>
          state = state.copyWith(status: .initial, employees: employees),
    );
  }

  Future<void> getEmployeeBydId(final int employeeId) async {
    if (_isLoading) {
      return;
    }

    _setLoadingState();

    final Either<Failure, EmployeeEntity> result =
        await _getEmployeeByIdUseCase(
          GetEmployeeByIdParams(employeeId: employeeId),
        );

    result.fold(
      (final failure) =>
          state = state.copyWith(status: .error, errorMessage: failure.message),
      (final employee) =>
          state = state.copyWith(selectedEmployee: employee, status: .initial),
    );
  }

  Future<bool> updateEmployee(
    final int id,
    final EmployeeEntity employee,
  ) async {
    if (_isLoading) {
      return false;
    }

    _setLoadingState();

    final Either<Failure, EmployeeEntity> result = await _updateEmployeeUseCase(
      UpdateEmployeeParams(id: id, employee: employee),
    );

    return result.fold(
      (final failure) {
        state = state.copyWith(status: .error, errorMessage: failure.message);
        return false;
      },
      (final updatedEmployee) {
        final List<EmployeeEntity> updatedEmployees = state.employees
            .map((final e) => e.id == id ? updatedEmployee : e)
            .toList();
        state = state.copyWith(
          status: .success,
          employees: updatedEmployees,
          selectedEmployee: state.selectedEmployee?.id == id
              ? updatedEmployee
              : state.selectedEmployee,
          successMessage: 'Funcionário atualizado com sucesso!',
        );
        return true;
      },
    );
  }

  Future<bool> deleteEmployee(final int id) async {
    if (_isLoading) {
      return false;
    }

    _setLoadingState();

    final Either<Failure, void> result = await _deleteEmployeeUseCase(
      DeleteEmployeeParams(id: id),
    );

    return result.fold(
      (final failure) {
        state = state.copyWith(status: .error, errorMessage: failure.message);
        return false;
      },
      (_) {
        final List<EmployeeEntity> updatedEmployees = List<EmployeeEntity>.of(
          state.employees,
        ).where((final e) => e.id == id).toList();
        state = state.copyWith(
          status: .success,
          employees: updatedEmployees,
          successMessage: 'Funcionario deletado com sucesso!',
          clearSelectedEmployee: state.selectedEmployee?.id == id,
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

  void clearSelectedEmployee() {
    if (state.selectedEmployee != null) {
      state = state.copyWith(clearSelectedEmployee: true);
    }
  }

  void _setLoadingState() {
    state = state.copyWith(status: .loading);
  }

  void _setSearchingState() {
    state = state.copyWith(status: .searching);
  }
}
