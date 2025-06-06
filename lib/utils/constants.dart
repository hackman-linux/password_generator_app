import '../models/password_settings.dart';

class AppConstants {
  // Default password settings
  static const PasswordSettings defaultPasswordSettings = PasswordSettings(
    length: 12,
    includeUppercase: true,
    includeLowercase: true,
    includeNumbers: true,
    includeSymbols: true,
    excludeAmbiguous: false,
    pronounceable: false,
    excludeCharacters: '',
    type: PasswordType.secure,
    quantity: 1,
  );

  // UI constants
  static const double defaultPadding = 20.0;
  static const double cardBorderRadius = 16.0;
  static const double buttonBorderRadius = 12.0;
  static const double iconSize = 24.0;
  static const int maxHistorySize = 50;

  // Animation durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration generationDelay = Duration(milliseconds: 500);

  // Accessibility
  static const double minFontSize = 12.0;
  static const double maxFontSize = 24.0;

  // Validation
  static const int minPasswordLength = 4;
  static const int maxPasswordLength = 128;
  static const int maxQuantity = 10;
}