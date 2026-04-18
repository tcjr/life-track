import { z } from 'zod';
import { type DocumentInput, type DocumentOutput } from 'zod-firebase-admin';

export const WeightSchema = z.object({
  value: z.number(), // lbs
  timestamp: z.date(),
});

export type Weight = DocumentOutput<typeof WeightSchema>;
export type WeightInput = DocumentInput<typeof WeightSchema>;
