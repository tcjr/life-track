import { z } from 'zod';
import { type DocumentInput, type DocumentOutput } from 'zod-firebase';

export const BpMeasurementSchema = z.object({
  systolic: z.number(),
  diastolic: z.number(),
  heartRate: z.number(),
  timestamp: z.date(),
});

export type BpMeasurement = DocumentOutput<typeof BpMeasurementSchema>;
export type BpMeasurementInput = DocumentInput<typeof BpMeasurementSchema>;
