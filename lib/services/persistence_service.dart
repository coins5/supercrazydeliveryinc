import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PersistenceService {
  static const String _gameSaveKey = 'super_crazy_delivery_save';

  Future<void> saveGame(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data);
    await prefs.setString(_gameSaveKey, jsonString);
  }

  Future<Map<String, dynamic>?> loadGame() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_gameSaveKey);
    if (jsonString == null) return null;
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      // Handle corruption or old format
      return null;
    }
  }

  Future<void> clearSave() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_gameSaveKey);
  }
}
