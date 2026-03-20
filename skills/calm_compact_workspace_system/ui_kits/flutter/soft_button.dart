import 'package:flutter/material.dart';

import 'calm_compact_theme.dart';

class SoftButton extends StatefulWidget {
  const SoftButton({
    super.key,
    required this.child,
    this.onPressed,
    this.primary = false,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool primary;

  @override
  State<SoftButton> createState() => _SoftButtonState();
}

class _SoftButtonState extends State<SoftButton> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final background = widget.primary
        ? CalmCompactTheme.accentPrimary
        : (_hovered ? CalmCompactTheme.hoverSurface : CalmCompactTheme.surfaceAlt);
    final foreground = widget.primary ? Colors.white : CalmCompactTheme.textPrimary;
    final scale = _pressed
        ? 0.98
        : _focused
        ? 1.02
        : 1.0;

    return FocusableActionDetector(
      onShowFocusHighlight: (focused) => setState(() => _focused = focused),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() {
          _hovered = false;
          _pressed = false;
        }),
        child: GestureDetector(
          onTapDown: widget.onPressed == null
              ? null
              : (_) => setState(() => _pressed = true),
          onTapUp: widget.onPressed == null
              ? null
              : (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: widget.onPressed,
          child: AnimatedScale(
            scale: scale,
            duration: CalmCompactTheme.motionDefault,
            curve: CalmCompactTheme.motionCurve,
            child: AnimatedContainer(
              duration: CalmCompactTheme.motionDefault,
              curve: CalmCompactTheme.motionCurve,
              constraints: const BoxConstraints(minHeight: 40),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(
                  CalmCompactTheme.buttonRadius,
                ),
                border: widget.primary
                    ? null
                    : Border.all(color: CalmCompactTheme.border),
                boxShadow: [
                  if (!_pressed) CalmCompactTheme.controlShadow,
                  if (_pressed)
                    const BoxShadow(
                      color: Color(0x14000000),
                      offset: Offset(0, 1),
                      blurRadius: 2,
                      spreadRadius: -1,
                    ),
                ],
              ),
              child: DefaultTextStyle(
                style: CalmCompactTheme.body.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w600,
                ),
                child: IconTheme(
                  data: IconThemeData(color: foreground, size: 18),
                  child: Center(child: widget.child),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
