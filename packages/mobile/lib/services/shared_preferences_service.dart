import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferencesKey で管理するデータの列挙
enum SharedPreferencesKey {
  isAdmin,
  isHost,
  profileImageURL,
}

final sharedPreferencesService = Provider.autoDispose((ref) => SharedPreferencesService());

class SharedPreferencesService {
  factory SharedPreferencesService() => _instance;
  SharedPreferencesService._internal();
  static final SharedPreferencesService _instance = SharedPreferencesService._internal();

  static Future<SharedPreferences> get _spInstance => SharedPreferences.getInstance();
  static late SharedPreferences sp;

  /// SharedPreferences のインスタンスをシングルトンサービスクラスの
  /// メンバ変数に格納する
  static Future<void> initialize() async {
    sp = await SharedPreferences.getInstance();
  }

  /// int 型のキー・バリューを保存する
  static Future<int> _getInt(SharedPreferencesKey key) async {
    return _spInstance.then((i) => i.getInt(key.name) ?? 0);
  }

  /// String 型のキー・バリューを保存する
  static Future<String> _getString(SharedPreferencesKey key) async {
    return _spInstance.then((i) => i.getString(key.name) ?? '');
  }

  /// bool 型のキー・バリューを保存する
  static Future<bool> _getBool(SharedPreferencesKey key) async {
    return _spInstance.then((i) => i.getBool(key.name) ?? false);
  }

  /// int 型のキー・バリューペアを保存する
  static Future<bool> _setInt(SharedPreferencesKey key, int value) async {
    return _spInstance.then((i) => i.setInt(key.name, value));
  }

  /// String 型のキー・バリューペアを保存する
  static Future<bool> _setString(SharedPreferencesKey key, String value) async {
    return _spInstance.then((i) => i.setString(key.name, value));
  }

  /// bool 型のキー・バリューペアを保存する
  static Future<bool> _setBool(SharedPreferencesKey key, bool value) async {
    return _spInstance.then((i) => i.setBool(key.name, value));
  }

  /// SharedPreferences に保存している値をすべて消す
  static Future<bool> deleteAll() async {
    return _spInstance.then((i) => i.clear());
  }

  // 以下、具体的な値の出し入れを記述する
  // 保存（bool については true を保存したいときだけ使用する）
  static Future<bool> setIsAdmin() => _setBool(SharedPreferencesKey.isAdmin, true);
  static Future<bool> setIsHost() => _setBool(SharedPreferencesKey.isHost, true);
  static Future<bool> setProfileImageURL(String url) =>
      _setString(SharedPreferencesKey.profileImageURL, url);

  // 取得
  static Future<bool> getIsAdmin() => _getBool(SharedPreferencesKey.isAdmin);
  static Future<bool> getIsHost() => _getBool(SharedPreferencesKey.isHost);
  static Future<String?> getProfileImageURL() => _getString(SharedPreferencesKey.profileImageURL);
}
