import 'package:get_storage/get_storage.dart';

class AppSession {
  static final GetStorage _box = GetStorage();

  static const String _tokenKey = "api_token";
  static const String _snoKey = "user_sno";
  static const String _loginKey = "is_logged_in";

  static Future<void> init() async {
    await GetStorage.init();
  }

  static void set(String key, dynamic value) {
    _box.write(key, value);
  }

  static dynamic get(String key) {
    return _box.read(key);
  }

  /// ---------------- TOKEN ----------------

  static void saveToken(String token) {
    _box.write(_tokenKey, token);
  }

  static String? get token => _box.read(_tokenKey);

  /// ---------------- USER SNO ----------------

  static void saveUserSno(String sno) {
    _box.write(_snoKey, sno);
  }

  static String? get userSno => _box.read(_snoKey);

  /// ---------------- LOGIN STATE ----------------

  static void setLoggedIn(bool value) {
    _box.write(_loginKey, value);
  }

  static bool get isLoggedIn => _box.read(_loginKey) ?? false;

  /// ---------------- CLEAR SESSION ----------------

  static void clear() {
    _box.remove(_tokenKey);
    _box.remove(_snoKey);
    _box.remove(_loginKey);
  }
}
