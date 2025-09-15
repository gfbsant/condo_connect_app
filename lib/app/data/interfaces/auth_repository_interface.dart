import 'package:condo_connect/app/data/models/auth_response.dart';
import 'package:condo_connect/app/data/models/user_model.dart';

abstract class AuthRepositoryInterface {
  Future<AuthResponse> login({required String email, required String password});
  Future<void> logout(String token);
  Future<AuthResponse> refreshToken(String refreshToken);
  Future<User> register(
      {required String name,
      required String email,
      required String password,
      required String cpf,
      String? phone});
}
