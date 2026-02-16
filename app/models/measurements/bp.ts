import { z } from 'zod';
import { type DocumentInput, type DocumentOutput } from 'zod-firebase';

export const BpMeasurementSchema = z.object({
  systolic: z.number(),
  diastolic: z.number(),
  heartRate: z.number(),
  timestamp: z.date(),
});

export type Bp = DocumentOutput<typeof BpMeasurementSchema>;
export type BpInput = DocumentInput<typeof BpMeasurementSchema>;
