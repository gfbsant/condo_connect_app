import 'dart:developer';

import 'package:condo_connect/app/data/interfaces/auth_repository_interface.dart';
import 'package:condo_connect/app/data/models/auth_response.dart';
import 'package:condo_connect/app/data/models/user_model.dart';

class AuthService {
  final AuthRepositoryInterface _repository;

  AuthService({required AuthRepositoryInterface repository})
      : _repository = repository;

  Future<AuthResponse> login(String email, String password) {
    try {
      return _repository.login(email: email, password: password);
    } on Exception catch (e) {
      log('Error in AuthService.login: $e');
      rethrow;
    }
  }

  Future<void> logout(String token) {
    try {
      return _repository.logout(token);
    } on Exception catch (e) {
      log('Error in AuthService.logout: $e');
      rethrow;
    }
  }

  Future<AuthResponse> refreshToken(String refreshToken) {
    try {
      return _repository.refreshToken(refreshToken);
    } on Exception catch (e) {
      log('Error in AuthService.refreshToken: $e');
      rethrow;
    }
  }

  Future<User> register({
    required String name,
    required String email,
    required String password,
    required String cpf,
    String? phone,
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
}
