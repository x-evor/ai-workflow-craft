---
name: calm_compact_workspace_system
description: A design system for calm, compact desktop workspaces with system fonts, light tactile feedback, and border-first utility surfaces.
---

# calm_compact_workspace_system

## Description

A design system that combines minimal layout, soft lighting, and tactile interaction to create calm, touchable, AI-adaptive interfaces.

It now also incorporates the "Intelligent Workspace" direction: editorial precision, tonal layering, asymmetrical breathing room, and a cloud-neutral glass signature that can scale across desktop apps, mobile apps, and web products without fragmenting into separate visual systems.

## Use Case

- SaaS dashboards
- AI-driven interfaces
- mobile / desktop apps
- web apps and product sites
- system UI panels

## Priority Rules

- platform system fonts are the default and preferred choice across this skill
- do not introduce a custom UI font unless the host product already mandates one
- when implementation guidance conflicts with typography taste, prefer platform-native font rendering and consistency
- maintain one sensory language across desktop, mobile, and web; vary density and layout, not brand feeling
- if editorial styling conflicts with usability in a dense workspace, preserve compactness and clarity first

## Creative North Star

### The Digital Architect

- the interface should feel structured but fluid
- the product should read more like a premium technical journal than a generic SaaS dashboard
- hierarchy should come from typography, tone, spacing, and depth before decoration
- cross-platform outputs should feel like the same product family, not parallel redesigns

## Design Principles

### 1. Soft over sharp

- no hard borders
- use light and shadow instead
- keep surfaces calm, airy, and slightly lifted

### 2. Shape over color

- state change should prefer outline -> filled
- avoid relying on color switching to communicate state
- use color as support, not as the primary signal

### 3. Touchability

- every interactive element should feel pressable
- use subtle depth, light, and motion feedback
- make controls feel soft rather than rigid

### 4. Calm hierarchy

- low visual noise
- clear focus and spacing
- emphasize information with size and weight, not loud decoration

### 5. Adaptive UI

- layout responds to user intent
- AI can reconfigure UI
- overview, focus, compact, and insight states should feel like the same system

### 6. Editorial precision

- prefer breathing layouts over rigid dashboard grids
- allow asymmetry when it creates a clearer focal point
- use whitespace and tonal contrast to create reading rhythm
- avoid claustrophobic panel packing even in compact desktop modes

### 7. Tonal layering over hard separation

- first separate sections with tonal shifts and spacing
- use borders only when accessibility, affordance, or dense utility workflows require them
- when a border is needed, it should behave like a ghost border, low-opacity and easy to ignore
- shadows should be diffused and slightly tinted, never harsh neutral gray

## Typography

### Font Family

- Primary: platform system sans
- macOS / iOS: SF Pro / San Francisco
- Android: Roboto
- Windows: Segoe UI
- Linux / web fallback: system-ui, sans-serif
- Monospace: platform monospace for logs, tokens, and technical values only

### Rules

- platform system fonts take priority over any brand or stylistic font recommendation
- do not use large stacked hero titles inside product workspaces
- prefer platform-default font rendering over bundling a custom product font
- primary product UI should stay in the 12px to 18px range
- 20px to 30px is reserved for dialogs, login headers, and key status metrics
- default desktop workspace profile should stay tighter, usually between font-size * 1.07 and font-size * 1.2
- use font weight to emphasize important information instead of color
- avoid mixing multiple font families in the same interface
- keep navigation, chips, and metadata compact; most supporting text should be 12px or 13px
- use monospace only for logs, command snippets, technical IDs, or measurement readouts that benefit from fixed-width alignment
- default desktop workspaces should use the compact `simple` profile unless the host product explicitly needs a softer marketing or onboarding presentation
- sidebar section labels may use stronger tracking and uppercase treatment when that improves architectural wayfinding
- keep editorial tone through hierarchy and spacing, not by importing marketing typography into product UI

### Type Scale

| Usage | Font Size | Line Height | Weight | Notes |
| --- | --- | --- | --- | --- |
| Metric Hero | 30px | 30px | 700 | Primary live metrics only |
| Display | 28px | 32px | 700 | Login / onboarding heading |
| Status Heading | 24px | 28px | 700 | Connection state / key status |
| Dialog Title | 20px | 24px | 600 | Dialog and modal title |
| Section Title | 13px | 14px | 600 | Default workspace section header |
| App Title | 13px | 14px | 600 | App bar and compact workspace labels |
| Emphasized Body | 13px | 14px | 600 | Primary action labels, key inline values |
| Body | 13px | 15px | 400 | Default workspace copy |
| Compact Body | 13px | 15px | 400 | Metadata rows, secondary descriptions |
| Caption | 12px | 16px | 400 | Helper text, chips, timestamps |
| Caption Strong | 12px | 16px | 600 | Status chips, nav labels, small emphasis |

