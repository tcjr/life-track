import type { BpMeasurement } from '#app/models/measurements/bp.ts';
import type { GlucoseMeasurement } from '#app/models/measurements/glucose.ts';
import type { WeightMeasurement } from '#app/models/measurements/weight.ts';

export interface BpKind {
  kind: 'bp';
  measurement: BpMeasurement;
}

export interface GlucoseKind {
  kind: 'glucose';
  measurement: GlucoseMeasurement;
}

export interface WeightKind {
  kind: 'weight';
  measurement: WeightMeasurement;
}
