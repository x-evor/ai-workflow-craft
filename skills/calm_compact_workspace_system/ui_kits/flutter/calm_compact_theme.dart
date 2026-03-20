import 'package:flutter/material.dart';

class CalmCompactTheme {
  static const Color bgPrimary = Color(0xFFFFFFFF);
  static const Color bgSecondary = Color(0xFFF3F4F6);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFF3F4F6);
  static const Color border = Color(0xFFE9EBEF);
  static const Color hoverSurface = Color(0xFFEDEFF3);
  static const Color textPrimary = Color(0xFF1C1B1F);
  static const Color textSecondary = Color(0xFF667085);
  static const Color textInactive = Color(0xFF98A1B2);
  static const Color textSurfaceVariant = Color(0xFF49454F);
  static const Color accentPrimary = Color(0xFF5C6BC0);
  static const Color accentPrimarySoft = Color(0xFFE8EAF6);
  static const Color accentPositive = Color(0xFF3E8F5A);
  static const Color accentWarning = Color(0xFFBF8A3A);
  static const Color accentError = Color(0xFFC3655C);
  static const Color accentDownload = Color(0xFF5B8DEF);
  static const Color accentUpload = Color(0xFFDA6A87);
  static const Color warningBannerBackground = Color(0xFFFFF3CD);
  static const Color warningBannerBorder = Color(0xFFFFE69C);
  static const Color warningBannerText = Color(0xFF664D03);
  static const Color darkBackground = Color(0xFF141422);
  static const Color darkSurface = Color(0xFF141422);
  static const Color darkSurfaceAlt = Color(0xFF1E1E2E);
  static const Color darkBorder = Color(0xFF383850);
  static const Color darkTextPrimary = Color(0xFFE6E1E5);
  static const Color darkTextSecondary = Color(0xFFB0B8C8);
  static const Color darkTextInactive = Color(0xFF8B95A8);
  static const Color darkTextSurfaceVariant = Color(0xFFCAC4D0);
  static const Color darkAccentPrimary = Color(0xFF9FA8DA);
  static const Color darkAccentPositive = Color(0xFF5CB978);
  static const Color darkAccentWarning = Color(0xFFE0AE5A);
  static const Color darkAccentError = Color(0xFFEF9A9A);
  static const Color darkAccentDownload = Color(0xFF82AAFF);
  static const Color darkAccentUpload = Color(0xFFEF9AAF);

  static const Duration motionFast = Duration(milliseconds: 120);
  static const Duration motionDefault = Duration(milliseconds: 180);
  static const Duration motionSlow = Duration(milliseconds: 240);
  static const Curve motionCurve = Curves.easeInOut;

  static const double buttonHeight = 28;
  static const double buttonRadius = 8;
  static const double compactRadius = 6;
  static const double cardRadius = 6;
  static const double panelRadius = 5;
  static const double pillRadius = 8;
  static const double iconSize = 24;

  static const BoxShadow cardShadow = BoxShadow(color: Color(0x00000000));

  static const BoxShadow controlShadow = BoxShadow(color: Color(0x00000000));

  static const TextStyle display = TextStyle(
    fontSize: 28,
    height: 32 / 28,
    fontWeight: FontWeight.w700,
    color: textPrimary,
  );

  static const TextStyle statusHeading = TextStyle(
    fontSize: 24,
    height: 28 / 24,
    fontWeight: FontWeight.w700,
    color: textPrimary,
  );

  static const TextStyle title = TextStyle(
    fontSize: 20,
    height: 24 / 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle section = TextStyle(
    fontSize: 13,
    height: 14 / 13,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle appTitle = TextStyle(
    fontSize: 13,
    height: 14 / 13,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle bodyStrong = TextStyle(
    fontSize: 13,
    height: 14 / 13,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 13,
    height: 15 / 13,
    fontWeight: FontWeight.w400,
    color: textPrimary,
  );

  static const TextStyle bodyCompact = TextStyle(
    fontSize: 13,
    height: 15 / 13,
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );

  static const TextStyle captionStrong = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle metricHero = TextStyle(
    fontSize: 30,
    height: 1,
    fontWeight: FontWeight.w700,
    color: textPrimary,
  );

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: accentPrimary,
      scaffoldBackgroundColor: bgPrimary,
      textTheme: const TextTheme(
        headlineMedium: display,
        headlineSmall: statusHeading,
        titleLarge: title,
        titleMedium: section,
        titleSmall: appTitle,
        bodyLarge: bodyStrong,
        bodyMedium: body,
        bodySmall: bodyCompact,
        labelLarge: appTitle,
        labelMedium: captionStrong,
        labelSmall: caption,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: accentPrimary,
        brightness: Brightness.light,
      ).copyWith(
        primary: accentPrimary,
        surface: surface,
        onSurface: textPrimary,
        outlineVariant: border,
      ),
    );
  }
}
