import { z } from 'zod';
import { type DocumentInput, type DocumentOutput } from 'zod-firebase-admin';

export const GlucoseSchema = z.object({
  value: z.number(),
  timestamp: z.date(),
});

export type Glucose = DocumentOutput<typeof GlucoseSchema>;
export type GlucoseInput = DocumentInput<typeof GlucoseSchema>;