### Usage Mapping

- app bars and compact workspace headers: 13px / 14px / 600
- page or card sections: 13px / 14px / 600
- primary forms and popups: 13px / 15px body, 13px / 14px emphasized actions, 20px titles
- status chips, breadcrumbs, helper text: 12px to 13px
- live monitoring metrics: 24px to 30px with tighter tracking and short line-height
- avoid introducing display text larger than 30px in product workspaces

### Default Compact Workspace Profile

- theme token name: `simple`
- section title: `13 / 14 / 600`
- compact body: `13 / 15 / 400`
- body medium: `13 / 15 / 400`
- emphasized body and button label: `13 / 14 / 600`
- page outer spacing: `0`
- standard section gap: `8`
- compact gap: `6`
- card radius: `6`
- input radius: `8`
- button radius: `8`
- dialog radius: `5`
- chip radius: `8`
- input height: `36`
- desktop button height: keep visual chrome at `28` to `32`; avoid 40px utility buttons in dense workspaces
- prefer tonal separation first, then ghost borders, then explicit borders
- in dense utility chrome, border-separated surfaces are allowed, but they should stay soft and low-contrast
- avoid full-pill nav by default in desktop utility workspaces
- use the same token family across desktop, mobile, and web; adapt spacing and radius by surface scale, not by inventing a new visual language

## Color System

### Light

#### Background

- App Background: `#F8F9FA`
- Subtle Background: `#F2F5F8`

#### Surface

- Surface: `#FFFFFF`
- Surface Alt / Card: `#F2F5F8`
- Surface Tertiary: `#E9EEF4`
- Border / Divider: `rgba(166, 180, 200, 0.15-0.2)`

#### Text

- Primary: `#1C1B1F`
- Secondary: `#667085`
- Tertiary / Subtle: `#98A1B2`
- Surface Variant: `#49454F`

#### Accent

- Primary Accent: `#0058BD`
- Primary Accent Soft: `#E8F0FB`
- Positive: `#34A853`
- Warning: `#8F4A00`
- Error: `#C3655C`
- Download Metric: `#5B8DEF`
- Upload Metric: `#DA6A87`
- Warning Banner Background: `#FFF3CD`
- Warning Banner Border: `#FFE69C`
- Warning Banner Text: `#664D03`

### Dark

#### Background

- App Background: `#141422`

#### Surface

- Surface: `#171C28`
- Surface Alt / Card: `#1E2433`
- Surface Tertiary: `#262D3F`
- Border / Divider: `rgba(202, 196, 208, 0.15-0.25)`

#### Text

- Primary: `#E6E1E5`
- Secondary: `#B0B8C8`
- Tertiary / Subtle: `#8B95A8`
- Surface Variant: `#CAC4D0`

#### Accent

- Primary Accent: `#4B8FE8`
- Primary Accent Container: `#1C3355`
- Positive: `#5CB978`
- Warning: `#E0AE5A`
- Error: `#EF9A9A`
- Download Metric: `#82AAFF`
- Upload Metric: `#EF9AAF`
- Warning Banner Background: `#3D3520`
- Warning Banner Border: `#5C5030`
- Warning Banner Text: `#FFE082`

### Color Rules

- prefer semantic tokens over decorative palette picks
- app chrome should be driven by `surface`, `surfaceAlt`, and `border`
- primary actions use brand; live traffic metrics may use download/upload accents
- success, warning, and error are status semantics, not general decoration colors
- keep contrast compatible with desktop utility UI; avoid neon accents and glossy gradients by default
- never use pure white as the universal page canvas; reserve it for the lowest container tier
- active gradients should be subtle and mostly reserved for CTAs or floating companion surfaces
- hover states may brighten toward `surface-bright` instead of adding heavier borders

## Depth And Separation

### Layering Principle

- Base: app background / surface
- Mid-ground: sidebars, assistant docks, grouped utility panels
- Foreground: active cards, forms, inputs, selected rows

### Separation Rules

- prefer spacing tokens `8` and `12` before adding visual separators
- use tonal shifts to define major sections
- use ghost borders around controls that need explicit affordance
- reserve stronger borders for dense admin tables, form fields, or precision tooling

### Glass And Shadow Signature

- floating companion panels may use frosted or glass surfaces
- backdrop blur should usually stay in the `8px` to `12px` range
- ambient shadows should be diffused, at least `20px` blur, and slightly tinted toward accent or surface hue
- avoid standard hard drop shadows

## Component Rules

### Buttons

