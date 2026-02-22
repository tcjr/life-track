import { z } from 'zod';
import { type DocumentInput, type DocumentOutput } from 'zod-firebase';

export const NoticeSchema = z.object({
  text: z.string(),
  validFrom: z.date(),
  validTo: z.date(),
});

export type Notice = DocumentOutput<typeof NoticeSchema>;
export type NoticeInput = DocumentInput<typeof NoticeSchema>;
