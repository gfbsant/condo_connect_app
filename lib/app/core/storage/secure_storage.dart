import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userDataKey = 'user_data';
  static const String _lastLoginkey = 'last_login';
  static const String _isOfflineAuthEnabledKey = 'offline_auth_enabled';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _storage.write(key: _userDataKey, value: jsonEncode(userData));
    await _storage.write(
        key: _lastLoginkey, value: DateTime.now().toIso8601String());
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final userData = await _storage.read(key: _userDataKey);
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
    final token = await getToken();
    final userData = await getUserData();
    final lastLogin = await _storage.read(key: _lastLoginkey);
    final isOfflineEnabled = await _storage.read(key: _isOfflineAuthEnabledKey);

    if (token == null ||
        userData == null ||
        lastLogin == null ||
        isOfflineEnabled != 'true') {
      return false;
    }

    final lastLoginDate = DateTime.parse(lastLogin);
    final daysSinceLastLogin = DateTime.now().difference(lastLoginDate).inDays;

    return daysSinceLastLogin < 30;
  }

  Future<void> enableOfflineAuth() async {
    await _storage.write(key: _isOfflineAuthEnabledKey, value: 'true');
  }

  Future<void> disableOfflineAuth() async {
    await _storage.write(key: _isOfflineAuthEnabledKey, value: 'false');
  }

  Future<bool> isOfflineAuthEnabled() async {
    final isEnabled = await _storage.read(key: _isOfflineAuthEnabledKey);
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
