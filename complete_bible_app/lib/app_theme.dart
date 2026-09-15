import 'package:flutter/material.dart';

/// Deep forest green + warm gold accent, on warm "paper" neutrals.
/// Kept intentionally simple: no custom fonts, just refined Material 3
/// defaults with generous rounding and flatter, quieter surfaces.
class AppTheme {
  AppTheme._();

  static const Color _forest = Color(0xFF1F5D3A);
  static const Color _gold = Color(0xFFC08A2E);

  static const Color _paperLight = Color(0xFFF7F4EC);
  static const Color _paperDark = Color(0xFF15140F);

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final scheme = ColorScheme.fromSeed(
      seedColor: _forest,
      brightness: brightness,
      secondary: _gold,
    ).copyWith(
      surface: isDark ? _paperDark : _paperLight,
      surfaceContainerHighest: isDark
          ? const Color(0xFF221F17)
          : const Color(0xFFEDE8DA),
      surfaceContainerHigh: isDark
          ? const Color(0xFF1D1B14)
          : const Color(0xFFF1EDE1),
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      fontFamily: 'Roboto',
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        headlineSmall: base.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        titleLarge: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        titleMedium: base.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        titleSmall: base.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: scheme.onSurface,
        centerTitle: false,
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
          color: scheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withValues(alpha: 0.5),
        space: 24,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          backgroundColor: scheme.surfaceContainerHighest,
          foregroundColor: scheme.onSurface,
          shape: const StadiumBorder(),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: scheme.primary, width: 1.6),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        circularTrackColor: scheme.surfaceContainerHighest,
        linearTrackColor: scheme.surfaceContainerHighest,
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: scheme.surfaceContainerHighest,
        shape: const StadiumBorder(),
        side: BorderSide.none,
        labelStyle: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
