import 'package:equatable/equatable.dart';

import '../../domain/entities/employee_entity.dart';

enum EmployeeStatus { initial, loading, searching, success, error }

class EmployeeState extends Equatable {
  const EmployeeState({
    required this.status,
    this.employees = const [],
    this.selectedEmployee,
    this.errorMessage,
    this.successMessage,
  });

  const EmployeeState.initial()
    : status = .initial,
      employees = const [],
      selectedEmployee = null,
      errorMessage = null,
      successMessage = null;

  final EmployeeStatus status;
  final List<EmployeeEntity> employees;
  final EmployeeEntity? selectedEmployee;
  final String? errorMessage;
  final String? successMessage;

  EmployeeState copyWith({
    final EmployeeStatus? status,
    final List<EmployeeEntity>? employees,
    final EmployeeEntity? selectedEmployee,
    final String? errorMessage,
    final String? successMessage,
    final bool clearSelectedEmployee = false,
    final bool clearMessages = false,
  }) => EmployeeState(
    status: status ?? this.status,
    employees: employees ?? this.employees,
    selectedEmployee: clearSelectedEmployee
        ? null
        : selectedEmployee ?? this.selectedEmployee,
    errorMessage: clearMessages ? null : errorMessage ?? this.errorMessage,
    successMessage: clearMessages
        ? null
        : successMessage ?? this.successMessage,
  );

  @override
  List<Object?> get props => [
    status,
    employees,
    selectedEmployee,
    errorMessage,
    successMessage,
  ];
}
