import 'package:shared_preferences/shared_preferences.dart';

class LoginTokenStorage {
  LoginTokenStorage(this.sharedPreferences);

  final SharedPreferences sharedPreferences;
  static const _moreFishTokenKey = 'token';
  static const _poultryTokenKey = 'poultryToken';
  static const _userIdKey = 'userId';

  String? getToken() {
    return getMoreFishToken();
  }

  Future<void> setToken(String value) async {
    await setMoreFishToken(value);
  }

  Future<void> removeToken() async {
    await removeMoreFishToken();
  }

  String? getMoreFishToken() {
    return _normalizedToken(sharedPreferences.getString(_moreFishTokenKey));
  }

  Future<void> setMoreFishToken(String value) async {
    await sharedPreferences.setString(_moreFishTokenKey, value.trim());
  }

  Future<void> removeMoreFishToken() async {
    await sharedPreferences.remove(_moreFishTokenKey);
  }

  String? getPoultryToken() {
    return _normalizedToken(sharedPreferences.getString(_poultryTokenKey));
  }

  Future<void> setPoultryToken(String value) async {
    await sharedPreferences.setString(_poultryTokenKey, value.trim());
  }

  Future<void> removePoultryToken() async {
    await sharedPreferences.remove(_poultryTokenKey);
  }

  Future<void> removeAllTokens() async {
    await removeMoreFishToken();
    await removePoultryToken();
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
    return hasValidMoreFishToken();
  }

  bool hasValidMoreFishToken() {
    final token = getMoreFishToken();
    if (token == null) return false;
    final normalized = token.trim().toLowerCase();
    return normalized.isNotEmpty &&
        normalized != 'null' &&
        normalized != 'undefined';
  }

  bool hasValidPoultryToken() {
    final token = getPoultryToken();
    if (token == null) return false;
    final normalized = token.trim().toLowerCase();
    return normalized.isNotEmpty &&
        normalized != 'null' &&
        normalized != 'undefined';
  }

  String? _normalizedToken(String? token) {
    if (token == null) return null;
    final normalized = token.trim();
    return normalized.isEmpty ? null : normalized;
  }
}
