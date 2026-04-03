import type { BpMeasurement } from '#app/models/measurements/bp.ts';
import type { GlucoseMeasurement } from '#app/models/measurements/glucose.ts';

export type BpQuality =
  | 'hypertension-crisis'
  | 'hypertension-2'
  | 'hypertension-1'
  | 'elevated'
  | 'normal'
  | 'low';

export type GlucoseQuality = 'high' | 'elevated' | 'normal' | 'low';

export const getBpQuality = (
  bp: Pick<BpMeasurement, 'systolic' | 'diastolic'>
): BpQuality => {
  const { systolic, diastolic } = bp;
  if (systolic > 180 || diastolic > 120) {
    return 'hypertension-crisis';
  }
  if (systolic >= 140 || diastolic >= 90) {
    return 'hypertension-2';
  }
  if (systolic >= 130 || diastolic >= 80) {
    return 'hypertension-1';
  }
  if (systolic >= 120 && diastolic < 80) {
    return 'elevated';
  }
  if (systolic < 90 || diastolic < 60) {
    return 'low';
  }
  return 'normal';
};

export const getGlucoseQuality = (
  glucose: Pick<GlucoseMeasurement, 'value'>
): GlucoseQuality => {
  if (glucose.value > 180) {
    return 'high';
  } else if (glucose.value > 140) {
    return 'elevated';
  } else if (glucose.value >= 80) {
    return 'normal';
  } else {
    return 'low';
  }
};

export const BP_STATUS_CLASSES: Record<BpQuality, string> = {
  'hypertension-crisis': 'status-error',
  'hypertension-2': 'status-error',
  'hypertension-1': 'status-warning',
  elevated: 'status-warning',
  normal: 'status-success',
  low: 'status-info',
};

export const BP_COLORS = {
  'hypertension-crisis': {
    bg: 'var(--color-error)',
    fg: 'var(--color-error-content)',
  },
  'hypertension-2': {
    bg: 'var(--color-error)',
    fg: 'var(--color-error-content)',
  },
  'hypertension-1': {
    bg: 'var(--color-warning)',
    fg: 'var(--color-warning-content)',
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
