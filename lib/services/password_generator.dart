import 'dart:math';
import '../models/password_settings.dart';
import '../utils/validators.dart';

class PasswordGeneratorService {
  static final Random _secureRandom = Random.secure();

  // Character sets
  static const String _uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String _lowercase = 'abcdefghijklmnopqrstuvwxyz';
  static const String _numbers = '0123456789';
  static const String _symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';
  static const String _ambiguous = 'Il1O0B8G6S5Z2';
  static const List<String> _pronounceableVowels = ['a', 'e', 'i', 'o', 'u'];
  static const List<String> _pronounceableConsonants = [
    'b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm',
    'n', 'p', 'q', 'r', 's', 't', 'v', 'w', 'x', 'y', 'z'
  ];
  static const List<String> _wordList = [
    'apple', 'banana', 'cherry', 'date', 'elder', 'fig', 'grape', 'honey',
    'ice', 'jam', 'kiwi', 'lemon', 'mango', 'nut', 'orange', 'pear',
    'quince', 'raspberry', 'strawberry', 'tangerine', 'uva', 'vanilla',
    'walnut', 'xigua', 'yam', 'zucchini'
  ];

  // Generate multiple passwords based on settings
  static List<GeneratedPassword> generateMultiplePasswords(PasswordSettings settings) {
    final validationError = Validators.validateSettings(settings);
    if (validationError != null) {
      throw Exception(validationError);
    }

    final List<GeneratedPassword> passwords = [];
    for (int i = 0; i < settings.quantity; i++) {
      passwords.add(_generateSinglePassword(settings));
    }
    return passwords;
  }

  // Generate a single password
  static GeneratedPassword _generateSinglePassword(PasswordSettings settings) {
    String password;
    switch (settings.type) {
      case PasswordType.secure:
        password = _generateSecurePassword(settings);
        break;
      case PasswordType.pronounceable:
        password = _generatePronounceablePassword(settings);
        break;
      case PasswordType.pin:
        password = _generatePin(settings);
        break;
      case PasswordType.passphrase:
        password = _generatePassphrase(settings);
        break;
      case PasswordType.custom:
        password = _generateCustomPassword(settings);
        break;
    }

    final entropyBits = _calculateEntropy(password, settings);
    final strength = _calculateStrength(password, entropyBits);

    return GeneratedPassword(
      password: password,
      strength: strength,
      entropyBits: entropyBits,
      settings: settings,
      generatedAt: DateTime.now(),
    );
  }

  // Generate a secure random password
  static String _generateSecurePassword(PasswordSettings settings) {
    String chars = '';
    if (settings.includeUppercase) chars += _uppercase;
    if (settings.includeLowercase) chars += _lowercase;
    if (settings.includeNumbers) chars += _numbers;
    if (settings.includeSymbols) chars += _symbols;

    if (settings.excludeAmbiguous) {
      for (final char in _ambiguous.split('')) {
        chars = chars.replaceAll(char, '');
      }
    }
    if (settings.excludeCharacters.isNotEmpty) {
      for (final char in settings.excludeCharacters.split('')) {
        chars = chars.replaceAll(char, '');
      }
    }

    if (chars.isEmpty) {
      throw Exception('No valid characters available for password generation.');
    }

    return List.generate(
      settings.length,
          (_) => chars[_secureRandom.nextInt(chars.length)],
    ).join();
  }

  // Generate a pronounceable password
  static String _generatePronounceablePassword(PasswordSettings settings) {
    final List<String> segments = [];
    int remainingLength = settings.length;
    bool useVowel = _secureRandom.nextBool();

    while (remainingLength > 0) {
      final segmentLength = min(2, remainingLength);
      final segment = useVowel
          ? _pronounceableVowels[_secureRandom.nextInt(_pronounceableVowels.length)]
          : _pronounceableConsonants[_secureRandom.nextInt(_pronounceableConsonants.length)];
      segments.add(segment);
      remainingLength -= segmentLength;
      useVowel = !useVowel;
    }

    String password = segments.join();
    if (settings.includeUppercase) {
      password = _capitalizeRandomly(password);
    }
    if (settings.includeNumbers) {
      password = _insertRandomDigits(password, settings.length ~/ 4);
    }
    if (settings.includeSymbols) {
      password = _insertRandomSymbols(password, settings.length ~/ 4);
    }

    // Ensure exact length
    if (password.length > settings.length) {
      password = password.substring(0, settings.length);
    } else if (password.length < settings.length) {
      password += _generateSecurePassword(
        settings.copyWith(
          length: settings.length - password.length,
          includeSymbols: false,
          includeNumbers: false,
        ),
      );
    }

    return password;
  }

