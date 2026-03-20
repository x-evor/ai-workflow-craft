import React from 'react';
import { colors, radii, shadows } from '../theme';

export interface CardProps {
  /**
   * The contents of the card.
   */
  children: React.ReactNode;
  /**
   * Additional inline styles to apply.
   */
  style?: React.CSSProperties;
}

/**
 * A simple card container with soft edges and subtle shadow.
 */
const Card: React.FC<CardProps> = ({ children, style }) => {
  return (
    <div
      style={{
        backgroundColor: colors.surfaceAlt,
        borderRadius: radii.card,
        padding: 16,
        border: `1px solid ${colors.border}`,
        boxShadow: shadows.card,
        ...style,
      }}
    >
      {children}
    </div>
  );
};

export default Card;
