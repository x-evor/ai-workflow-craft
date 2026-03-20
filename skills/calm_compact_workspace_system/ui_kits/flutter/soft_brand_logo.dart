import 'package:flutter/material.dart';

import 'calm_compact_theme.dart';

enum SoftBrandLogoVariant { icon, wordmark, hero }

enum SoftBrandLogoTheme { light, dark }

enum SoftBrandLogoState { outline, filled }

class SoftBrandLogo extends StatelessWidget {
  const SoftBrandLogo({
    super.key,
    this.variant = SoftBrandLogoVariant.icon,
    this.theme = SoftBrandLogoTheme.light,
    this.state = SoftBrandLogoState.outline,
    this.size = 40,
    this.wordmark = 'Console',
  });

  final SoftBrandLogoVariant variant;
  final SoftBrandLogoTheme theme;
  final SoftBrandLogoState state;
  final double size;
  final String wordmark;

  bool get _filled => state == SoftBrandLogoState.filled;

  Color get _ink => theme == SoftBrandLogoTheme.dark
      ? CalmCompactTheme.darkTextPrimary
      : CalmCompactTheme.textPrimary;

  Color get _accent => CalmCompactTheme.accentPrimary;

  Color get _surface => theme == SoftBrandLogoTheme.dark
      ? CalmCompactTheme.darkSurface
      : CalmCompactTheme.surface;

  @override
  Widget build(BuildContext context) {
    final icon = _SoftBrandIcon(
      size: size,
      filled: _filled,
      ink: _ink,
      accent: _accent,
      surface: _surface,
    );

    return switch (variant) {
      SoftBrandLogoVariant.icon => icon,
      SoftBrandLogoVariant.wordmark => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 10),
          Text(
            wordmark,
            style: TextStyle(
              fontSize: size * 0.42,
              height: 1.3,
              fontWeight: FontWeight.w600,
              color: _ink,
            ),
          ),
        ],
      ),
      SoftBrandLogoVariant.hero => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SoftBrandIcon(
            size: size * 1.28,
            filled: _filled,
            ink: _ink,
            accent: _accent,
            surface: _surface,
          ),
          const SizedBox(height: 12),
          Text(
            wordmark,
            style: TextStyle(
              fontSize: size * 0.56,
              height: 1.3,
              fontWeight: FontWeight.w600,
              color: _ink,
            ),
          ),
        ],
      ),
    };
  }
}

class _SoftBrandIcon extends StatelessWidget {
  const _SoftBrandIcon({
    required this.size,
    required this.filled,
    required this.ink,
    required this.accent,
    required this.surface,
  });

  final double size;
  final bool filled;
  final Color ink;
  final Color accent;
  final Color surface;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _SoftBrandIconPainter(
          filled: filled,
          ink: ink,
          accent: accent,
          surface: surface,
        ),
      ),
    );
  }
}

class _SoftBrandIconPainter extends CustomPainter {
  const _SoftBrandIconPainter({
    required this.filled,
    required this.ink,
    required this.accent,
    required this.surface,
  });

  final bool filled;
  final Color ink;
  final Color accent;
  final Color surface;

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.08;
    final outerRect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(size.width * 0.28),
    );
    final bodyPaint = Paint()
      ..color = filled ? ink : surface
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final accentPaint = Paint()
      ..color = accent
      ..style = PaintingStyle.fill;

    canvas.drawRRect(outerRect, bodyPaint);
    if (!filled) {
      canvas.drawRRect(outerRect, strokePaint);
    }

    final eyeRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.23,
        size.height * 0.34,
        size.width * 0.54,
        size.height * 0.24,
      ),
      Radius.circular(size.width * 0.12),
    );
    final eyePaint = Paint()
      ..color = filled ? surface.withValues(alpha: 0.94) : ink
      ..style = PaintingStyle.fill;
    canvas.drawRRect(eyeRect, eyePaint);

    final dotPaint = Paint()
      ..color = filled ? accent : surface
      ..style = PaintingStyle.fill;
    final leftDot = Offset(size.width * 0.41, size.height * 0.46);
    final rightDot = Offset(size.width * 0.59, size.height * 0.46);
    canvas.drawCircle(leftDot, size.width * 0.045, dotPaint);
    canvas.drawCircle(rightDot, size.width * 0.045, dotPaint);

    if (!filled) {
      canvas.drawCircle(
        Offset(size.width * 0.84, size.height * 0.2),
        size.width * 0.08,
        accentPaint,
      );
    } else {
      final accentRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.7,
          size.height * 0.08,
          size.width * 0.2,
          size.height * 0.2,
        ),
        Radius.circular(size.width * 0.1),
      );
      canvas.drawRRect(accentRect, accentPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SoftBrandIconPainter other) {
    return filled != other.filled ||
        ink != other.ink ||
        accent != other.accent ||
        surface != other.surface;
  }
}
