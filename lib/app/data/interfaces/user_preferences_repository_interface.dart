import '../models/user_preferences.dart';

abstract class UserPreferencesRepositoryInterface {
  Future<UserPreferences?> getUserPreferences(final String userId);
  Future<bool> saveUserPreferences(final UserPreferences preferences);
  Future<bool> clearUserPreferences(final String userId);
}
