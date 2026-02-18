import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences _instance;

  static Future<void> init() async {
    _instance = await SharedPreferences.getInstance();
  }

  static Future<bool> setBool(String key, bool value) async =>
      await _instance.setBool(key, value);

  static bool getBool(String key) => _instance.getBool(key) ?? false;

  static Future<bool> setString(String key, String value) async =>
      await _instance.setString(key, value);

  static String getString(String key) => _instance.getString(key) ?? '';

  static Future<bool> setInt(String key, int value) async =>
      await _instance.setInt(key, value);

  static int getInt(String key) => _instance.getInt(key) ?? 0;

  static Future<bool> setDouble(String key, double value) async =>
      await _instance.setDouble(key, value);

  static double getDouble(String key) => _instance.getDouble(key) ?? 0.0;

  static Future<bool> setStringList(String key, List<String> value) async =>
      await _instance.setStringList(key, value);

  static List<String> getStringList(String key) =>
      _instance.getStringList(key) ?? [];
}
