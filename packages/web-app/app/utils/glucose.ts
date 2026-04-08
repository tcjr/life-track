import type { GlucoseMeasurement } from '#app/models/measurements/glucose.ts';
import { scaleThreshold } from 'd3-scale';

// eslint-disable-next-line @typescript-eslint/no-unused-vars
const GLUCOSE_QUALITIES = ['low', 'normal', 'elevated', 'high'] as const;
export type GlucoseQuality = (typeof GLUCOSE_QUALITIES)[number];

const postMealQualityScale = scaleThreshold<number, GlucoseQuality>(
  [70, 180, 220],
  ['low', 'normal', 'elevated', 'high']
);

const fastQualityScale = scaleThreshold<number, GlucoseQuality>(
  [70, 130, 180],
  ['low', 'normal', 'elevated', 'high']
);

export const getGlucoseQuality = (
  glucose: Pick<GlucoseMeasurement, 'value' | 'context'>
): GlucoseQuality => {
  if (glucose.context === 'post-meal') {
    return postMealQualityScale(glucose.value);
  } else {
    return fastQualityScale(glucose.value);
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
