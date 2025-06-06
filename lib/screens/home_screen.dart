import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../provider/password_provider.dart';
import '../utils/colors.dart';
import '../utils/app_navigator.dart';
import '../widgets/custom_button.dart';
import '../widgets/password_strength_indicator.dart';
import '../widgets/gradient_background.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Consumer<PasswordProvider>(
            builder: (context, passwordProvider, child) {
              final lastGenerated = passwordProvider.lastGenerated;
              final isGenerating = passwordProvider.isGenerating;

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'SecureGen',
                          style: GoogleFonts.poppins(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.history),
                              onPressed: () => AppNavigator.pushNamed('/history'),
                            ),
                            IconButton(
                              icon: const Icon(Icons.settings),
                              onPressed: () => AppNavigator.pushNamed('/settings'),
                            ),
                            IconButton(
                              icon: const Icon(Icons.group),
                              onPressed: () => AppNavigator.pushNamed('/team'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // Password Display Card
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          gradient: Theme.of(context).brightness == Brightness.dark
                              ? AppGradients.cardDark
                              : AppGradients.cardLight,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          children: [
                            Text(
                              lastGenerated?.password ?? 'Click generate to create password',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 18.sp,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10.h),
                            if (lastGenerated != null) ...[
                              PasswordStrengthIndicator(
                                strength: lastGenerated.strength,
                                entropyBits: lastGenerated.entropyBits,
                              ),
                              SizedBox(height: 10.h),
                              CustomButton(
                                text: 'Copy',
                                icon: Icons.copy,
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: lastGenerated.password));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Password copied to clipboard')),
                                  );
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Settings Section
                    Text(
                      'Password Settings',
                      style: GoogleFonts.poppins(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    // Length Slider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Length: ${passwordProvider.settings.length}',
                            style: GoogleFonts.inter(fontSize: 14.sp)),
                        Slider(
                          value: passwordProvider.settings.length.toDouble(),
                          min: 4,
                          max: 128,
                          divisions: 124,
                          onChanged: (value) =>
                              passwordProvider.updateLength(value.toInt()),
                        ),
                      ],
                    ),
                    // Character Toggles
                    Wrap(
                      spacing: 10.w,
                      runSpacing: 10.h,
                      children: [
                        _buildToggleChip(
                          context,
                          label: 'Uppercase',
                          value: passwordProvider.settings.includeUppercase,
                          onTap: () => passwordProvider.toggleUppercase(),
                        ),
                        _buildToggleChip(
                          context,
                          label: 'Lowercase',
                          value: passwordProvider.settings.includeLowercase,
                          onTap: () => passwordProvider.toggleLowercase(),
                        ),
                        _buildToggleChip(
                          context,
                          label: 'Numbers',
                          value: passwordProvider.settings.includeNumbers,
                          onTap: () => passwordProvider.toggleNumbers(),
                        ),
                        _buildToggleChip(
                          context,
                          label: 'Symbols',
                          value: passwordProvider.settings.includeSymbols,
                          onTap: () => passwordProvider.toggleSymbols(),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    // Generate Button
                    Center(
                      child: CustomButton(
                        text: isGenerating ? 'Generating...' : 'Generate Password',
                        icon: Icons.lock,
                        onPressed: isGenerating ? null : passwordProvider.generatePasswords,
                        gradient: AppColors.primaryGradient,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildToggleChip(BuildContext context, {required String label, required bool value, required VoidCallback onTap}) {
    return ChoiceChip(
      label: Text(label, style: GoogleFonts.inter(fontSize: 14.sp)),
      selected: value,
      onSelected: (selected) => onTap(),
      selectedColor: AppColors.primaryBlue.withOpacity(0.2),
      backgroundColor: Theme.of(context).colorScheme.surface,
      labelStyle: TextStyle(
        color: value ? AppColors.primaryBlue : Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}