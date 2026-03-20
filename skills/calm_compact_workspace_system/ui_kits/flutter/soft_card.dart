import 'package:flutter/material.dart';

import 'calm_compact_theme.dart';

class SoftCard extends StatelessWidget {
  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CalmCompactTheme.surfaceAlt,
        borderRadius: BorderRadius.circular(CalmCompactTheme.cardRadius),
        border: Border.all(color: CalmCompactTheme.border),
        boxShadow: const [CalmCompactTheme.cardShadow],
      ),
      padding: padding,
      child: child,
    );
  }
}
