import type { GlucoseMeasurement } from '#app/models/measurements/glucose.ts';

export type GlucoseQuality = 'high' | 'elevated' | 'normal' | 'low';

export const getGlucoseQuality = (
  glucose: Pick<GlucoseMeasurement, 'value' | 'context'>
): GlucoseQuality => {
  if (glucose.context === 'post-meal') {
    if (glucose.value > 220) {
      return 'high';
    } else if (glucose.value > 180) {
      return 'elevated';
    } else if (glucose.value >= 70) {
      return 'normal';
    } else {
      return 'low';
    }
  } else {
    if (glucose.value > 180) {
      return 'high';
    } else if (glucose.value > 130) {
      return 'elevated';
    } else if (glucose.value >= 70) {
      return 'normal';
    } else {
      return 'low';
    }
  }
};

export const GLUCOSE_COLORS = {
  high: {
    bg: 'var(--color-error)',
    fg: 'var(--color-error-content)',
  },
  elevated: {
    bg: 'var(--color-warning)',
    fg: 'var(--color-warning-content)',
  },
  low: {
    bg: 'var(--color-info)',
    fg: 'var(--color-info-content)',
  },
  normal: {
    bg: 'var(--color-success)',
    fg: 'var(--color-success-content)',
  },
};

export const GLUCOSE_STATUS_CLASSES: Record<GlucoseQuality, string> = {
  high: 'status-error',
  elevated: 'status-warning',
  normal: 'status-success',
  low: 'status-info',
};

const GLUCOSE_CONTEXT = {
  fasting: { name: 'Fasting' },
  'post-meal': { name: 'Post-Meal' },
  other: { name: 'Other' },
};

export const getGlucoseContextName = (context?: string) => {
  if (!context) {
    return 'Unknown';
  }
  return GLUCOSE_CONTEXT[context as keyof typeof GLUCOSE_CONTEXT].name;
};
