import { z } from 'zod';
import { type DocumentInput, type DocumentOutput } from 'zod-firebase';
import { BpMeasurementSchema } from './measurements/bp';
import { GlucoseMeasurementSchema } from './measurements/glucose';

export const ReportSchema = z.object({
  title: z.string(),
  userId: z.string(),
  startDate: z.date(),
  endDate: z.date(),
  createdAt: z.date(),
  bps: z.array(BpMeasurementSchema),
  glucoses: z.array(GlucoseMeasurementSchema),
});

export type Report = DocumentOutput<typeof ReportSchema>;
export type ReportInput = DocumentInput<typeof ReportSchema>;
