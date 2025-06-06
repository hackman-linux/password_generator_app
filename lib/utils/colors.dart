import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryBlue = Color(0xFF6C63FF);
  static const Color primaryPurple = Color(0xFF9C27B0);
  static const Color secondaryRed = Color(0xFFFF6B6B);
  static const Color secondaryRedDark = Color(0xFFFF8A80);

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF1A202C);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightBorder = Color(0xFFE2E8F0);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkText = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF334155);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, primaryPurple],
  );

  static const LinearGradient primaryGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8B7CF6), Color(0xFFD946EF)],
  );

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Password Strength Colors
  static const Color weak = Color(0xFFEF4444);
  static const Color fair = Color(0xFFF59E0B);
  static const Color good = Color(0xFF10B981);
  static const Color strong = Color(0xFF059669);
  static const Color veryStrong = Color(0xFF047857);

  // Glass Effect Colors
  static Color glassLight = Colors.white.withOpacity(0.25);
  static Color glassDark = Colors.white.withOpacity(0.1);

  // Shadow Colors
  static Color lightShadow = Colors.black.withOpacity(0.1);
  static Color darkShadow = Colors.black.withOpacity(0.3);
}

class AppGradients {
  static const LinearGradient backgroundLight = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFF8FAFC),
      Color(0xFFEDF2F7),
    ],
  );

  static const LinearGradient backgroundDark = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0F172A),
      Color(0xFF1E293B),
    ],
  );

  static const LinearGradient cardLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFF8FAFC),
    ],
  );

  static const LinearGradient cardDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E293B),
      Color(0xFF0F172A),
    ],
  );
}

class AppShadows {
  static List<BoxShadow> lightShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 10,
      offset: const Offset(0, 5),
    ),
  ];

  static List<BoxShadow> darkShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 10,
      offset: const Offset(0, 5),
    ),
  ];

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: AppColors.primaryBlue.withOpacity(0.1),
      blurRadius: 15,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: AppColors.primaryBlue.withOpacity(0.3),
      blurRadius: 10,
      offset: const Offset(0, 5),
    ),
  ];
}