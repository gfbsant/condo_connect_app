import '../../data/models/employee_model.dart';

abstract class EmployeeRemoteDataSource {
  Future<EmployeeModel> createEmployee(
    final int condominiumId,
    final EmployeeModel employee,
  );
  Future<List<EmployeeModel>> getEmployeesByCondo(final int condominiumId);
  Future<EmployeeModel> getEmployeeById(final int employeeId);
  Future<EmployeeModel> updateEmployee(
    final int id,
    final EmployeeModel employee,
  );
  Future<void> deleteEmployee(final int employeeId);
}
