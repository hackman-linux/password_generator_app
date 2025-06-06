import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../provider/password_provider.dart';
import '../models/password_settings.dart';
import '../utils/colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/gradient_background.dart';
import '../widgets/password_strength_indicator.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  PasswordStrength? _selectedStrength;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password History', style: GoogleFonts.poppins(fontSize: 20.sp)),
        centerTitle: true,
      ),
      body: GradientBackground(
        child: SafeArea(
          child: Consumer<PasswordProvider>(
            builder: (context, passwordProvider, child) {
              final history = _selectedStrength != null
                  ? passwordProvider.filterHistoryByStrength(_selectedStrength!)
                  : passwordProvider.history;

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  children: [
                    // Strength Filter
                    DropdownButtonFormField<PasswordStrength>(
                      value: _selectedStrength,
                      hint: Text('Filter by Strength', style: GoogleFonts.inter(fontSize: 14.sp)),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      items: [
                        DropdownMenuItem<PasswordStrength>(
                          value: null,
                          child: Text('All', style: GoogleFonts.inter(fontSize: 14.sp)),
                        ),
                        ...PasswordStrength.values.map((strength) => DropdownMenuItem(
                          value: strength,
                          child: Text(strength.strengthDisplayName, style: GoogleFonts.inter(fontSize: 14.sp)),
                        )),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedStrength = value;
                        });
                      },
                    ),
                    SizedBox(height: 20.h),
                    // Action Buttons
                    if (history.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomButton(
                            text: 'Clear History',
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
                          CustomButton(
                            text: 'Export History',
                            icon: Icons.share,
                            onPressed: () async {
                              await passwordProvider.exportPasswords(context);
                            },
                            gradient: AppColors.primaryGradient,
                          ),
                        ],
                      ),
                    SizedBox(height: 20.h),
                    // History List
                    Expanded(
                      child: history.isEmpty
                          ? Center(
                        child: Text(
                          'No passwords in history',
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      )
                          : ListView.builder(
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                          final password = history[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: Card(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      password.password,
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 16.sp,
                                        color: Theme.of(context).colorScheme.onSurface,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    PasswordStrengthIndicator(
                                      strength: password.strength,
                                      entropyBits: password.entropyBits,
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Generated: ${password.generatedAt.toString().split('.')[0]}',
                                      style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.copy, size: 20),
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(text: password.password));
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Password copied')),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, size: 20, color: AppColors.error),
                                          onPressed: () async {
                                            await passwordProvider.removeFromHistory(password);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Password removed')),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
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