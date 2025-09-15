import 'dart:developer';

import 'package:condo_connect/app/core/storage/secure_storage.dart';
import 'package:condo_connect/app/core/utils/validators.dart';
import 'package:condo_connect/app/data/models/auth_response.dart';
import 'package:condo_connect/app/data/models/auth_state.dart';
import 'package:condo_connect/app/data/models/user_model.dart';
import 'package:condo_connect/app/data/services/auth_service.dart';
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
  bool _isRegistering = false;
  String? _registerError;

  AuthState get state => _state;
  String? get errorMessage => _errorMessage;
  AuthResponse? get authResponse => _authResponse;
  bool get isAuthenticated =>
      _authResponse != null && !_authResponse!.isExpired;
  bool get isLoading => _state == AuthState.loading;
  bool get isRegistering => _isRegistering;
  String? get registerError => _registerError;

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
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken != null) {
        final response = await _authService.refreshToken(refreshToken);
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

  Future<bool> register(
      {required String name,
      required String email,
      required String password,
      required String cpf,
      String? phone}) async {
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

  Future<void> _loadOfflineAuth() async {
    final userData = await _storage.getUserData();
    final token = await _storage.getToken();
    final refreshToken = await _storage.getRefreshToken();

    if (userData == null || token == null || refreshToken == null) return;

    _authResponse = AuthResponse(
      token: token,
      refreshToken: refreshToken,
      user: User.fromJson(userData),
      expiresAt: DateTime.now().add(Duration(hours: 24)),
    );
    _setAuthState(AuthState.authenticated);
  }

  Future<bool> _tryOfflineAuth(String email, String passwrod) async {
    if (!await _storage.hasValidOfflineAuth()) return false;
    final userData = await _storage.getUserData();
    if (userData == null) return false;
    if (userData['email'] != email) return false;

    _authResponse = AuthResponse(
      token: await _storage.getToken() ?? '',
      refreshToken: await _storage.getRefreshToken() ?? '',
      user: User.fromJson(userData),
      expiresAt: DateTime.now().add(Duration(hours: 8)),
    );
    _setAuthState(AuthState.authenticated);
    return true;
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
