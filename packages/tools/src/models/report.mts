import { z } from 'zod';
import { type DocumentInput, type DocumentOutput } from 'zod-firebase-admin';
import { BpSchema } from './bp.mts';
import { GlucoseSchema } from './glucose.mts';
import { MealSchema } from './meal.mts';

export const ReportSchema = z.object({
  title: z.string(),
  userId: z.string(),
  startDate: z.date(),
  endDate: z.date(),
  createdAt: z.date(),
  data: z.object({
    bps: z.array(BpSchema).optional(),
    glucoses: z.array(GlucoseSchema).optional(),
    meals: z.array(MealSchema).optional(),
  }),
});

export type Report = DocumentOutput<typeof ReportSchema>;
export type ReportInput = DocumentInput<typeof ReportSchema>;
