# Flutter Calm Compact Workspace Kit

This directory provides a minimal Flutter starter kit aligned with the root [SKILL.md](../../SKILL.md) specification.

## Files

- `calm_compact_theme.dart` – Shared color, type, border, and timing tokens.
- `soft_button.dart` – A 40px tactile button with hover, press, and focus behavior.
- `soft_card.dart` – A 16px surface card with soft shadow and no border.
- `metric_card.dart` – Compact metric card following the calm hierarchy rules.
- `pill_navigation.dart` – Pill navigation using outline -> filled state shifts.
- `soft_brand_logo.dart` – Brand logo widget with `icon`, `wordmark`, and `hero` variants.

The kit uses `Console` as a neutral placeholder wordmark. Replace it in downstream products instead of changing the design-system default.

## Usage example

```dart
import 'package:flutter/material.dart';
import 'ui_kits/flutter/soft_brand_logo.dart';
import 'ui_kits/flutter/calm_compact_theme.dart';
import 'ui_kits/flutter/soft_button.dart';
import 'ui_kits/flutter/soft_card.dart';
import 'ui_kits/flutter/metric_card.dart';
import 'ui_kits/flutter/pill_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _selected = 'overview';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CalmCompactTheme.light(),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SoftBrandLogo(
                variant: SoftBrandLogoVariant.wordmark,
                state: SoftBrandLogoState.outline,
              ),
              const SizedBox(height: 24),
              PillNavigation(
                items: const [
                  PillNavItem(
                    key: 'overview',
                    label: 'Overview',
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home_rounded,
                  ),
                  PillNavItem(
                    key: 'details',
                    label: 'Details',
                    icon: Icons.grid_view_outlined,
                    activeIcon: Icons.grid_view_rounded,
                  ),
                ],
                selectedKey: _selected,
                onSelect: (key) => setState(() => _selected = key),
              ),
              const SizedBox(height: 24),
              Row(
                children: const [
                  MetricCard(label: 'Connection Stability', value: '98%', state: MetricState.positive, trend: '↑ 4%'),
                  SizedBox(width: 12),
                  MetricCard(label: 'Access Readiness', value: '42 ms', state: MetricState.warning),
                ],
              ),
              const SizedBox(height: 24),
              const SoftCard(
                child: Text('Waiting mostly occurred before loading began.'),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  SoftButton(onPressed: () {}, child: const Text('Action')),
                  const SizedBox(width: 12),
                  const SoftButton(primary: true, onPressed: null, child: Text('Primary')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

Use this kit as a starting point. Keep the final product aligned with `SKILL.md`, especially the typography, state-shape, logo, and interaction rules.
