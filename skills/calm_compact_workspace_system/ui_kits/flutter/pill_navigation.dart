import 'package:flutter/material.dart';

import 'calm_compact_theme.dart';

class PillNavItem {
  const PillNavItem({
    required this.key,
    required this.label,
    this.icon,
    this.activeIcon,
  });

  final String key;
  final String label;
  final IconData? icon;
  final IconData? activeIcon;
}

class PillNavigation extends StatelessWidget {
  const PillNavigation({
    super.key,
    required this.items,
    required this.selectedKey,
    required this.onSelect,
  });

  final List<PillNavItem> items;
  final String selectedKey;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CalmCompactTheme.surfaceAlt,
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [CalmCompactTheme.cardShadow],
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: items.map((item) {
          final active = item.key == selectedKey;
          final icon = active ? (item.activeIcon ?? item.icon) : item.icon;
          return Padding(
            padding: const EdgeInsets.only(right: 2),
            child: GestureDetector(
              onTap: () => onSelect(item.key),
              child: AnimatedContainer(
                duration: CalmCompactTheme.motionDefault,
                curve: CalmCompactTheme.motionCurve,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: active ? CalmCompactTheme.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: active ? const [CalmCompactTheme.controlShadow] : const [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        size: CalmCompactTheme.iconSize,
                        color: CalmCompactTheme.textPrimary,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      item.label,
                      style: CalmCompactTheme.body.copyWith(
                        color: active
                            ? CalmCompactTheme.textPrimary
                            : CalmCompactTheme.textSecondary,
                        fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
