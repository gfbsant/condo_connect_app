import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import 'secure_storage_service.dart';

@Injectable(as: SecureStorageService)
class SecureStorageServiceImpl implements SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  static const accessTokenKey = 'access_token';

  @override
  Future<void> write(final String key, final String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<String?> read(final String key) => _storage.read(key: key);

  @override
  Future<void> delete(final String key) => _storage.delete(key: key);

  @override
  Future<void> deleteAll() => _storage.deleteAll();

  @override
  Future<void> saveAccessToken(final String token) =>
      write(accessTokenKey, token);

  @override
  Future<String?> getAccessToken() => read(accessTokenKey);

  @override
  Future<void> clearAccessToken() => delete(accessTokenKey);
}
