import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static const _tokenKey = 'auth_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userDataKey = 'user_data';
  static const _lastLoginkey = 'last_login';
  static const _isOfflineAuthEnabledKey = 'offline_auth_enabled';

  Future<void> saveToken(final String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<void> saveRefreshToken(final String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  Future<String?> getToken() async => _storage.read(key: _tokenKey);

  Future<String?> getRefreshToken() async =>
      _storage.read(key: _refreshTokenKey);

  Future<void> saveUserData(final Map<String, dynamic> userData) async {
    await _storage.write(key: _userDataKey, value: jsonEncode(userData));
    await _storage.write(
      key: _lastLoginkey,
      value: DateTime.now().toIso8601String(),
    );
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final String? userData = await _storage.read(key: _userDataKey);
    if (userData != null) {
      try {
        return jsonDecode(userData) as Map<String, dynamic>;
      } on Exception catch (e) {
        debugPrint(e.toString());
      }
    }
    return null;
  }

  Future<bool> hasValidOfflineAuth() async {
    final String? token = await getToken();
    final Map<String, dynamic>? userData = await getUserData();
    final String? lastLogin = await _storage.read(key: _lastLoginkey);
    final String? isOfflineEnabled =
        await _storage.read(key: _isOfflineAuthEnabledKey);

    if (token == null ||
        userData == null ||
        lastLogin == null ||
        isOfflineEnabled != 'true') {
      return false;
    }

    final DateTime lastLoginDate = DateTime.parse(lastLogin);
    final int daysSinceLastLogin =
        DateTime.now().difference(lastLoginDate).inDays;

    return daysSinceLastLogin < 30;
  }

  Future<void> enableOfflineAuth() async {
    await _storage.write(key: _isOfflineAuthEnabledKey, value: 'true');
  }

  Future<void> disableOfflineAuth() async {
    await _storage.write(key: _isOfflineAuthEnabledKey, value: 'false');
  }

  Future<bool> isOfflineAuthEnabled() async {
    final String? isEnabled =
        await _storage.read(key: _isOfflineAuthEnabledKey);
    return isEnabled == 'true';
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  Future<void> clearSession() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _userDataKey);
    await _storage.delete(key: _lastLoginkey);
  }
}
