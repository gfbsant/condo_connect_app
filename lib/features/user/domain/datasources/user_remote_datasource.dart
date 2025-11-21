import '../../data/models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUser(final int userId);
  Future<UserModel> updateUser(final int userId, final UserModel user);
}
