import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/team_credits_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/history_screen.dart';
import 'theme/theme_provider.dart';
import 'provider/password_provider.dart';
import 'utils/app_navigator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone 12 Pro size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => PasswordProvider()),
          ],
          child: Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp(
                title: 'SecureGen',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeProvider.themeMode,
                navigatorKey: AppNavigator.navigatorKey,
                home: const SplashScreen(),
                routes: {
                  '/splash': (context) => const SplashScreen(),
                  '/team': (context) => const TeamCreditsScreen(),
                  '/home': (context) => const HomeScreen(),
                  '/settings': (context) => const SettingsScreen(),
                  '/history': (context) => const HistoryScreen(),
                },
              );
            },
          ),
        );
      },
    );
  }
}