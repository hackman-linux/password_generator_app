import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../provider/password_provider.dart';
import '../theme/theme_provider.dart';
import '../models/password_settings.dart';
import '../utils/colors.dart';
import '../utils/validators.dart';
import '../widgets/custom_button.dart';
import '../widgets/gradient_background.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _excludeCharsController = TextEditingController();

  @override
  void dispose() {
    _excludeCharsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: GoogleFonts.poppins(fontSize: 20.sp)),
        centerTitle: true,
      ),
      body: GradientBackground(
        child: SafeArea(
          child: Consumer2<PasswordProvider, ThemeProvider>(
            builder: (context, passwordProvider, themeProvider, child) {
              _excludeCharsController.text = passwordProvider.settings.excludeCharacters;

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Password Settings',
                      style: GoogleFonts.poppins(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    // Password Type Dropdown
                    DropdownButtonFormField<PasswordType>(
                      value: passwordProvider.settings.type,
                      decoration: InputDecoration(
                        labelText: 'Password Type',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      items: PasswordType.values
                          .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type.typeDisplayName, style: GoogleFonts.inter(fontSize: 14.sp)),
                      ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          final newSettings = passwordProvider.settings.copyWith(type: value);
                          final error = Validators.validateSettings(newSettings);
                          if (error != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(error)),
                            );
                          } else {
                            passwordProvider.updateType(value);
                          }
                        }
                      },
                    ),
                    SizedBox(height: 10.h),
                    // Exclude Ambiguous Characters
                    SwitchListTile(
                      title: Text('Exclude Ambiguous Characters', style: GoogleFonts.inter(fontSize: 14.sp)),
                      value: passwordProvider.settings.excludeAmbiguous,
                      onChanged: (value) {
                        final newSettings = passwordProvider.settings.copyWith(excludeAmbiguous: value);
                        final error = Validators.validateSettings(newSettings);
                        if (error != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error)),
                          );
                        } else {
                          passwordProvider.toggleAmbiguous();
                        }
                      },
                    ),
                    SizedBox(height: 10.h),
                    // Custom Exclude Characters
                    TextField(
                      controller: _excludeCharsController,
                      decoration: InputDecoration(
                        labelText: 'Exclude Characters',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      style: GoogleFonts.inter(fontSize: 14.sp),
                      onChanged: (value) {
                        final error = Validators.validateExcludeCharacters(value);
                        if (error != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error)),
                          );
                        } else {
                          final newSettings = passwordProvider.settings.copyWith(excludeCharacters: value);
                          final settingsError = Validators.validateSettings(newSettings);
                          if (settingsError != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(settingsError)),
                            );
                          } else {
                            passwordProvider.updateSettings(newSettings);
                          }
                        }
                      },
                    ),
                    SizedBox(height: 20.h),
                    // Theme Toggle
                    Text(
                      'Appearance',
                      style: GoogleFonts.poppins(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    ListTile(
                      title: Text('Theme', style: GoogleFonts.inter(fontSize: 14.sp)),
                      trailing: DropdownButton<ThemeMode>(
                        value: themeProvider.themeMode,
                        items: ThemeMode.values
                            .map((mode) => DropdownMenuItem(
                          value: mode,
                          child: Text(
                            mode == ThemeMode.system
                                ? 'System'
                                : mode == ThemeMode.light
                                ? 'Light'
                                : 'Dark',
                            style: GoogleFonts.inter(fontSize: 14.sp),
                          ),
                        ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            themeProvider.setThemeMode(value);
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // Clear History Button
                    CustomButton(
                      text: 'Clear Password History',
                      icon: Icons.delete,
                      onPressed: () async {
                        await passwordProvider.clearHistory();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('History cleared')),
                        );
                      },
                      gradient: LinearGradient(
                        colors: [AppColors.error, AppColors.error.withOpacity(0.8)],
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
}