import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _preferences;

  StorageService._();

  static Future<StorageService> getInstance() async {
    _instance ??= StorageService._();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  Future<bool> setString(String key, String value) async {
    return await _preferences?.setString(key, value) ?? false;
  }

  Future<bool> setStringList(String key, List<String> value) async {
    return await _preferences?.setStringList(key, value) ?? false;
  }

  String? getString(String key) {
    return _preferences?.getString(key);
  }

  List<String>? getStringList(String key) {
    return _preferences?.getStringList(key);
  }

  Future<bool> remove(String key) async {
    return await _preferences?.remove(key) ?? false;
  }

  Future<bool> clear() async {
    return await _preferences?.clear() ?? false;
  }

  Future<void> saveObject(String key, Map<String, dynamic> value) async {
    final jsonString = jsonEncode(value);
    await setString(key, jsonString);
  }

  Future<void> saveObjectList<T>(
    String key,
    List<Map<String, dynamic>> value,
  ) async {
    final jsonStringList = value.map((item) => jsonEncode(item)).toList();
    await setStringList(key, jsonStringList);
  }

  Map<String, dynamic>? getObject(String key) {
    final jsonString = getString(key);
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  List<Map<String, dynamic>>? getObjectList(String key) {
    final jsonStringList = getStringList(key);
    if (jsonStringList == null) return null;
    return jsonStringList
        .map((item) => jsonDecode(item) as Map<String, dynamic>)
        .toList();
  }
}