  // Generate a PIN
  static String _generatePin(PasswordSettings settings) {
    return List.generate(
      settings.length,
          (_) => _numbers[_secureRandom.nextInt(_numbers.length)],
    ).join();
  }

  // Generate a passphrase
  static String _generatePassphrase(PasswordSettings settings) {
    final wordCount = max(3, settings.length ~/ 5);
    final words = List.generate(
      wordCount,
          (_) => _wordList[_secureRandom.nextInt(_wordList.length)],
    );
    String passphrase = words.join('-');

    if (settings.includeUppercase) {
      passphrase = _capitalizeRandomly(passphrase);
    }
    if (settings.includeNumbers) {
      passphrase = _insertRandomDigits(passphrase, 2);
    }
    if (settings.includeSymbols) {
      passphrase = _insertRandomSymbols(passphrase, 2);
    }

    // Adjust length
    if (passphrase.length > settings.length) {
      passphrase = passphrase.substring(0, settings.length);
    } else if (passphrase.length < settings.length) {
      passphrase += _generateSecurePassword(
        settings.copyWith(
          length: settings.length - passphrase.length,
          includeSymbols: false,
          includeNumbers: false,
        ),
      );
    }

    return passphrase;
  }

  // Generate a custom password (placeholder for custom patterns)
  static String _generateCustomPassword(PasswordSettings settings) {
    return _generateSecurePassword(settings);
  }

  // Helper: Capitalize random characters
  static String _capitalizeRandomly(String input) {
    final chars = input.split('');
    for (int i = 0; i < chars.length ~/ 2; i++) {
      final index = _secureRandom.nextInt(chars.length);
      chars[index] = chars[index].toUpperCase();
    }
    return chars.join();
  }

  // Helper: Insert random digits
  static String _insertRandomDigits(String input, int count) {
    String result = input;
    for (int i = 0; i < count; i++) {
      final index = _secureRandom.nextInt(result.length + 1);
      final digit = _numbers[_secureRandom.nextInt(_numbers.length)];
      result = result.substring(0, index) + digit + result.substring(index);
    }
    return result;
  }

  // Helper: Insert random symbols
  static String _insertRandomSymbols(String input, int count) {
    String result = input;
    for (int i = 0; i < count; i++) {
      final index = _secureRandom.nextInt(result.length + 1);
      final symbol = _symbols[_secureRandom.nextInt(_symbols.length)];
      result = result.substring(0, index) + symbol + result.substring(index);
    }
    return result;
  }

  // Calculate entropy in bits
  static double _calculateEntropy(String password, PasswordSettings settings) {
    int poolSize = 0;
    if (settings.includeUppercase) poolSize += _uppercase.length;
    if (settings.includeLowercase) poolSize += _lowercase.length;
    if (settings.includeNumbers) poolSize += _numbers.length;
    if (settings.includeSymbols) poolSize += _symbols.length;

    if (settings.excludeAmbiguous) {
      poolSize -= _ambiguous.split('').toSet().intersection(password.split('').toSet()).length;
    }
    if (settings.excludeCharacters.isNotEmpty) {
      poolSize -= settings.excludeCharacters.split('').toSet().intersection(password.split('').toSet()).length;
    }

    if (settings.type == PasswordType.pin) {
      poolSize = _numbers.length;
    } else if (settings.type == PasswordType.passphrase) {
      poolSize = _wordList.length;
    }

    if (poolSize <= 0) return 0.0;

    return (password.length * log(poolSize) / log(2)).toDouble();
  }

  // Calculate password strength
  static PasswordStrength _calculateStrength(String password, double entropyBits) {
    if (password.length < 6 || entropyBits < 28) {
      return PasswordStrength.veryWeak;
    } else if (password.length < 8 || entropyBits < 36) {
      return PasswordStrength.weak;
    } else if (password.length < 10 || entropyBits < 59) {
      return PasswordStrength.fair;
    } else if (password.length < 12 || entropyBits < 80) {
      return PasswordStrength.good;
    } else if (entropyBits >= 128) {
      return PasswordStrength.veryStrong;
    } else {
      return PasswordStrength.strong;
    }
  }
}