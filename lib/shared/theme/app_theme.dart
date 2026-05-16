import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leave_management_app/core/constants/app_colors.dart';
import 'package:leave_management_app/core/constants/app_text_styles.dart';


/// Material 3 theme built to match the HTML template design.
class AppTheme {
  AppTheme._();

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _colorScheme,
      scaffoldBackgroundColor: AppColors.scaffoldBackground,
      fontFamily: 'Inter',
      appBarTheme: _appBarTheme,
      cardTheme: _cardTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
      bottomNavigationBarTheme: _bottomNavTheme,
      dividerTheme: _dividerTheme,
      chipTheme: _chipTheme,
      textTheme: _textTheme,
    );
  }

  // ── Color Scheme ─────────────────────────────────────────────────
  static const ColorScheme _colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.textOnPrimary,
    primaryContainer: AppColors.primarySubtle,
    onPrimaryContainer: AppColors.primaryText,
    secondary: AppColors.primaryLight,
    onSecondary: AppColors.textOnPrimary,
    secondaryContainer: AppColors.annualBackground,
    onSecondaryContainer: AppColors.annualDays,
    tertiary: AppColors.pending,
    onTertiary: AppColors.textOnPrimary,
    tertiaryContainer: AppColors.pendingBackground,
    onTertiaryContainer: AppColors.pendingText,
    error: AppColors.rejected,
    onError: AppColors.textOnPrimary,
    errorContainer: AppColors.rejectedBackground,
    onErrorContainer: AppColors.rejectedText,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    surfaceContainerHighest: AppColors.scaffoldBackground,
    onSurfaceVariant: AppColors.textSecondary,
    outline: AppColors.border,
    outlineVariant: AppColors.borderLight,
    shadow: Colors.black12,
    scrim: Colors.black54,
    inverseSurface: AppColors.textPrimary,
    onInverseSurface: AppColors.textOnPrimary,
    inversePrimary: AppColors.primarySubtle,
  );

  // ── AppBar ───────────────────────────────────────────────────────
  static final AppBarTheme _appBarTheme = AppBarTheme(
    backgroundColor: AppColors.topBar,
    foregroundColor: AppColors.textOnPrimary,
    elevation: 0,
    scrolledUnderElevation: 0,
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: AppColors.topBar,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
    titleTextStyle: AppTextStyles.topBarTitle,
    iconTheme: const IconThemeData(color: AppColors.textOnPrimary),
    actionsIconTheme: const IconThemeData(color: AppColors.textOnPrimary),
  );

  // ── Card ─────────────────────────────────────────────────────────
  static final CardThemeData _cardTheme = CardThemeData(
    color: AppColors.surface,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: const BorderSide(color: AppColors.border, width: 0.5),
    ),
    margin: EdgeInsets.zero,
    clipBehavior: Clip.antiAlias,
  );

  // ── Elevated Button (primary submit) ─────────────────────────────
  static final ElevatedButtonThemeData _elevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textOnPrimary,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      minimumSize: const Size.fromHeight(46),
      textStyle: AppTextStyles.submitButton,
    ),
  );

  // ── Outlined Button ──────────────────────────────────────────────
  static final OutlinedButtonThemeData _outlinedButtonTheme =
      OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: const BorderSide(color: AppColors.border, width: 0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: AppTextStyles.formInput,
    ),
  );

  // ── Input Decoration ─────────────────────────────────────────────
  static final InputDecorationTheme _inputDecorationTheme =
      InputDecorationTheme(
    filled: true,
    fillColor: AppColors.scaffoldBackground,
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.border, width: 0.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.border, width: 0.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.primary, width: 1),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.rejected, width: 0.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.rejected, width: 1),
    ),
    hintStyle: AppTextStyles.formHint,
    labelStyle: AppTextStyles.formLabel,
    errorStyle: const TextStyle(fontSize: 10, color: AppColors.rejectedText),
  );

  // ── Bottom Navigation Bar ────────────────────────────────────────
  static final BottomNavigationBarThemeData _bottomNavTheme =
      BottomNavigationBarThemeData(
    backgroundColor: AppColors.surface,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.textDisabled,
    elevation: 0,
    type: BottomNavigationBarType.fixed,
    selectedLabelStyle: AppTextStyles.bottomNavLabelActive,
    unselectedLabelStyle: AppTextStyles.bottomNavLabel,
    showSelectedLabels: true,
    showUnselectedLabels: true,
  );

  // ── Divider ──────────────────────────────────────────────────────
  static const DividerThemeData _dividerTheme = DividerThemeData(
    color: AppColors.borderLight,
    thickness: 0.5,
    space: 0,
  );

  // ── Chip ─────────────────────────────────────────────────────────
  static ChipThemeData get _chipTheme => ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primarySubtle,
        labelStyle: AppTextStyles.formLabel,
        side: const BorderSide(color: AppColors.border, width: 0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      );

  // ── Text Theme ───────────────────────────────────────────────────
  static const TextTheme _textTheme = TextTheme(
    titleLarge: AppTextStyles.topBarTitle,
    titleMedium: AppTextStyles.cardTitle,
    bodyLarge: AppTextStyles.leaveItemTitle,
    bodyMedium: AppTextStyles.leaveItemDate,
    bodySmall: AppTextStyles.statusPill,
    labelLarge: AppTextStyles.submitButton,
    labelMedium: AppTextStyles.formLabel,
    labelSmall: AppTextStyles.bottomNavLabel,
  );
}
