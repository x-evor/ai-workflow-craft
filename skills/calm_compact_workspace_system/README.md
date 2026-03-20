# calm_compact_workspace_system

The full specification lives in [SKILL.md](./SKILL.md).

## Quick Start

1. Read `SKILL.md`.
2. Start from `ui_kits/react` or `ui_kits/flutter`.
3. Replace the placeholder `Console` wordmark with your product brand only at implementation time.

## Positioning

This skill now combines two layers into one system:

- `calm_compact_workspace_system`: compact, tactile, system-native utility UI
- `The Intelligent Workspace`: editorial precision, tonal layering, asymmetrical breathing room, and cloud-neutral glass depth

The result is a single cross-platform design language for desktop apps, mobile apps, web apps, and product sites. The platform may change density and spacing, but it should not feel like a different brand on each surface.

## Priority Rules

Platform system fonts are still the default and preferred choice for this skill. Do not introduce a custom UI font unless the host product already requires one.

Current default workspace profile is `simple`: compact desktop typography, restrained controls, and soft utility surfaces. In the updated version, sectioning should prefer tonal separation first, then ghost borders, then explicit borders. Use it by default for utility-style apps unless the product explicitly calls for softer onboarding or showcase surfaces.

## North Star

- Structured but fluid
- Calm, touchable, and low-noise
- Editorial rather than generic SaaS
- One sensory language across desktop, mobile, and web

## What Changed

- Added the `Digital Architect` creative north star
- Added editorial precision and asymmetrical layout guidance
- Replaced purely border-first separation with tonal layering first and ghost borders second
- Added cloud-neutral glass and diffused shadow guidance for floating companion surfaces
- Updated the palette toward `#0058BD`, `#34A853`, `#8F4A00`, and `#F8F9FA`
- Formalized cross-platform consistency rules for app and website surfaces

## UI Kits

- `ui_kits/flutter`
  - `calm_compact_theme.dart`
  - `soft_button.dart`
  - `soft_card.dart`
  - `pill_navigation.dart`
  - `metric_card.dart`
  - `soft_brand_logo.dart`
- `ui_kits/react`
  - `theme.ts`
  - `components/Button.tsx`
  - `components/Card.tsx`
  - `components/MetricCard.tsx`
  - `components/PillNavigation.tsx`
  - `components/BrandLogo.tsx`

The kits should follow the shared token family and interaction language defined in `SKILL.md`: system-font-first typography, compact workspace defaults, tonal layering, ghost-border affordances, outline -> filled state changes, and a consistent companion-panel treatment across desktop, mobile, and web.
