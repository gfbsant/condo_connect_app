import '../models/auth_response.dart';
import '../models/user_model.dart';

abstract class AuthRepositoryInterface {
  Future<AuthResponse> login(final String email, final String password);
  Future<void> logout(final String token);
  Future<AuthResponse> refreshToken(final String refreshToken);
  Future<User> register({
    required final String name,
    required final String email,
    required final String password,
    required final String cpf,
    final String? phone,
  });
  Future<void> requestPasswordReset(final String email);
  Future<void> confirmPasswordReset(
      final String token, final String newPassword);
}
