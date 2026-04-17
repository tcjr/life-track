import { z } from 'zod';
import { type DocumentInput, type DocumentOutput } from 'zod-firebase';

export const WeightMeasurementSchema = z.object({
  value: z.number(), // lbs
  timestamp: z.date(),
});

export type WeightMeasurement = DocumentOutput<typeof WeightMeasurementSchema>;
export type WeightMeasurementInput = DocumentInput<
  typeof WeightMeasurementSchema
>;
