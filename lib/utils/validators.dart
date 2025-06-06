import '../models/password_settings.dart';
import 'constants.dart';

class Validators {
  // Validate password settings
  static String? validateSettings(PasswordSettings settings) {
    if (!settings.isValid) {
      return 'Invalid settings: At least one character set must be selected.';
    }
    if (settings.length < AppConstants.minPasswordLength) {
      return 'Password length must be at least ${AppConstants.minPasswordLength}.';
    }
    if (settings.length > AppConstants.maxPasswordLength) {
      return 'Password length must not exceed ${AppConstants.maxPasswordLength}.';
    }
    if (settings.quantity < 1) {
      return 'Quantity must be at least 1.';
    }
    if (settings.quantity > AppConstants.maxQuantity) {
      return 'Quantity must not exceed ${AppConstants.maxQuantity}.';
    }
    if (settings.type == PasswordType.pin && settings.includeSymbols) {
      return 'PIN passwords cannot include symbols.';
    }
    return null;
  }

  // Validate custom exclude characters
  static String? validateExcludeCharacters(String characters) {
    if (characters.contains(RegExp(r'[^a-zA-Z0-9!@#$%^&*()_+\-=\[\]{}|;:,.<>?]')))
    {
      return 'Exclude characters must be letters, numbers, or allowed symbols.';
    }
    return null;
  }

  // Validate custom pattern (for future custom pattern support)
  static String? validateCustomPattern(String pattern) {
    if (pattern.isEmpty) {
      return 'Pattern cannot be empty.';
    }
    // Add more pattern validation logic as needed
    return null;
  }
}