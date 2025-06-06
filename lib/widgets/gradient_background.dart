import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../theme/theme_provider.dart';
import 'package:provider/provider.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      decoration: BoxDecoration(
        gradient: isDarkMode
            ? AppGradients.backgroundDark
            : AppGradients.backgroundLight,
      ),
      child: child,
    );
  }
}