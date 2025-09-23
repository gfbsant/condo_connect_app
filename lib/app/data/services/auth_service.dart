import 'dart:developer';

import '../interfaces/auth_repository_interface.dart';
import '../models/auth_response.dart';
import '../models/user_model.dart';

class AuthService {
  AuthService({required final AuthRepositoryInterface repository})
      : _repository = repository;
  final AuthRepositoryInterface _repository;

  Future<AuthResponse> login(final String email, final String password) {
    try {
      return _repository.login(email: email, password: password);
    } on Exception catch (e) {
      log('Error in AuthService.login: $e');
      rethrow;
    }
  }

  Future<void> logout(final String token) {
    try {
      return _repository.logout(token);
    } on Exception catch (e) {
      log('Error in AuthService.logout: $e');
      rethrow;
    }
  }

  Future<AuthResponse> refreshToken(final String refreshToken) {
    try {
      return _repository.refreshToken(refreshToken);
    } on Exception catch (e) {
      log('Error in AuthService.refreshToken: $e');
      rethrow;
    }
  }

  Future<User> register({
    required final String name,
    required final String email,
    required final String password,
    required final String cpf,
    final String? phone,
  }) {
    try {
      return _repository.register(
        name: name,
        email: email,
        password: password,
        cpf: cpf,
        phone: phone,
      );
    } on Exception catch (e) {
      log('Error in AuthService.register: $e');
      rethrow;
    }
  }

  Future<void> requestPasswordReset(final String email) {
    try {
      return _repository.requestPasswordReset(email);
    } on Exception catch (e) {
      log('Error in AuthService.requestPasswordReset: $e');
      rethrow;
    }
  }

  Future<void> confirmPasswordReset(
      final String token, final String newPassword) {
    try {
      return _repository.confirmPasswordReset(
        token,
        newPassword,
      );
    } on Exception catch (e) {
      log('Error in AuthService.confirmPasswordReset: $e');
      rethrow;
    }
  }
}
