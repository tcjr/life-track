import { z } from 'zod';
import { type DocumentInput, type DocumentOutput } from 'zod-firebase';
import { BpMeasurementSchema } from './measurements/bp';
import { GlucoseMeasurementSchema } from './measurements/glucose';
import { MealSchema } from './measurements/meal';

export const ReportSchema = z.object({
  title: z.string(),
  userId: z.string(),
  startDate: z.date(),
  endDate: z.date(),
  createdAt: z.date(),
  data: z.object({
    bps: z.array(BpMeasurementSchema).optional(),
    glucoses: z.array(GlucoseMeasurementSchema).optional(),
    meals: z.array(MealSchema).optional(),
  }),
});

export type Report = DocumentOutput<typeof ReportSchema>;
export type ReportInput = DocumentInput<typeof ReportSchema>;
