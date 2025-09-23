import 'dart:convert';
import 'dart:developer' show log;

import 'package:shared_preferences/shared_preferences.dart';

import '../interfaces/user_preferences_repository_interface.dart';
import '../models/user_preferences.dart';

class UserPreferencesRepository implements UserPreferencesRepositoryInterface {
  UserPreferencesRepository({required final SharedPreferences preferences})
      : _preferences = preferences;
  final SharedPreferences _preferences;
  static const _keyPrefix = 'user_preferences_';

  String _getUserKey(final String userId) => '$_keyPrefix$userId';

  @override
  Future<UserPreferences?> getUserPreferences(final String userId) async {
    try {
      final String key = _getUserKey(userId);
      final String? jsonString = _preferences.getString(key);

      if (jsonString == null) {
        log('No preferences found for user: $userId');
        return null;
      }
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserPreferences.fromJson(json);
    } on Exception catch (e) {
      log('Error loading user preferences: $e');
      return null;
    }
  }

  @override
  Future<bool> saveUserPreferences(final UserPreferences preferences) async {
    try {
      final String key = _getUserKey(preferences.userId);
      final String jsonString = jsonEncode(preferences.toJson());

      final bool success = await _preferences.setString(key, jsonString);

      if (success) {
        log('Preferences saved for user: ${preferences.userId}');
      } else {
        log('Failer to save preferences for user: ${preferences.userId}');
      }
      return success;
    } on Exception catch (e) {
      log('Error saving user preferences: $e');
      return false;
    }
  }

  @override
  Future<bool> clearUserPreferences(final String userId) async {
    try {
      final String key = _getUserKey(userId);
      final bool success = await _preferences.remove(key);

      log('Preferences cleared for user: $userId');
      return success;
    } on Exception catch (e) {
      log('Error clearing shared preferences: $e');
      return false;
    }
  }
}
