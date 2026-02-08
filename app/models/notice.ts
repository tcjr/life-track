import { z } from 'zod';
import { zodFirestoreConverter } from './utils';

export const NoticeSchema = z.object({
  text: z.string(),
  startAt: z.date(),
  endAt: z.date(),
});

export type Notice = z.infer<typeof NoticeSchema> & { id: string };

export const noticeConverter = zodFirestoreConverter(NoticeSchema);
