import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// IGNITE design language — "Ember"
/// Heat-therapy brand: ember orange-red primary, medical teal secondary,
/// clean clinical neutrals. Session screen uses a dark "focus" theme.
class AppColors {
  AppColors._();

  // Brand
  static const ember = Color(0xFFF04E23);
  static const emberDeep = Color(0xFFC63D15);
  static const emberSoft = Color(0xFFFEECE6);
  static const teal = Color(0xFF0E9DA4);
  static const tealSoft = Color(0xFFE0F5F6);

  // Neutrals
  static const ink = Color(0xFF101828);
  static const slate = Color(0xFF475467);
  static const muted = Color(0xFF98A2B3);
  static const line = Color(0xFFE4E7EC);
  static const bg = Color(0xFFF6F7F9);
  static const surface = Colors.white;

  // Signals
  static const success = Color(0xFF12B76A);
  static const successSoft = Color(0xFFE7F8F0);
  static const warning = Color(0xFFF59E0B);
  static const warningSoft = Color(0xFFFEF4E6);
  static const danger = Color(0xFFD92D20);
  static const dangerSoft = Color(0xFFFDECEA);

  // Dark (session focus mode)
  static const darkBg = Color(0xFF0E1116);
  static const darkCard = Color(0xFF181D25);
  static const darkLine = Color(0xFF2A313C);
  static const darkText = Color(0xFFE9EDF3);
  static const darkMuted = Color(0xFF8B94A3);

  /// Heat ramp used for temperature/intensity visuals.
  static Color heat(double t) {
    // t: 0..1 (35°C..45°C)
    if (t < 0.33) return const Color(0xFFFFB74D);
    if (t < 0.66) return const Color(0xFFFF8A3C);
    if (t < 0.85) return ember;
    return danger;
  }

  static const emberGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF7A3D), ember, emberDeep],
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.ember,
        primary: AppColors.ember,
        secondary: AppColors.teal,
        surface: AppColors.surface,
        error: AppColors.danger,
      ),
      scaffoldBackgroundColor: AppColors.bg,
    );

    final text = GoogleFonts.figtreeTextTheme(base.textTheme).apply(
      bodyColor: AppColors.ink,
      displayColor: AppColors.ink,
    );

    return base.copyWith(
      textTheme: text,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bg,
        foregroundColor: AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 19,
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          side: BorderSide(color: AppColors.line),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.ember,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: text.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink,
          minimumSize: const Size.fromHeight(54),
          side: const BorderSide(color: AppColors.line, width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: text.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.ember,
          textStyle: text.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: text.bodyMedium?.copyWith(color: AppColors.muted),
        labelStyle: text.bodyMedium?.copyWith(color: AppColors.slate),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.ember, width: 1.6),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.emberSoft,
        height: 68,
        labelTextStyle: WidgetStatePropertyAll(
          text.labelSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? AppColors.emberDeep
                : AppColors.muted,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.line, thickness: 1),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.ink,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Dark theme used only by the live session "focus mode" screen.
  static ThemeData sessionDark() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.ember,
        brightness: Brightness.dark,
        primary: AppColors.ember,
        secondary: AppColors.teal,
        surface: AppColors.darkCard,
      ),
      scaffoldBackgroundColor: AppColors.darkBg,
    );
    final text = GoogleFonts.figtreeTextTheme(base.textTheme).apply(
      bodyColor: AppColors.darkText,
      displayColor: AppColors.darkText,
    );
    return base.copyWith(textTheme: text);
  }
}
