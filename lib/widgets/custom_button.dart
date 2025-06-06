import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final LinearGradient? gradient;

  const CustomButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
      ).copyWith(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.lightBorder;
          }
          return null;
        }),
        foregroundColor: WidgetStateProperty.all(Colors.white),
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: gradient ?? AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20.sp),
                SizedBox(width: 8.w),
              ],
              Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}