import React from 'react';
import { colors, radii, shadows, typeScale } from '../theme';

export interface MetricCardProps {
  /**
   * Metric label, e.g. "Connection Stability".
   */
  label: string;
  /**
   * Metric value, e.g. "98%".
   */
  value: string;
  /**
   * Optional trend indicator, e.g. "↑ 4%".
   */
  trend?: string;
  /**
   * Visual state affecting colour.
   */
  state?: 'normal' | 'warning' | 'error' | 'positive';
}

const stateColor = (state: 'normal' | 'warning' | 'error' | 'positive' | undefined) => {
  switch (state) {
    case 'warning':
      return colors.accentWarning;
    case 'error':
      return colors.accentError;
    case 'positive':
      return colors.accentPositive;
    default:
      return colors.textInactive;
  }
};

/**
 * A compact card for displaying a single metric with a label, value and optional trend.
 */
const MetricCard: React.FC<MetricCardProps> = ({ label, value, trend, state = 'normal' }) => {
  return (
    <div
      style={{
        backgroundColor: colors.surface,
        borderRadius: radii.card,
        padding: 16,
        minWidth: 120,
        display: 'flex',
        flexDirection: 'column',
        boxShadow: shadows.card,
      }}
    >
      <span
        style={{
          fontSize: typeScale.caption.fontSize,
          lineHeight: typeScale.caption.lineHeight,
          color: colors.textSecondary,
        }}
      >
        <span
          style={{
            display: 'inline-flex',
            alignItems: 'center',
            gap: 8,
          }}
        >
          {state !== 'normal' && (
            <span
              aria-hidden="true"
              style={{
                width: 8,
                height: 8,
                borderRadius: '999px',
                backgroundColor: stateColor(state),
                flex: '0 0 auto',
              }}
            />
          )}
          <span>{label}</span>
        </span>
      </span>
      <span
        style={{
          marginTop: 6,
          fontSize: typeScale.title.fontSize,
          lineHeight: typeScale.title.lineHeight,
          fontWeight: 600,
          color: colors.textPrimary,
        }}
      >
        {value}
      </span>
      {trend && (
        <span
          style={{
            fontSize: typeScale.caption.fontSize,
            lineHeight: typeScale.caption.lineHeight,
            color: colors.textSecondary,
          }}
        >
          {trend}
        </span>
      )}
    </div>
  );
};

export default MetricCard;
