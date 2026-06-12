import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// =============================================================================
// Module: Theme (UI)
// Responsabilité: Thèmes clair / sombre professionnels Material 3
// =============================================================================

abstract final class AppTheme {
  // Premium Finance App Primary Colors
  static const _seedLight = Color(0xFF2563EB); // Royal Blue
  static const _seedDark = Color(0xFF3B82F6);  // Lighter Blue for Dark Mode
  
  static const incomeColor = Color(0xFF10B981); // Emerald Green
  static const expenseColor = Color(0xFFEF4444); // Red

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final seed = isLight ? _seedLight : _seedDark;

    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
      primary: seed,
      surface: isLight ? const Color(0xFFFFFFFF) : const Color(0xFF1E293B), // White / Slate 800
      surfaceContainerHighest: isLight ? const Color(0xFFF1F5F9) : const Color(0xFF334155),
      onSurface: isLight ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
    );

    final radius = BorderRadius.circular(16);
    final inputBorder = OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: scheme.outlineVariant),
    );

    // Apply Google Fonts (Outfit or Inter are great for finance apps)
    final textTheme = GoogleFonts.outfitTextTheme(
      ThemeData(brightness: brightness).textTheme,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: isLight ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: isLight ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
        foregroundColor: scheme.onSurface,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
        iconTheme: IconThemeData(color: scheme.onSurface),
      ),
      cardTheme: CardThemeData(
        elevation: isLight ? 4 : 0,
        shadowColor: isLight ? Colors.black.withValues(alpha: 0.05) : Colors.transparent,
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: isLight ? Colors.transparent : scheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 4,
        highlightElevation: 8,
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 72,
        backgroundColor: scheme.surface,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        indicatorColor: scheme.primaryContainer,
        labelTextStyle: WidgetStatePropertyAll(
          GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight ? const Color(0xFFF1F5F9) : const Color(0xFF1E293B),
        border: inputBorder,
        enabledBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: scheme.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        labelStyle: GoogleFonts.outfit(
          color: isLight ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
        ),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
