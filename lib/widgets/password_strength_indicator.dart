import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/password_settings.dart';
import '../utils/colors.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final PasswordStrength strength;
  final double entropyBits;

  const PasswordStrengthIndicator({
    super.key,
    required this.strength,
    required this.entropyBits,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Strength: ${strength.strengthDisplayName}',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: _getStrengthColor(strength),
          ),
        ),
        SizedBox(height: 8.h),
        LinearProgressIndicator(
          value: strength.strengthScore,
          backgroundColor: AppColors.lightBorder,
          valueColor: AlwaysStoppedAnimation(_getStrengthColor(strength)),
          minHeight: 8.h,
          borderRadius: BorderRadius.circular(4.r),
        ),
        SizedBox(height: 8.h),
        Text(
          'Entropy: ${entropyBits.toStringAsFixed(1)} bits',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Color _getStrengthColor(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.veryWeak:
      case PasswordStrength.weak:
        return AppColors.weak;
      case PasswordStrength.fair:
        return AppColors.fair;
      case PasswordStrength.good:
        return AppColors.good;
      case PasswordStrength.strong:
      case PasswordStrength.veryStrong:
        return AppColors.veryStrong;
    }
  }
}