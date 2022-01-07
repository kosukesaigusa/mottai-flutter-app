import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferencesKey で管理するデータの列挙
enum SharedPreferencesKey {
  isAdmin,
  isHost,
}

class SharedPreferencesService {
  SharedPreferencesService._internal();

  static Future<SharedPreferences> get _instance => SharedPreferences.getInstance();
  static SharedPreferences? prefs;

  /// SharedPreferences のインスタンスをシングルトンサービスクラスの
  /// メンバ変数に格納する
  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  /// int 型のキー・バリューを保存する
  static Future<int> _getInt(SharedPreferencesKey key) async {
    return _instance.then((i) => i.getInt(key.name) ?? 0);
  }

  /// String 型のキー・バリューを保存する
  static Future<String> _getString(SharedPreferencesKey key) async {
    return _instance.then((i) => i.getString(key.name) ?? '');
  }

  /// bool 型のキー・バリューを保存する
  static Future<bool> _getBool(SharedPreferencesKey key) async {
    return _instance.then((i) => i.getBool(key.name) ?? false);
  }

  /// int 型のキー・バリューペアを保存する
  static Future<bool> _setInt(SharedPreferencesKey key, int value) async {
    return _instance.then((i) => i.setInt(key.name, value));
  }

  /// String 型のキー・バリューペアを保存する
  static Future<bool> _setString(SharedPreferencesKey key, String value) async {
    return _instance.then((i) => i.setString(key.name, value));
  }

  /// bool 型のキー・バリューペアを保存する
  static Future<bool> _setBool(SharedPreferencesKey key, bool value) async {
    return _instance.then((i) => i.setBool(key.name, value));
  }

  /// SharedPrefereces に保存している値をすべて消す
  static Future<bool> deleteAll() async {
    return _instance.then((i) => i.clear());
  }

  // 以下、具体的な値の出し入れを記述する
  // 保存（bool については true を保存したいときだけ使用する）
  static Future<bool> setIsAdmin() => _setBool(SharedPreferencesKey.isAdmin, true);
  static Future<bool> setIsHost() => _setBool(SharedPreferencesKey.isHost, true);

  // 取得
  static Future<bool> getIsAdmin() => _getBool(SharedPreferencesKey.isAdmin);
  static Future<bool> getIsHost() => _getBool(SharedPreferencesKey.isHost);
}