- Height: 28px to 32px in dense desktop workspaces
- Padding: 10px 6px to 10px 10px depending on icon density
- Radius: 8px
- Primary buttons may be filled brand surfaces
- primary buttons may also use a subtle accent gradient when the host product wants a higher-intent CTA
- Secondary buttons may use subtle filled surfaces
- Borders are allowed when they reflect `cardBorder` or semantic outline use
- Prefer borders over shadows in workspace chrome; shadow should stay minimal and often omitted

#### Button States

- default
  - background: `surfaceAlt`
  - border: optional `border`
- hover
  - background: slightly darkened `surfaceAlt`
- active
  - inner shadow
  - slight scale: `0.98`
- primary
  - background: primary accent
  - text: white

### Cards

- Standard Radius: 6px
- Monitoring / hero cards: 12px to 16px
- Compact icon wells / badges: 6px to 8px
- Padding: 8px to 12px for workspace panels
- Background: `surfaceAlt` for utility panels, `surface` for plain containers
- Border: use `border` for panel separation
- Shadow: optional; border-first separation is the default
- internal dividers should be avoided; split sections with inset tonal blocks or spacing
- friendly larger radii are acceptable for mobile shells, dashboard hero cards, and floating workspace surfaces

### Assistant Dock / Companion Panel

- treat persistent AI panels as a companion surface, not a generic sidebar
- allow glass treatment, softer depth, and slightly more generous radius than utility panels
- input rows may use fuller rounding than the surrounding workspace
- AI responses and user responses should be separated by fill hierarchy, not heavy outlines

### Pill Navigation

- Do not default to full-pill grouping in dense desktop workspaces
- Selected items should shift from outline to filled treatment
- Use weight and filled shape to indicate the current destination
- Avoid adding extra dividers or rigid strokes inside the control
- Default chip and nav radius should be `8px`; reserve full-pill shapes for marketing or onboarding contexts only

### Radius System

- 5px: dialogs and tightly packed modal shells
- 6px: cards and utility panels
- 8px: inputs, buttons, nav chips, compact controls
- 12px to 16px: large monitoring cards and emphasized panels only
- full-pill radius is opt-in, not default

### Icon System

- Size: 24x24
- Stroke: 1.5px to 2px

#### Icon States

- inactive: outline
- active: filled

## Interaction

- Transition: 120ms to 240ms
- Easing: ease-in-out
- Hover: +2% brightness
- Active: scale `0.98`, shadow depth reduced
- Focus: scale `1.02`
- use motion to clarify touchability and focus shifts, not as decoration

## Logo System

The logo system defines three fixed brand forms:

- `icon`
- `wordmark`
- `hero`

### Product Rules

- Product workspaces should use a compact lockup only
- Allowed default product forms:
  - icon
  - icon + wordmark
- Do not use a large stacked hero title with logo in the working area
- `hero` is reserved for launch examples, marketing surfaces, or external showcase screens
- Starter kits use `Console` as the default placeholder wordmark so the skill stays product-agnostic

### Visual Direction

- geometric, rounded, calm
- soft lighting, not glossy chrome
- clear silhouette at small sizes
- state can shift between outline and filled
- brand should feel tactile, not aggressive

### Placement Guidance

- Sidebar / compact nav: `icon`
- Header brand lockup: `icon + wordmark`
- Startup / showcase / skill demo: `hero`
- Status chips and task rows: never use the hero mark

## AI Control Interface

This skill is designed for AI-reconfigurable interfaces. The control layer should expose simple actions that can change hierarchy and focus without changing the design language.

```json
{
  "skill": "ui_reconfigure",
  "actions": [
    "focus_metric",
    "collapse_metrics",
    "highlight_issue",
    "switch_mode"
  ]
}
```

### Expected AI Behaviors

- `focus_metric`
  - enlarge one metric or panel
- `collapse_metrics`
  - compress secondary cards into smaller rows or pills
- `highlight_issue`
  - raise severity using hierarchy and context, not loud color blocks
- `switch_mode`
  - switch between overview, focus, compact, and insight modes

## Implementation Notes

- Prefer soft surfaces over visible strokes
- Use shadows and fill changes to separate hierarchy
- Keep workspace headers compact
- Maintain consistent typography and spacing across desktop and mobile
- When in doubt, remove decoration before adding more
- when adapting to web, preserve the same palette, radius logic, and hierarchy rules instead of introducing a separate website aesthetic
- for desktop, bias toward denser spacing and quieter chrome
- for mobile, keep the same materials and tokens but allow larger radii and slightly softer spacing
- for product sites or showcase pages, the editorial layer may expand, but the core palette and tonal logic should still match the app surfaces
