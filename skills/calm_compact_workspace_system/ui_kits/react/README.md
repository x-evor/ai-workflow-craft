# React Soft Tactile UI Kit

This directory contains a lightweight React starter kit aligned with the root [SKILL.md](../../SKILL.md) specification.

The kit uses `Console` as a neutral placeholder wordmark. Replace it in downstream products instead of baking a product name into the design-system default.

## Usage

1. Copy the `ui_kits/react` directory into your project.
2. Install React and its peer dependencies if you haven't already.
3. Import components and theme values from the kit:

```tsx
import React from 'react';
import {
  BrandLogo,
  Button,
  Card,
  MetricCard,
  PillNavigation,
  colors,
} from './ui_kits/react';

function Example() {
  const [selected, setSelected] = React.useState('overview');
  return (
    <div style={{ padding: 32, backgroundColor: colors.bgPrimary }}>
      <BrandLogo variant="wordmark" state="outline" />
      <div style={{ height: 24 }} />
      <PillNavigation
        items={[
          {
            key: 'overview',
            label: 'Overview',
            icon: <span>⌂</span>,
            activeIcon: <span>◼</span>,
          },
          {
            key: 'detail',
            label: 'Detail',
            icon: <span>◎</span>,
            activeIcon: <span>●</span>,
          },
        ]}
        selectedKey={selected}
        onSelect={setSelected}
      />
      <div style={{ marginTop: 24, display: 'flex', gap: 12 }}>
        <MetricCard label="Connection Stability" value="98%" state="positive" trend="↑ 4%" />
        <MetricCard label="Access Readiness" value="42 ms" state="warning" />
      </div>
      <div style={{ marginTop: 24 }}>
        <Card>
          <h2 style={{ marginTop: 0 }}>AI Insight</h2>
          <p>Waiting mostly occurred before loading began.</p>
        </Card>
      </div>
      <div style={{ marginTop: 24 }}>
        <Button onClick={() => alert('Clicked!')}>Action</Button>
        <Button variant="primary" onClick={() => alert('Primary!')} style={{ marginLeft: 12 }}>
          Primary
        </Button>
      </div>
    </div>
  );
}

export default Example;
```

The kit includes the following components:

- `Button` – A pressable button with soft shadows and a scale animation.
- `Card` – A container with rounded corners and a subtle shadow.
- `MetricCard` – A compact card for displaying a label, value and optional trend indicator, with colour coded states (`normal`, `warning`, `error`, `positive`).
- `PillNavigation` – A pill‑style navigation bar that emphasises the active item with a filled background.
- `BrandLogo` – A compact brand component with `icon`, `wordmark`, and `hero` variants.
- `theme.ts` – Exports colour tokens, type scale, radii, shadows, and motion definitions.

This kit is intentionally lightweight. Keep the final implementation aligned with `SKILL.md`, especially the typography, compact header, placeholder branding, logo, and state-shape rules.
