import 'package:flutter/material.dart';

import 'calm_compact_theme.dart';

enum MetricState { normal, warning, error, positive }

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    this.trend,
    this.state = MetricState.normal,
  });

  final String label;
  final String value;
  final String? trend;
  final MetricState state;

  Color _accentForState() {
    switch (state) {
      case MetricState.warning:
        return CalmCompactTheme.accentWarning;
      case MetricState.error:
        return CalmCompactTheme.accentError;
      case MetricState.positive:
        return CalmCompactTheme.accentPositive;
      default:
        return CalmCompactTheme.textInactive;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CalmCompactTheme.surface,
        borderRadius: BorderRadius.circular(CalmCompactTheme.cardRadius),
        boxShadow: const [CalmCompactTheme.cardShadow],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state != MetricState.normal) ...[
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _accentForState(),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label,
                  style: CalmCompactTheme.caption,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: CalmCompactTheme.title,
          ),
          if (trend != null)
            Text(
              trend!,
              style: CalmCompactTheme.caption,
            ),
        ],
      ),
    );
  }
}
