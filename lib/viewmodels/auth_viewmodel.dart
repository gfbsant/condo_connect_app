import 'package:condo_connect/core/storage/secure_storage.dart';
import 'package:condo_connect/core/utils/validators.dart';
import 'package:condo_connect/models/auth_response.dart';
import 'package:condo_connect/models/auth_state.dart';
import 'package:condo_connect/services/auth_service.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService;
  final SecureStorage _storage;

  AuthViewModel({
    required AuthService authService,
    required SecureStorage storage,
  })  : _authService = authService,
        _storage = storage;

  AuthState _state = AuthState.initial;
  String? _errorMessage;
  AuthResponse? _authResponse;

  AuthState get state => _state;
  String? get errorMessage => _errorMessage;
  AuthResponse? get authResponse => _authResponse;
  bool get isAuthenticated =>
      _authResponse != null && !_authResponse!.isExpired;
  bool get isLoading => _state == AuthState.loading;

  Future<bool> login(String email, String password) async {
    final emailError = Validators.validateEmail(email);
    if (emailError != null) {
      _setErrorMessage(emailError);
      return false;
    }

    final passwordError = Validators.validatePassword(password);
    if (passwordError != null) {
      _setErrorMessage(passwordError);
      return false;
    }

    _setAuthState(AuthState.loading);

    try {
      final AuthResponse response = await _authService.login(
        email: email,
        password: password,
      );

      _authResponse = response;

      await _storage.saveToken(response.token);
      await _storage.saveRefreshToken(response.refreshToken);

      _setAuthState(AuthState.authenticated);
      return true;
    } on Exception catch (e) {
      _setErrorMessage(e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    _setAuthState(AuthState.loading);
    try {
      if (_authResponse?.token != null) {
        await _authService.logout(_authResponse!.token);
      }
    } on Exception catch (e) {
      debugPrint('Erro no logout no servidor: $e');
    }

    _authResponse = null;
    await _storage.clearAll();
    _setAuthState(AuthState.initial);
  }

  Future<void> checkAuthStatus() async {
    final String? token = await _storage.getToken();
    final String? refreshToken = await _storage.getRefreshToken();

    if (token == null || refreshToken == null) {
      _setAuthState(AuthState.initial);
      return;
    }

    try {
      final AuthResponse response =
          await _authService.refreshToken(refreshToken);
      _authResponse = response;

      await _storage.saveToken(response.token);
      await _storage.saveRefreshToken(response.refreshToken);

      _setAuthState(AuthState.authenticated);
    } on Exception catch (e) {
      debugPrint('Erro ao checar status de autenticaçao: $e');
      await logout();
    }
  }

  void clearError() {
    _errorMessage = null;
    if (_state == AuthState.error) {
      _setAuthState(AuthState.initial);
    }
  }

  void _setAuthState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }

  void _setErrorMessage(String message) {
    _errorMessage = message;
    _setAuthState(AuthState.error);
  }
}
