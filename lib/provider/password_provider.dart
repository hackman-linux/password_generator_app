import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/password_settings.dart';
import '../services/password_generator.dart';
import '../services/storage_service.dart';

class PasswordProvider extends ChangeNotifier {
  static const int _maxHistorySize = 50;

  PasswordSettings _settings = const PasswordSettings();
  List<GeneratedPassword> _history = [];
  List<GeneratedPassword> _currentPasswords = [];
  bool _isGenerating = false;
  final StorageService _storageService = StorageService();

  // Getters
  PasswordSettings get settings => _settings;
  List<GeneratedPassword> get history => List.unmodifiable(_history);
  List<GeneratedPassword> get currentPasswords => List.unmodifiable(_currentPasswords);
  bool get isGenerating => _isGenerating;
  bool get hasHistory => _history.isNotEmpty;
  GeneratedPassword? get lastGenerated =>
      _currentPasswords.isNotEmpty ? _currentPasswords.first : null;

  PasswordProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      await _storageService.init();
      await _loadSettings();
      await _loadHistory();
    } catch (e) {
      debugPrint('Error loading password data: $e');
    }
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await _storageService.loadSettings();
      if (settings != null) {
        _settings = settings;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  Future<void> _loadHistory() async {
    try {
      _history = await _storageService.loadHistory();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading history: $e');
    }
  }

  Future<void> updateSettings(PasswordSettings newSettings) async {
    if (_settings != newSettings) {
      _settings = newSettings;
      notifyListeners();
      try {
        await _storageService.saveSettings(_settings);
      } catch (e) {
        debugPrint('Error saving settings: $e');
      }
    }
  }

  Future<void> generatePasswords() async {
    if (_isGenerating || !_settings.isValid) {
      debugPrint('Invalid settings or already generating');
      return;
    }

    _isGenerating = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final passwords = PasswordGeneratorService.generateMultiplePasswords(_settings);
      _currentPasswords = passwords;

      for (final password in passwords) {
        await _addToHistory(password);
      }
    } catch (e) {
      debugPrint('Error generating passwords: $e');
    } finally {
      _isGenerating = false;
      notifyListeners();
    }
  }

  Future<void> _addToHistory(GeneratedPassword password) async {
    _history.insert(0, password);
    if (_history.length > _maxHistorySize) {
      _history = _history.take(_maxHistorySize).toList();
    }
    try {
      await _storageService.saveHistory(_history);
    } catch (e) {
      debugPrint('Error saving history: $e');
    }
  }

  Future<void> clearHistory() async {
    _history.clear();
    notifyListeners();
    try {
      await _storageService.clearHistory();
    } catch (e) {
      debugPrint('Error clearing history: $e');
    }
  }

  Future<void> removeFromHistory(GeneratedPassword password) async {
    _history.remove(password);
    notifyListeners();
    try {
      await _storageService.saveHistory(_history);
    } catch (e) {
      debugPrint('Error updating history: $e');
    }
  }

  void clearCurrentPasswords() {
    _currentPasswords.clear();
    notifyListeners();
  }

  Future<void> exportPasswords(BuildContext context) async {
    if (_currentPasswords.isEmpty) return;

    final exportText = _currentPasswords
        .map((p) => '${p.password} (Strength: ${p.strengthDisplayName}, Entropy: ${p.entropyBits.toStringAsFixed(1)} bits, Generated: ${p.generatedAt.toIso8601String()})')
        .join('\n');

    try {
      await Share.share(exportText, subject: 'Generated Passwords from SecureGen');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords shared successfully')),
      );
    } catch (e) {
      debugPrint('Error sharing passwords: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to share passwords')),
      );
    }
  }

  List<GeneratedPassword> filterHistoryByStrength(PasswordStrength strength) {
    return _history.where((p) => p.strength == strength).toList();
  }

  void updateLength(int length) {
    updateSettings(_settings.copyWith(length: length));
  }

  void toggleUppercase() {
    updateSettings(_settings.copyWith(includeUppercase: !_settings.includeUppercase));
  }

  void toggleLowercase() {
    updateSettings(_settings.copyWith(includeLowercase: !_settings.includeLowercase));
  }

  void toggleNumbers() {
    updateSettings(_settings.copyWith(includeNumbers: !_settings.includeNumbers));
  }

  void toggleSymbols() {
    updateSettings(_settings.copyWith(includeSymbols: !_settings.includeSymbols));
  }

  void toggleAmbiguous() {
    updateSettings(_settings.copyWith(excludeAmbiguous: !_settings.excludeAmbiguous));
  }

  void updateType(PasswordType type) {
    updateSettings(_settings.copyWith(type: type));
  }

  void updateQuantity(int quantity) {
    updateSettings(_settings.copyWith(quantity: quantity));
  }

  int get totalPasswordsGenerated => _history.length;

  Map<PasswordStrength, int> get strengthDistribution {
    final distribution = <PasswordStrength, int>{};
    for (final strength in PasswordStrength.values) {
      distribution[strength] = 0;
    }
    for (final password in _history) {
      distribution[password.strength] = (distribution[password.strength] ?? 0) + 1;
    }
    return distribution;
  }

  double get averagePasswordLength {
    if (_history.isEmpty) return 0.0;
    final totalLength = _history.map((p) => p.password.length).reduce((a, b) => a + b);
    return totalLength / _history.length;
  }

  PasswordType get mostUsedType {
    if (_history.isEmpty) return PasswordType.secure;
    final typeCount = <PasswordType, int>{};
    for (final password in _history) {
      typeCount[password.settings.type] = (typeCount[password.settings.type] ?? 0) + 1;
    }
    return typeCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
}