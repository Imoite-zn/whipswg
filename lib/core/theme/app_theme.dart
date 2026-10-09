import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Background layers — carbon fiber inspired
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF141414);
  static const Color surfaceElevated = Color(0xFF1E1E1E);
  static const Color surfaceHighlight = Color(0xFF252525);
  static const Color cardBg = Color(0xFF181818);

  // Primary accent — racing red
  static const Color primary = Color(0xFFD62828);
  static const Color primaryDark = Color(0xFF991C1C);
  static const Color primaryLight = Color(0xFFFF4444);
  static const Color primaryGlow = Color(0x40D62828);

  // Secondary accent — liquid gold
  static const Color gold = Color(0xFFCFA94E);
  static const Color goldLight = Color(0xFFE8C46A);
  static const Color goldDark = Color(0xFF9C7A2E);
  static const Color goldGlow = Color(0x40CFA94E);

  // Text
  static const Color textPrimary = Color(0xFFF5F5F5);
  static const Color textSecondary = Color(0xFF9E9E9E);
  static const Color textMuted = Color(0xFF5C5C5C);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Borders & Dividers
  static const Color border = Color(0xFF2A2A2A);
  static const Color borderActive = Color(0xFFD62828);
  static const Color divider = Color(0xFF1F1F1F);

  // Status
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // Gradients
  static const Gradient primaryGradient = LinearGradient(
    colors: [Color(0xFFD62828), Color(0xFF7B1010)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient goldGradient = LinearGradient(
    colors: [Color(0xFFE8C46A), Color(0xFFCFA94E), Color(0xFF9C7A2E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient surfaceGradient = LinearGradient(
    colors: [Color(0xFF1E1E1E), Color(0xFF141414)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient carbonGradient = LinearGradient(
    colors: [Color(0xFF252525), Color(0xFF111111)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class AppTextStyles {
  static TextStyle _base(
    double size,
    FontWeight weight,
    Color color, {
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  // Display
  static TextStyle displayLarge = _base(
    48,
    FontWeight.w800,
    AppColors.textPrimary,
    letterSpacing: -1.5,
    height: 1.1,
  );
  static TextStyle displayMedium = _base(
    36,
    FontWeight.w700,
    AppColors.textPrimary,
    letterSpacing: -1.0,
    height: 1.1,
  );

  // Headlines
  static TextStyle headlineLarge = _base(
    28,
    FontWeight.w700,
    AppColors.textPrimary,
    letterSpacing: -0.5,
  );
  static TextStyle headlineMedium = _base(
    22,
    FontWeight.w700,
    AppColors.textPrimary,
    letterSpacing: -0.3,
  );
  static TextStyle headlineSmall = _base(
    18,
    FontWeight.w600,
    AppColors.textPrimary,
  );

  // Body
  static TextStyle bodyLarge = _base(
    16,
    FontWeight.w400,
    AppColors.textPrimary,
    height: 1.6,
  );
  static TextStyle bodyMedium = _base(
    14,
    FontWeight.w400,
    AppColors.textSecondary,
    height: 1.5,
  );
  static TextStyle bodySmall = _base(
    12,
    FontWeight.w400,
    AppColors.textMuted,
  );

  // Labels
  static TextStyle labelLarge = _base(
    14,
    FontWeight.w600,
    AppColors.textPrimary,
    letterSpacing: 0.8,
  );
  static TextStyle labelMedium = _base(
    12,
    FontWeight.w600,
    AppColors.textSecondary,
    letterSpacing: 0.6,
  );
  static TextStyle labelSmall = _base(
    10,
    FontWeight.w600,
    AppColors.textMuted,
    letterSpacing: 1.2,
  );

  // Accent (numbers, prices)
  static TextStyle accentLarge = GoogleFonts.rajdhani(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.gold,
    letterSpacing: 1.0,
  );
  static TextStyle accentMedium = GoogleFonts.rajdhani(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.gold,
    letterSpacing: 0.5,
  );
}

class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.gold,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.background,
        onSurface: AppColors.textPrimary,
        onError: AppColors.textOnPrimary,
        outline: AppColors.border,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: AppTextStyles.headlineSmall,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceElevated,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: AppTextStyles.bodyMedium,
        labelStyle: AppTextStyles.labelMedium,
        prefixIconColor: AppColors.textMuted,
        suffixIconColor: AppColors.textMuted,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: AppTextStyles.labelLarge.copyWith(
            letterSpacing: 1.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.gold,
          textStyle: AppTextStyles.labelMedium,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceElevated,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textPrimary,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
