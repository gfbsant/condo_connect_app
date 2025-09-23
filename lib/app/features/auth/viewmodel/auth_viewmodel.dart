import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../core/storage/secure_storage.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/auth_response.dart';
import '../../../data/models/auth_state.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel({
    required final AuthService authService,
    required final SecureStorage storage,
  })  : _authService = authService,
        _storage = storage;
  final AuthService _authService;
  final SecureStorage _storage;

  AuthState _state = AuthState.initial;
  String? _errorMessage;
  AuthResponse? _authResponse;
  var _isRegistering = false;
  String? _registerError;

  AuthState get state => _state;
  String? get errorMessage => _errorMessage;
  AuthResponse? get authResponse => _authResponse;
  bool get isAuthenticated =>
      _authResponse != null && !_authResponse!.isExpired;
  bool get isLoading => _state == AuthState.loading;
  bool get isRegistering => _isRegistering;
  String? get registerError => _registerError;

  Future<bool> login(final String email, final String password) async {
    final String? emailError = Validators.validateEmail(email);
    if (emailError != null) {
      _setErrorMessage(emailError);
      return false;
    }
    final String? passwordError = Validators.validatePassword(password);
    if (passwordError != null) {
      _setErrorMessage(passwordError);
      return false;
    }
    _setAuthState(AuthState.loading);
    try {
      final AuthResponse response = await _authService.login(email, password);
      _authResponse = response;
      await _storage.saveToken(response.token);
      await _storage.saveRefreshToken(response.refreshToken);
      await _storage.saveUserData(response.user.toJson());
      await _storage.enableOfflineAuth();
      _setAuthState(AuthState.authenticated);
      return true;
    } on Exception catch (e) {
      if (await _tryOfflineAuth(email, password)) {
        return true;
      }
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
    await _storage.clearSession();
    await _storage.disableOfflineAuth();
    _setAuthState(AuthState.initial);
  }

  Future<void> checkAuthStatus() async {
    final String? token = await _storage.getToken();
    final String? refreshToken = await _storage.getRefreshToken();

    if (token == null || refreshToken == null) {
      if (await _storage.hasValidOfflineAuth()) {
        await _loadOfflineAuth();
        return;
      }
      _setAuthState(AuthState.initial);
      return;
    }

    try {
      final AuthResponse response =
          await _authService.refreshToken(refreshToken);
      _authResponse = response;

      await _storage.saveToken(response.token);
      await _storage.saveRefreshToken(response.refreshToken);
      await _storage.saveUserData(response.user.toJson());

      _setAuthState(AuthState.authenticated);
    } on Exception catch (e) {
      log('Erro ao checar status de autenticacao offline: $e');
      if (await _storage.hasValidOfflineAuth()) {
        await _loadOfflineAuth();
      } else {
        await logout();
      }
    }
  }

  Future<void> syncOnlineData() async {
    if (!isAuthenticated) return;

    try {
      final String? refreshToken = await _storage.getRefreshToken();
      if (refreshToken != null) {
        final AuthResponse response =
            await _authService.refreshToken(refreshToken);
        _authResponse = response;

        await _storage.saveToken(response.token);
        await _storage.saveRefreshToken(response.refreshToken);
        await _storage.saveUserData(response.user.toJson());

        notifyListeners();
      }
    } on Exception catch (e) {
      log('Sync offline data error: $e', stackTrace: StackTrace.current);
    }
  }

  Future<bool> register({
    required final String name,
    required final String email,
    required final String password,
    required final String cpf,
    final String? phone,
  }) async {
    try {
      _isRegistering = true;
      _registerError = null;
      notifyListeners();
      final User registeredUser = await _authService.register(
        name: name,
        email: email,
        password: password,
        cpf: cpf,
        phone: phone,
      );
      log('Usuario cadastrado com sucesso: ${registeredUser.email}');
      _isRegistering = false;
      notifyListeners();

      return true;
    } on Exception catch (e) {
      _registerError = e.toString().replaceAll('Exception: ', '');
      log('Erro no cadastro: $_registerError');
      _isRegistering = false;
      notifyListeners();

      return false;
    }
  }

  Future<bool> requestPasswordReset(final String email) async {
    final String? emailError = Validators.validateEmail(email);
    if (emailError != null) {
      _setErrorMessage('Email inválido');
    }

    _setAuthState(AuthState.loading);
    try {
      await _authService.requestPasswordReset(email);
      _setAuthState(AuthState.success);
      return true;
    } on Exception catch (e) {
      _setErrorMessage(e.toString().replaceFirst('Exception: ', ''));
      return false;
    }
  }

  Future<bool> confirmPasswordReset(
      final String token, final String newPassword) async {
    final String? passwordError = Validators.validatePassword(newPassword);
    if (passwordError != null) {
      _setErrorMessage('Senha deve ter pelo menos 6 caracteres');
      return false;
    }

    _setAuthState(AuthState.loading);
    try {
      await _authService.confirmPasswordReset(token, newPassword);
      _setAuthState(AuthState.success);
      return true;
    } on Exception catch (e) {
      _setErrorMessage(e.toString().replaceFirst('Exception: ', ''));
      return false;
    }
  }

  void clearRegisterError() {
    _registerError = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    if (_state == AuthState.error) {
      _setAuthState(AuthState.initial);
    }
  }

  void resetToInitialState() {
    _state = AuthState.initial;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> _loadOfflineAuth() async {
    final Map<String, dynamic>? userData = await _storage.getUserData();
    final String? token = await _storage.getToken();
    final String? refreshToken = await _storage.getRefreshToken();

    if (userData == null || token == null || refreshToken == null) return;

    _authResponse = AuthResponse(
      token: token,
      refreshToken: refreshToken,
      user: User.fromJson(userData),
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
    );
    _setAuthState(AuthState.authenticated);
  }

  Future<bool> _tryOfflineAuth(
      final String email, final String passwrod) async {
    if (!await _storage.hasValidOfflineAuth()) return false;
    final Map<String, dynamic>? userData = await _storage.getUserData();
    if (userData == null) return false;
    if (userData['email'] != email) return false;

    _authResponse = AuthResponse(
      token: await _storage.getToken() ?? '',
      refreshToken: await _storage.getRefreshToken() ?? '',
      user: User.fromJson(userData),
      expiresAt: DateTime.now().add(const Duration(hours: 8)),
    );
    _setAuthState(AuthState.authenticated);
    return true;
  }

  void _setAuthState(final AuthState newState) {
    _state = newState;
    notifyListeners();
  }

  void _setErrorMessage(final String message) {
    _errorMessage = message;
    _setAuthState(AuthState.error);
  }
}
