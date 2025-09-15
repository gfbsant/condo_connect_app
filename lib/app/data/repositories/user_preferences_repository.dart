import 'dart:convert';
import 'dart:developer' show log;

import 'package:condo_connect/app/data/models/user_preferences.dart';
import 'package:condo_connect/app/data/interfaces/user_preferences_repository_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferencesRepository implements UserPreferencesRepositoryInterface {
  final SharedPreferences _preferences;
  static const String _keyPrefix = 'user_preferences_';

  UserPreferencesRepository({required SharedPreferences preferences})
      : _preferences = preferences;

  String _getUserKey(String userId) => '$_keyPrefix$userId';

  @override
  Future<UserPreferences?> getUserPreferences(String userId) async {
    try {
      final key = _getUserKey(userId);
      final jsonString = _preferences.getString(key);

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
  Future<bool> saveUserPreferences(UserPreferences preferences) async {
    try {
      final key = _getUserKey(preferences.userId);
      final jsonString = jsonEncode(preferences.toJson());

      final success = await _preferences.setString(key, jsonString);

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
  Future<bool> clearUserPreferences(String userId) async {
    try {
      final key = _getUserKey(userId);
      final success = await _preferences.remove(key);

      log('Preferences cleared for user: $userId');
      return success;
    } on Exception catch (e) {
      log('Error clearing shared preferences: $e');
      return false;
    }
  }
}
