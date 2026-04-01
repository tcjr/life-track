import { z } from 'zod';
import { type DocumentInput, type DocumentOutput } from 'zod-firebase-admin';

export const MealSchema = z.object({
  notes: z.string().optional(),
  timestamp: z.date(),
});

export type Meal = DocumentOutput<typeof MealSchema>;
export type MealInput = DocumentInput<typeof MealSchema>;
