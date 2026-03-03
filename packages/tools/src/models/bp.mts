import { z } from 'zod';
import { type DocumentInput, type DocumentOutput } from 'zod-firebase-admin';

export const BpSchema = z.object({
  systolic: z.number(),
  diastolic: z.number(),
  heartRate: z.number(),
  timestamp: z.date(),
});

export type Bp = DocumentOutput<typeof BpSchema>;
export type BpInput = DocumentInput<typeof BpSchema>;
