import 'package:equatable/equatable.dart';

enum PasswordType { secure, pronounceable, pin, passphrase, custom }

extension PasswordTypeExtension on PasswordType {
  String get typeDisplayName {
    switch (this) {
      case PasswordType.secure:
        return 'Secure';
      case PasswordType.pronounceable:
        return 'Pronounceable';
      case PasswordType.pin:
        return 'PIN';
      case PasswordType.passphrase:
        return 'Passphrase';
      case PasswordType.custom:
        return 'Custom';
    }
  }
}

enum PasswordStrength { veryWeak, weak, fair, good, strong, veryStrong }

extension PasswordStrengthExtension on PasswordStrength {
  String get strengthDisplayName {
    switch (this) {
      case PasswordStrength.veryWeak:
        return 'Very Weak';
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.fair:
        return 'Fair';
      case PasswordStrength.good:
        return 'Good';
      case PasswordStrength.strong:
        return 'Strong';
      case PasswordStrength.veryStrong:
        return 'Very Strong';
    }
  }

  double get strengthScore {
    switch (this) {
      case PasswordStrength.veryWeak:
        return 0.2;
      case PasswordStrength.weak:
        return 0.4;
      case PasswordStrength.fair:
        return 0.6;
      case PasswordStrength.good:
        return 0.8;
      case PasswordStrength.strong:
        return 0.9;
      case PasswordStrength.veryStrong:
        return 1.0;
    }
  }
}

class PasswordSettings extends Equatable {
  final int length;
  final bool includeUppercase;
  final bool includeLowercase;
  final bool includeNumbers;
  final bool includeSymbols;
  final bool excludeAmbiguous;
  final bool pronounceable;
  final String excludeCharacters;
  final PasswordType type;
  final int quantity;

  const PasswordSettings({
    this.length = 12,
    this.includeUppercase = true,
    this.includeLowercase = true,
    this.includeNumbers = true,
    this.includeSymbols = true,
    this.excludeAmbiguous = false,
    this.pronounceable = false,
    this.excludeCharacters = '',
    this.type = PasswordType.secure,
    this.quantity = 1,
  });

  PasswordSettings copyWith({
    int? length,
    bool? includeUppercase,
    bool? includeLowercase,
    bool? includeNumbers,
    bool? includeSymbols,
    bool? excludeAmbiguous,
    bool? pronounceable,
    String? excludeCharacters,
    PasswordType? type,
    int? quantity,
  }) {
    return PasswordSettings(
      length: length ?? this.length,
      includeUppercase: includeUppercase ?? this.includeUppercase,
      includeLowercase: includeLowercase ?? this.includeLowercase,
      includeNumbers: includeNumbers ?? this.includeNumbers,
      includeSymbols: includeSymbols ?? this.includeSymbols,
      excludeAmbiguous: excludeAmbiguous ?? this.excludeAmbiguous,
      pronounceable: pronounceable ?? this.pronounceable,
      excludeCharacters: excludeCharacters ?? this.excludeCharacters,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'length': length,
      'includeUppercase': includeUppercase,
      'includeLowercase': includeLowercase,
      'includeNumbers': includeNumbers,
      'includeSymbols': includeSymbols,
      'excludeAmbiguous': excludeAmbiguous,
      'pronounceable': pronounceable,
      'excludeCharacters': excludeCharacters,
      'type': type.index,
      'quantity': quantity,
    };
  }

  factory PasswordSettings.fromJson(Map<String, dynamic> json) {
    return PasswordSettings(
      length: json['length'] as int,
      includeUppercase: json['includeUppercase'] as bool,
      includeLowercase: json['includeLowercase'] as bool,
      includeNumbers: json['includeNumbers'] as bool,
      includeSymbols: json['includeSymbols'] as bool,
      excludeAmbiguous: json['excludeAmbiguous'] as bool,
      pronounceable: json['pronounceable'] as bool,
      excludeCharacters: json['excludeCharacters'] as String,
      type: PasswordType.values[json['type'] as int],
      quantity: json['quantity'] as int,
    );
  }

  bool get isValid {
    return (includeUppercase || includeLowercase || includeNumbers || includeSymbols) &&
        length >= 4 &&
        length <= 128 &&
        quantity >= 1 &&
        quantity <= 10 &&
        (type != PasswordType.pin || !includeSymbols);
  }

  @override
  List<Object> get props => [
    length,
    includeUppercase,
    includeLowercase,
    includeNumbers,
    includeSymbols,
    excludeAmbiguous,
    pronounceable,
    excludeCharacters,
    type,
    quantity,
  ];
}

class GeneratedPassword extends Equatable {
  final String password;
  final PasswordStrength strength;
  final double entropyBits;
  final PasswordSettings settings;
  final DateTime generatedAt;

  const GeneratedPassword({
    required this.password,
    required this.strength,
    required this.entropyBits,
    required this.settings,
    required this.generatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'strength': strength.index,
      'entropyBits': entropyBits,
      'settings': settings.toJson(),
      'generatedAt': generatedAt.toIso8601String(),
    };
  }

  factory GeneratedPassword.fromJson(Map<String, dynamic> json) {
    return GeneratedPassword(
      password: json['password'] as String,
      strength: PasswordStrength.values[json['strength'] as int],
      entropyBits: json['entropyBits'] as double,
      settings: PasswordSettings.fromJson(json['settings'] as Map<String, dynamic>),
      generatedAt: DateTime.parse(json['generatedAt'] as String),
    );
  }

  @override
  List<Object> get props => [password, strength, entropyBits, settings, generatedAt];

  get strengthDisplayName => null;
}