import '../../data/models/employee_model.dart';

abstract class EmployeeRemoteDataSource {
  Future<EmployeeModel> createEmployee(
    final int condominiumId,
    final EmployeeModel employee,
  );
  Future<List<EmployeeModel>> getEmployees(final int condominiumId);
  Future<EmployeeModel> getEmployeeById(final int employeeId);
  Future<EmployeeModel> updateEmployee(
    final int employeeId,
    final EmployeeModel employee,
  );
  Future<void> deleteEmployee(final int employeeId);
}
