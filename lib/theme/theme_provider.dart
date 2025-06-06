import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.system;
  final StorageService _storageService = StorageService();

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode {
    switch (_themeMode) {
      case ThemeMode.dark:
        return true;
      case ThemeMode.light:
        return false;
      case ThemeMode.system:
        return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    }
  }

  ThemeProvider() {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    try {
      await _storageService.init();
      final savedThemeIndex = await _storageService.loadThemeMode();
      if (savedThemeIndex != null) {
        _themeMode = ThemeMode.values[savedThemeIndex];
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading theme mode: $e');
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    if (_themeMode != themeMode) {
      _themeMode = themeMode;
      notifyListeners();
      try {
        await _storageService.saveThemeMode(themeMode.index);
      } catch (e) {
        debugPrint('Error saving theme mode: $e');
      }
    }
  }

  Future<void> toggleTheme() async {
    final newThemeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newThemeMode);
  }

  String get currentThemeName {
    switch (_themeMode) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  IconData get themeIcon {
    switch (_themeMode) {
      case ThemeMode.system:
        return Icons.brightness_auto;
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
    }
  }
}