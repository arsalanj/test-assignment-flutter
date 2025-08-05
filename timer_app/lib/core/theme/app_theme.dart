import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: Colors.grey,
        onSecondary: Colors.white,
        secondaryContainer: Colors.grey,
        onSecondaryContainer: Colors.black,
        error: Colors.red,
        onError: Colors.white,
        errorContainer: Colors.redAccent,
        onErrorContainer: Colors.black,
        background: AppColors.background,
        onBackground: AppColors.onBackground,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
      ),
      textTheme: const TextTheme(
        headlineLarge: AppTextStyles.headlineLarge,
      ),
    );
  }
}
