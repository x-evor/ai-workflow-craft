import React from 'react';
import { colors, motion, radii, shadows, typeScale } from '../theme';

export interface ButtonProps {
  /**
   * The content of the button.
   */
  children: React.ReactNode;
  /**
   * Use the primary variant for main actions.  Defaults to 'default'.
   */
  variant?: 'primary' | 'default';
  /**
   * Click handler.
   */
  onClick?: () => void;
}

/**
 * A soft, tactile button component following the design guidelines.
 * It uses shape and subtle shadows rather than strong borders.
 */
const Button: React.FC<ButtonProps> = ({
  children,
  variant = 'default',
  onClick,
}) => {
  const [hovered, setHovered] = React.useState(false);
  const [pressed, setPressed] = React.useState(false);
  const [focused, setFocused] = React.useState(false);

  const baseStyle: React.CSSProperties = {
    minHeight: 40,
    padding: '12px 16px',
    borderRadius: radii.button,
    border: 'none',
    cursor: 'pointer',
    fontSize: typeScale.body.fontSize,
    lineHeight: typeScale.body.lineHeight,
    fontWeight: 600,
    transition: `all ${motion.default} ${motion.easing}`,
    backgroundColor: variant === 'primary'
      ? colors.accentPrimary
      : hovered
      ? colors.hoverSurface
      : colors.surfaceAlt,
    color: variant === 'primary' ? '#FFFFFF' : colors.textPrimary,
    outline: 'none',
    border: variant === 'primary' ? 'none' : `1px solid ${colors.border}`,
    boxShadow: pressed ? shadows.pressed : shadows.control,
  };

  return (
    <button
      style={{
        ...baseStyle,
        transform: pressed
          ? 'scale(0.98)'
          : focused
          ? 'scale(1.02)'
          : 'scale(1)',
      }}
      onMouseEnter={() => setHovered(true)}
      onMouseLeave={() => {
        setHovered(false);
        setPressed(false);
      }}
      onMouseDown={() => setPressed(true)}
      onMouseUp={() => setPressed(false)}
      onFocus={() => setFocused(true)}
      onBlur={() => {
        setFocused(false);
        setPressed(false);
      }}
      onClick={onClick}
    >
      {children}
    </button>
  );
};

export default Button;
