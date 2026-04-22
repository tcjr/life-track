import type { BpMeasurement } from '#app/models/measurements/bp.ts';

export type BpQuality =
  | 'hypertension-crisis'
  | 'hypertension-2'
  | 'hypertension-1'
  | 'elevated'
  | 'normal'
  | 'low';

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
    bgClass: 'bg-error',
  },
  'hypertension-2': {
    bg: 'var(--color-error)',
    fg: 'var(--color-error-content)',
    bgClass: 'bg-error',
  },
  'hypertension-1': {
    bg: 'var(--color-warning)',
    fg: 'var(--color-warning-content)',
    bgClass: 'bg-warning',
  },
  elevated: {
    bg: 'var(--color-warning)',
    fg: 'var(--color-warning-content)',
    bgClass: 'bg-warning',
  },
  low: {
    bg: 'var(--color-info)',
    fg: 'var(--color-info-content)',
    bgClass: 'bg-info',
  },
  normal: {
    bg: 'var(--color-success)',
    fg: 'var(--color-success-content)',
    bgClass: 'bg-success',
  },
};
