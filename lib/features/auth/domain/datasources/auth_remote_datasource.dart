import '../../../user/data/models/user_model.dart';
import '../../data/models/permission_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(final String email, final String password);
  Future<List<PermissionModel>> getUserPermissions();
  Future<void> logout();
  Future<UserModel> register({required final UserModel user});
  Future<void> requestPasswordReset(final String email);
  Future<void> resetPassword(final String token, final String newPassword);
}
