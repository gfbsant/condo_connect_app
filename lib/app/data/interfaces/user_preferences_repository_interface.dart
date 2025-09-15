import 'package:condo_connect/app/data/models/user_preferences.dart';

abstract class UserPreferencesRepositoryInterface {
  Future<UserPreferences?> getUserPreferences(String userId);
  Future<bool> saveUserPreferences(UserPreferences preferences);
  Future<bool> clearUserPreferences(String userId);
}
