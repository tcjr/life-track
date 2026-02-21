import { z } from 'zod';
import { type DocumentInput, type DocumentOutput } from 'zod-firebase';

// Not sure how elaborate I want this yet.
// Mostly just a timestamp placeholder for now.
export const MealSchema = z.object({
  notes: z.string().optional(),
  timestamp: z.date(),
});

export type Meal = DocumentOutput<typeof MealSchema>;
export type MealInput = DocumentInput<typeof MealSchema>;
