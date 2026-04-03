import { z } from 'zod';
import { type DocumentInput, type DocumentOutput } from 'zod-firebase';

export const GlucoseMeasurementSchema = z.object({
  value: z.number(),
  timestamp: z.date(),
  context: z.enum(['fasting', 'post-meal', 'other']).optional(),
});

export type GlucoseMeasurement = DocumentOutput<
  typeof GlucoseMeasurementSchema
>;
export type GlucoseMeasurementInput = DocumentInput<
  typeof GlucoseMeasurementSchema
>;
