import type { WeightMeasurement } from '#app/models/measurements/weight.ts';

// We just assume a single quality for weight for now
export type WeightQuality = 'normal';

export const getWeightQuality = (
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  weight: Pick<WeightMeasurement, 'value'>
): WeightQuality => {
  return 'normal';
};

export const WEIGHT_COLORS = {
  normal: {
    bg: 'var(--color-neutral)',
    fg: 'var(--color-neutral-content)',
  },
};

export const WEIGHT_STATUS_CLASSES: Record<WeightQuality, string> = {
  normal: 'status-neutral',
};
