import { z } from 'zod';
import { type DocumentInput, type DocumentOutput } from 'zod-firebase';

export const GlucoseMeasurementSchema = z.object({
  value: z.number(),
  //unit: z.enum(['mg/dL', 'mmol/L']),
  timestamp: z.date(),
});

export type GlucoseMeasurement = DocumentOutput<
  typeof GlucoseMeasurementSchema
>;
export type GlucoseMeasurementInput = DocumentInput<
  typeof GlucoseMeasurementSchema
>;
