import 'package:shared_preferences/shared_preferences.dart';

class LoginTokenStorage {
  LoginTokenStorage(this.sharedPreferences);

  final SharedPreferences sharedPreferences;
  static const _moreFishTokenKey = 'token';
  static const _poultryTokenKey = 'poultryToken';
  static const _moreFishUserIdKey = 'userId';
  static const _poultryUserIdKey = 'poultryUserId';

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
    return getMoreFishUserId();
  }

  Future<void> setUserId(int value) async {
    await setMoreFishUserId(value);
  }

  Future<void> removeUserId() async {
    await removeMoreFishUserId();
  }

  int? getMoreFishUserId() {
    return sharedPreferences.getInt(_moreFishUserIdKey);
  }

  Future<void> setMoreFishUserId(int value) async {
    await sharedPreferences.setInt(_moreFishUserIdKey, value);
  }

  Future<void> removeMoreFishUserId() async {
    await sharedPreferences.remove(_moreFishUserIdKey);
  }

  int? getPoultryUserId() {
    return sharedPreferences.getInt(_poultryUserIdKey);
  }

  Future<void> setPoultryUserId(int value) async {
    await sharedPreferences.setInt(_poultryUserIdKey, value);
  }

  Future<void> removePoultryUserId() async {
    await sharedPreferences.remove(_poultryUserIdKey);
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
