import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/password_settings.dart';

class StorageService {
  static const String _settingsKey = 'password_settings';
  static const String _historyKey = 'password_history';
  static const String _themeKey = 'theme_mode';

  SharedPreferences? _prefs;
  bool _isInitialized = false;

  StorageService._privateConstructor();
  static final StorageService _instance = StorageService._privateConstructor();

  factory StorageService() {
    return _instance;
  }

  Future<void> init() async {
    if (!_isInitialized) {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
    }
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await init();
    }
  }

  // Save password settings
  Future<void> saveSettings(PasswordSettings settings) async {
    try {
      await _ensureInitialized();
      await _prefs!.setString(_settingsKey, jsonEncode(settings.toJson()));
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }

  // Load password settings
  Future<PasswordSettings?> loadSettings() async {
    try {
      await _ensureInitialized();
      final settingsJson = _prefs!.getString(_settingsKey);
      if (settingsJson != null) {
        return PasswordSettings.fromJson(jsonDecode(settingsJson));
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
    return null;
  }

  // Save password history
  Future<void> saveHistory(List<GeneratedPassword> history) async {
    try {
      await _ensureInitialized();
      final historyJson = history.map((p) => jsonEncode(p.toJson())).toList();
      await _prefs!.setStringList(_historyKey, historyJson);
    } catch (e) {
      debugPrint('Error saving history: $e');
    }
  }

  // Load password history
  Future<List<GeneratedPassword>> loadHistory() async {
    try {
      await _ensureInitialized();
      final historyJson = _prefs!.getStringList(_historyKey);
      if (historyJson != null) {
        return historyJson
            .map((json) => GeneratedPassword.fromJson(jsonDecode(json)))
            .toList()
            .reversed
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading history: $e');
    }
    return [];
  }

  // Clear history
  Future<void> clearHistory() async {
    try {
      await _ensureInitialized();
      await _prefs!.remove(_historyKey);
    } catch (e) {
      debugPrint('Error clearing history: $e');
    }
  }

  // Save theme mode
  Future<void> saveThemeMode(int themeIndex) async {
    try {
      await _ensureInitialized();
      await _prefs!.setInt(_themeKey, themeIndex);
    } catch (e) {
      debugPrint('Error saving theme mode: $e');
    }
  }

  // Load theme mode
  Future<int?> loadThemeMode() async {
    try {
      await _ensureInitialized();
      return _prefs!.getInt(_themeKey);
    } catch (e) {
      debugPrint('Error loading theme mode: $e');
    }
    return null;
  }
}