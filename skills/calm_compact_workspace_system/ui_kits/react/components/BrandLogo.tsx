import React from 'react';
import { colors, motion, typeScale } from '../theme';

export type BrandLogoVariant = 'icon' | 'wordmark' | 'hero';
export type BrandLogoTheme = 'light' | 'dark';
export type BrandLogoState = 'outline' | 'filled';

export interface BrandLogoProps {
  variant?: BrandLogoVariant;
  theme?: BrandLogoTheme;
  state?: BrandLogoState;
  size?: number;
  wordmark?: string;
}

const BrandLogo: React.FC<BrandLogoProps> = ({
  variant = 'icon',
  theme = 'light',
  state = 'outline',
  size = 40,
  wordmark = 'Console',
}) => {
  const filled = state === 'filled';
  const ink = theme === 'dark' ? colors.darkTextPrimary : colors.textPrimary;
  const surface = theme === 'dark' ? colors.darkSurface : colors.surface;

  const icon = (
    <span
      aria-hidden="true"
      style={{
        width: size,
        height: size,
        borderRadius: size * 0.28,
        backgroundColor: filled ? ink : surface,
        boxShadow: `0 2px 8px rgba(0,0,0,0.04)`,
        display: 'inline-flex',
        alignItems: 'center',
        justifyContent: 'center',
        position: 'relative',
        transition: `transform ${motion.default} ${motion.easing}`,
      }}
    >
      <span
        style={{
          width: size * 0.54,
          height: size * 0.24,
          borderRadius: size * 0.12,
          backgroundColor: filled ? surface : ink,
          display: 'inline-flex',
          alignItems: 'center',
          justifyContent: 'space-evenly',
          color: filled ? colors.accentPrimary : surface,
        }}
      >
        <span
          style={{
            width: size * 0.09,
            height: size * 0.09,
            borderRadius: '999px',
            backgroundColor: filled ? colors.accentPrimary : surface,
          }}
        />
        <span
          style={{
            width: size * 0.09,
            height: size * 0.09,
            borderRadius: '999px',
            backgroundColor: filled ? colors.accentPrimary : surface,
          }}
        />
      </span>
      <span
        style={{
          position: 'absolute',
          top: size * 0.08,
          right: size * 0.08,
          width: size * 0.18,
          height: size * 0.18,
          borderRadius: filled ? size * 0.08 : '999px',
          backgroundColor: colors.accentPrimary,
        }}
      />
      {!filled && (
        <span
          style={{
            position: 'absolute',
            inset: 0,
            borderRadius: size * 0.28,
            boxSizing: 'border-box',
            border: `2px solid ${ink}`,
          }}
        />
      )}
    </span>
  );

  if (variant === 'icon') {
    return icon;
  }

  if (variant === 'wordmark') {
    return (
      <span
        style={{ display: 'inline-flex', alignItems: 'center', gap: 10 }}
      >
        {icon}
        <span
          style={{
            color: ink,
            fontSize: size * 0.42,
            lineHeight: 1.3,
            fontWeight: 600,
          }}
        >
          {wordmark}
        </span>
      </span>
    );
  }

  return (
    <span
      style={{
        display: 'inline-flex',
        flexDirection: 'column',
        alignItems: 'center',
        gap: 12,
      }}
    >
      <BrandLogo
        variant="icon"
        theme={theme}
        state={state}
        size={size * 1.28}
        wordmark={wordmark}
      />
      <span
        style={{
          color: ink,
          fontSize: typeScale.title.fontSize,
          lineHeight: typeScale.title.lineHeight,
          fontWeight: typeScale.title.fontWeight,
        }}
      >
        {wordmark}
      </span>
    </span>
  );
};

export default BrandLogo;
