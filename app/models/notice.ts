import { z } from 'zod';
import { type DocumentInput, type DocumentOutput } from 'zod-firebase';

export const NoticeSchema = z.object({
  text: z.string(),
  startAt: z.date(),
  endAt: z.date(),
});

export type Notice = DocumentOutput<typeof NoticeSchema>;
export type NoticeInput = DocumentInput<typeof NoticeSchema>;
