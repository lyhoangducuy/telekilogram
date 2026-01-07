import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static const _s = FlutterSecureStorage();

  static const _kAccess = "accessToken";
  static const _kRefresh = "refreshToken";
  static const _kUserJson = "userJson";

  static Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required String userJson,
  }) async {
    await _s.write(key: _kAccess, value: accessToken);
    await _s.write(key: _kRefresh, value: refreshToken);
    await _s.write(key: _kUserJson, value: userJson);
  }

  static Future<String?> accessToken() => _s.read(key: _kAccess);
  static Future<String?> refreshToken() => _s.read(key: _kRefresh);
  static Future<String?> userJson() => _s.read(key: _kUserJson);

  static Future<bool> isLoggedIn() async {
    final t = await accessToken();
    return t != null && t.isNotEmpty;
  }

  static Future<void> clear() async {
    await _s.delete(key: _kAccess);
    await _s.delete(key: _kRefresh);
    await _s.delete(key: _kUserJson);
  }
}
