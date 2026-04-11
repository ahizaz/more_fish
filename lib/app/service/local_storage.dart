import 'package:shared_preferences/shared_preferences.dart';

class LoginTokenStorage {
  LoginTokenStorage(this.sharedPreferences);

  final SharedPreferences sharedPreferences;
  static const _tokenKey = 'token';
  static const _userIdKey = 'userId';

  String? getToken() {
    final token = sharedPreferences.getString(_tokenKey);
    if (token == null) return null;
    final normalized = token.trim();
    return normalized.isEmpty ? null : normalized;
  }

  Future<void> setToken(String value) async {
    await sharedPreferences.setString(_tokenKey, value.trim());
  }

  Future<void> removeToken() async {
    await sharedPreferences.remove(_tokenKey);
  }

  int? getUserId() {
    return sharedPreferences.getInt(_userIdKey);
  }

  Future<void> setUserId(int value) async {
    await sharedPreferences.setInt(_userIdKey, value);
  }

  Future<void> removeUserId() async {
    await sharedPreferences.remove(_userIdKey);
  }

  bool hasValidToken() {
    final token = getToken();
    if (token == null) return false;
    final normalized = token.trim().toLowerCase();
    return normalized.isNotEmpty &&
        normalized != 'null' &&
        normalized != 'undefined';
  }
}
