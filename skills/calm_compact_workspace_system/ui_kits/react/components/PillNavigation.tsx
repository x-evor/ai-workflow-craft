import React from 'react';
import { colors, motion, radii, shadows, typeScale } from '../theme';

export interface PillItem {
  key: string;
  label: string;
  icon?: React.ReactNode;
  activeIcon?: React.ReactNode;
}

export interface PillNavigationProps {
  /**
   * List of navigation items.
   */
  items: PillItem[];
  /**
   * Key of the currently selected item.
   */
  selectedKey: string;
  /**
   * Called when a new item is selected.
   */
  onSelect: (key: string) => void;
}

/**
 * A pill‑style navigation bar.  Active items are filled and inactive items show only an outline/icon.
 */
const PillNavigation: React.FC<PillNavigationProps> = ({
  items,
  selectedKey,
  onSelect,
}) => {
  return (
    <div
      style={{
        display: 'inline-flex',
        backgroundColor: colors.surfaceAlt,
        borderRadius: radii.pill,
        padding: 4,
        boxShadow: shadows.card,
      }}
    >
      {items.map((item) => {
        const active = item.key === selectedKey;
        return (
          <button
            key={item.key}
            onClick={() => onSelect(item.key)}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: 8,
              minHeight: 40,
              padding: '10px 14px',
              borderRadius: radii.pill,
              border: 'none',
              backgroundColor: active ? colors.surface : 'transparent',
              color: active ? colors.textPrimary : colors.textSecondary,
              fontSize: typeScale.body.fontSize,
              lineHeight: typeScale.body.lineHeight,
              fontWeight: active ? 600 : 400,
              cursor: 'pointer',
              transition: `all ${motion.default} ${motion.easing}`,
              boxShadow: active ? shadows.control : 'none',
            }}
          >
            {(active ? item.activeIcon ?? item.icon : item.icon) && (
              <span>{active ? item.activeIcon ?? item.icon : item.icon}</span>
            )}
            <span>{item.label}</span>
          </button>
        );
      })}
    </div>
  );
};

export default PillNavigation;
