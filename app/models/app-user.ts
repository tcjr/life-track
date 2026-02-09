import { z } from 'zod';
import { type DocumentInput, type DocumentOutput } from 'zod-firebase';

export const AppUserSchema = z.object({
  isSetup: z.boolean(),
  theme: z.enum(['light', 'dark', 'system']),
});

export type AppUser = DocumentOutput<typeof AppUserSchema>;
export type AppUserInput = DocumentInput<typeof AppUserSchema>;
