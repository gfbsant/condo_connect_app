abstract class SecureStorageService {
  Future<void> write(final String key, final String value);
  Future<String?> read(final String key);
  Future<void> delete(final String key);
  Future<void> deleteAll();
  Future<void> saveAccessToken(final String token);
  Future<String?> getAccessToken();
  Future<void> clearAccessToken();
}
